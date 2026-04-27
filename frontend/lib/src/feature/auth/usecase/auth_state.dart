import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  restoring,
  unauthenticated,
  authenticating,
  authenticated,
  failure,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    AuthUser? user,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isBusy =>
      status == AuthStatus.restoring || status == AuthStatus.authenticating;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState clearError({
    AuthStatus? status,
    AuthUser? user,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: null,
    );
  }

  static const AuthState restoring = AuthState(status: AuthStatus.restoring);
  static const AuthState unauthenticated = AuthState(
    status: AuthStatus.unauthenticated,
  );
}
