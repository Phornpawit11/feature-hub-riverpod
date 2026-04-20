import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/network/api_client_provider.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(_extractErrorMessage(error));
    }
  }

  Future<AuthSession> signInWithGoogle({required String idToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/google',
        data: {'idToken': idToken},
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(_extractErrorMessage(error));
    }
  }

  Future<AuthUser> getCurrentUser(String accessToken) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return AuthUser.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw AuthException(_extractErrorMessage(error));
    }
  }

  AuthSession _parseSession(Map<String, dynamic>? data) {
    if (data == null) {
      throw const AuthException('Invalid server response.');
    }

    final accessToken = data['accessToken'] as String?;
    final userJson = data['user'] as Map<String, dynamic>?;

    if (accessToken == null || accessToken.isEmpty || userJson == null) {
      throw const AuthException('Invalid server response.');
    }

    return AuthSession(
      accessToken: accessToken,
      user: AuthUser.fromJson(userJson),
    );
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      if (message is List && message.isNotEmpty) {
        return message.join(', ');
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

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.watch(dioProvider));
});
