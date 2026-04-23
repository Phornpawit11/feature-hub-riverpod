import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/network/api_client_provider.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_error_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_success_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/check_email_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/check_email_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/google_login_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/login_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/logout_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/register_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/refresh_token_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/update_profile_request.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_remote_datasource.g.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<bool> checkEmailAvailability({required String email}) async {
    try {
      final request = CheckEmailRequest(email: email);
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/check-email',
        data: request.toJson(),
      );

      return CheckEmailResponse.fromJson(response.data ?? const {}).available;
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    } on FormatException {
      throw const AuthException('Invalid server response.');
    }
  }

  Future<AuthUser> updateProfile({
    required String displayName,
    required String accessToken,
  }) async {
    try {
      final request = UpdateProfileRequest(displayName: displayName);
      final response = await _dio.patch<Map<String, dynamic>>(
        '/auth/profile',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return AuthUser.fromJson(response.data ?? const {});
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<AuthSession> registerWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        displayName: displayName,
        email: email,
        password: password,
      );
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: request.toJson(),
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<AuthSession> signInWithGoogle({required String idToken}) async {
    try {
      final request = GoogleLoginRequest(idToken: idToken);
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/google',
        data: request.toJson(),
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
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
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<AuthSession> refreshSession({required String refreshToken}) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: request.toJson(),
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      final request = LogoutRequest(refreshToken: refreshToken);
      await _dio.post<Map<String, dynamic>>(
        '/auth/logout',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw AuthException(
        _extractErrorMessage(error),
        statusCode: error.response?.statusCode,
      );
    }
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

@Riverpod(keepAlive: true)
AuthRemoteDatasource authRemoteDatasource(Ref ref) {
  return AuthRemoteDatasource(ref.watch(authRawDioProvider));
}
