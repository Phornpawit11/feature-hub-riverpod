import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/data/providers/auth_repository_provider.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

part 'auth_usecase.g.dart';

@Riverpod(keepAlive: true)
class AuthUsecase extends _$AuthUsecase {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  SecureTokenStorage get _storage => ref.read(secureTokenStorageProvider);

  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return AuthState.restoring;
  }

  Future<void> restoreSession() async {
    state = state.copyWith(status: AuthStatus.restoring, clearError: true);

    final accessToken = await _storage.readAccessToken();
    final refreshToken = await _storage.readRefreshToken();

    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      state = AuthState.unauthenticated;
      return;
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      try {
        final user = await _repository.getCurrentUser(accessToken);
        state = AuthState(status: AuthStatus.authenticated, user: user);
        return;
      } on AuthException catch (error) {
        if (error.statusCode == null) {
          state = AuthState(
            status: AuthStatus.failure,
            errorMessage: error.message,
          );
          return;
        }

        if (error.statusCode != 401 ||
            refreshToken == null ||
            refreshToken.isEmpty) {
          await _storage.clearTokens();
          state = AuthState.unauthenticated;
          return;
        }
      } catch (_) {
        await _storage.clearTokens();
        state = AuthState.unauthenticated;
        return;
      }
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      await _storage.clearTokens();
      state = AuthState.unauthenticated;
      return;
    }

    try {
      final session = await _repository.refreshSession(
        refreshToken: refreshToken,
      );
      await _storage.writeTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      // ใช้ user จาก session โดยตรง — ไม่ต้องเรียก getCurrentUser ซ้ำ
      state = AuthState(status: AuthStatus.authenticated, user: session.user);
    } on AuthException catch (error) {
      if (error.statusCode == null) {
        state = AuthState(
          status: AuthStatus.failure,
          errorMessage: error.message,
        );
        return;
      }

      await _storage.clearTokens();
      state = AuthState.unauthenticated;
    } catch (_) {
      await _storage.clearTokens();
      state = AuthState.unauthenticated;
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating, clearError: true);

    try {
      final session = await _repository.signInWithEmailPassword(
        email: email.trim(),
        password: password,
      );
      await _storage.writeTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      setAuthenticatedSession(session);
    } on AuthException catch (error) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: error.message,
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<bool> checkEmailAvailability({required String email}) {
    return _repository.checkEmailAvailability(email: email.trim());
  }

  Future<void> registerWithEmailPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating, clearError: true);

    try {
      final session = await _repository.registerWithEmailPassword(
        displayName: displayName.trim(),
        email: email.trim(),
        password: password,
      );
      await _storage.writeTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      setAuthenticatedSession(session);
    } on AuthException catch (error) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: error.message,
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signInWithGoogle() async {
    if (!ref.read(isMobileGoogleSignInSupportedProvider)) {
      state = const AuthState(
        status: AuthStatus.failure,
        errorMessage:
            'Google sign-in is available on mobile only in this build.',
      );
      return;
    }

    state = state.copyWith(status: AuthStatus.authenticating, clearError: true);

    try {
      final session = await _repository.signInWithGoogle();
      await _storage.writeTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      setAuthenticatedSession(session);
    } on AuthException catch (error) {
      state = AuthState(
        status: AuthStatus.failure,
        errorMessage: error.message,
      );
    } catch (_) {
      state = const AuthState(
        status: AuthStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    // Revoke Google session (best-effort — ไม่ block logout ถ้า Google ล้มเหลว)
    try {
      await ref.read(googleSignInAdapterProvider).signOut();
    } catch (_) {}

    final refreshToken = await _storage.readRefreshToken();

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _repository.logout(refreshToken: refreshToken);
      } catch (_) {}
    }

    await _storage.clearTokens();
    state = AuthState.unauthenticated;
  }

  void clearError() {
    if (state.errorMessage == null && state.status != AuthStatus.failure) {
      return;
    }

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearError: true,
      clearUser: true,
    );
  }

  void setAuthenticatedSession(AuthSession session) {
    state = AuthState(status: AuthStatus.authenticated, user: session.user);
  }

  void expireSession() {
    state = AuthState.unauthenticated;
  }
}
