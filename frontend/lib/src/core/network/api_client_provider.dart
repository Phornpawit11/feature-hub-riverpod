import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_error_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_success_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/refresh_token_request.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';

final apiBaseUrlProvider = Provider<String>((ref) {
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) {
    return override;
  }

  final platform = defaultTargetPlatform;
  if (!kIsWeb && platform == TargetPlatform.android) {
    return 'http://10.0.2.2:3000/api';
  }

  return 'http://localhost:3000/api';
});

BaseOptions _buildBaseOptions(String baseUrl) {
  return BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: const {'Content-Type': 'application/json'},
  );
}

class AuthSessionCoordinator {
  AuthSessionCoordinator(this.ref, this._dio, this._storage);

  final Ref ref;
  final Dio _dio;
  final SecureTokenStorage _storage;

  Future<String>? _refreshAccessTokenFuture;

  Future<String> refreshAccessToken() {
    final inFlight = _refreshAccessTokenFuture;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _performRefresh();
    _refreshAccessTokenFuture = future;
    return future.whenComplete(() {
      if (identical(_refreshAccessTokenFuture, future)) {
        _refreshAccessTokenFuture = null;
      }
    });
  }

  Future<String> _performRefresh() async {
    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await expireSession();
      throw const AuthException(
        'Session expired. Please sign in again.',
        statusCode: 401,
      );
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: RefreshTokenRequest(refreshToken: refreshToken).toJson(),
      );
      final session = _parseSession(response.data);

      await _storage.writeTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      ref.read(authUsecaseProvider.notifier).setAuthenticatedSession(session);

      return session.accessToken;
    } on DioException catch (error) {
      await expireSession();
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    } catch (_) {
      await expireSession();
      rethrow;
    }
  }

  Future<void> expireSession() async {
    await _storage.clearTokens();
    ref.read(authUsecaseProvider.notifier).expireSession();
  }

  AuthSession _parseSession(Map<String, dynamic>? data) {
    if (data == null) {
      throw const AuthException('Invalid server response.');
    }

    final response = AuthSuccessResponse.fromJson(data);
    if (response.accessToken.isEmpty || response.refreshToken.isEmpty) {
      throw const AuthException('Invalid server response.');
    }

    return AuthSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      user: response.user,
    );
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final errorResponse = AuthErrorResponse.fromJson(data);

      if (errorResponse.message case final message? when message.isNotEmpty) {
        return message;
      }
      if (errorResponse.messageList.isNotEmpty) {
        return errorResponse.messageList.join(', ');
      }
    }

    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        'Unable to reach the server. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }
}

final authRawDioProvider = Provider<Dio>((ref) {
  return Dio(_buildBaseOptions(ref.watch(apiBaseUrlProvider)));
});

final authSessionCoordinatorProvider = Provider<AuthSessionCoordinator>((ref) {
  return AuthSessionCoordinator(
    ref,
    ref.watch(authRawDioProvider),
    ref.watch(secureTokenStorageProvider),
  );
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_buildBaseOptions(ref.watch(apiBaseUrlProvider)));
  final storage = ref.watch(secureTokenStorageProvider);
  final coordinator = ref.watch(authSessionCoordinatorProvider);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!_isRefreshManagedPath(options.path) &&
            options.headers['Authorization'] == null) {
          final accessToken = await storage.readAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        final requestOptions = error.requestOptions;

        if (!_shouldRefresh(error)) {
          handler.next(error);
          return;
        }

        try {
          final accessToken = await coordinator.refreshAccessToken();
          requestOptions.headers['Authorization'] = 'Bearer $accessToken';
          requestOptions.extra['authRetried'] = true;

          final response = await dio.fetch<dynamic>(requestOptions);
          handler.resolve(response);
        } on AuthException {
          handler.next(error);
        } catch (_) {
          handler.next(error);
        }
      },
    ),
  );
  dio.interceptors.add(
    PrettyDioLogger(
      request: true,
      requestHeader: false,
      requestBody: false,
      responseHeader: false,
      error: true,
      compact: true,
      logPrint: (message) => debugPrint(message.toString()),
    ),
  );
  return dio;
});

bool _shouldRefresh(DioException error) {
  final statusCode = error.response?.statusCode;
  final requestOptions = error.requestOptions;

  return statusCode == 401 &&
      !_isRefreshManagedPath(requestOptions.path) &&
      requestOptions.extra['authRetried'] != true;
}

bool _isRefreshManagedPath(String path) {
  return path.endsWith('/auth/login') ||
      path.endsWith('/auth/google') ||
      path.endsWith('/auth/refresh') ||
      path.endsWith('/auth/logout');
}
