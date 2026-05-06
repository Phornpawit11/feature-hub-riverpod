import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  restoring,
  unauthenticated,
  authenticating,
  awaitingEmailVerification,
  authenticated,
  failure,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    AuthUser? user,
    String? verificationId,
    String? pendingEmail,
    DateTime? resendAvailableAt,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  bool get isBusy =>
      status == AuthStatus.restoring || status == AuthStatus.authenticating;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAwaitingEmailVerification =>
      status == AuthStatus.awaitingEmailVerification;

  AuthState clearError({
    AuthStatus? status,
    AuthUser? user,
    String? verificationId,
    String? pendingEmail,
    DateTime? resendAvailableAt,
    bool clearUser = false,
    bool clearPendingVerification = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      verificationId: clearPendingVerification
          ? null
          : (verificationId ?? this.verificationId),
      pendingEmail: clearPendingVerification
          ? null
          : (pendingEmail ?? this.pendingEmail),
      resendAvailableAt: clearPendingVerification
          ? null
          : (resendAvailableAt ?? this.resendAvailableAt),
    );
  }

  static const AuthState restoring = AuthState(status: AuthStatus.restoring);
  static const AuthState unauthenticated = AuthState(
    status: AuthStatus.unauthenticated,
  );
}
