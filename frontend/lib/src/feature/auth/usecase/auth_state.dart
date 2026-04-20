import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

enum AuthStatus {
  restoring,
  unauthenticated,
  authenticating,
  authenticated,
  failure,
}

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  bool get isBusy =>
      status == AuthStatus.restoring || status == AuthStatus.authenticating;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static const AuthState restoring = AuthState(status: AuthStatus.restoring);
  static const AuthState unauthenticated = AuthState(
    status: AuthStatus.unauthenticated,
  );
}
