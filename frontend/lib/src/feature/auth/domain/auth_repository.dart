import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_repository.freezed.dart';

abstract class AuthRepository {
  Future<bool> checkEmailAvailability({required String email});

  Future<AuthUser> updateProfile({required String displayName});

  Future<RegisterPendingSession> registerWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  });

  Future<AuthSession> verifyEmailOtp({
    required String verificationId,
    required String otp,
  });

  Future<RegisterPendingSession> resendEmailOtp({
    required String verificationId,
  });

  Future<RegisterPendingSession> signInPendingVerification({
    required String email,
    required String password,
  });

  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthSession> signInWithGoogle();

  Future<AuthSession> refreshSession({required String refreshToken});

  Future<void> logout({required String refreshToken});

  Future<AuthUser> getCurrentUser(String accessToken);
}

@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String accessToken,
    required String refreshToken,
    required AuthUser user,
  }) = _AuthSession;
}

class RegisterPendingSession {
  const RegisterPendingSession({
    required this.verificationId,
    required this.email,
    required this.resendAvailableInSeconds,
  });

  final String verificationId;
  final String email;
  final int resendAvailableInSeconds;

  DateTime get resendAvailableAt =>
      DateTime.now().add(Duration(seconds: resendAvailableInSeconds));
}

class AuthException implements Exception {
  const AuthException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
