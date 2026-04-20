import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/network/api_client_provider.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_error_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/auth_success_response.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/google_login_request.dart';
import 'package:todos_riverpod/src/feature/auth/data/model/login_request.dart';
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
      final request = LoginRequest(email: email, password: password);
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
      );

      return _parseSession(response.data);
    } on DioException catch (error) {
      throw AuthException(_extractErrorMessage(error));
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

    final response = AuthSuccessResponse.fromJson(data);
    if (response.accessToken.isEmpty) {
      throw const AuthException('Invalid server response.');
    }

    return AuthSession(
      accessToken: response.accessToken,
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

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.watch(dioProvider));
});
