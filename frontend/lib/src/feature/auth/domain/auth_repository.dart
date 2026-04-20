import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

abstract class AuthRepository {
  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AuthSession> signInWithGoogle();

  Future<AuthUser> getCurrentUser(String accessToken);
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.user,
  });

  final String accessToken;
  final AuthUser user;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
