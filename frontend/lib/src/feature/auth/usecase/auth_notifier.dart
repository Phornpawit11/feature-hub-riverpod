import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/data/providers/auth_repository_provider.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  SecureTokenStorage get _storage => ref.read(secureTokenStorageProvider);

  @override
  AuthState build() {
    Future.microtask(restoreSession);
    return AuthState.restoring;
  }

  Future<void> restoreSession() async {
    state = state.copyWith(status: AuthStatus.restoring, clearError: true);

    final token = await _storage.readAccessToken();
    if (token == null || token.isEmpty) {
      state = AuthState.unauthenticated;
      return;
    }

    try {
      final user = await _repository.getCurrentUser(token);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } on AuthException {
      await _storage.clearAccessToken();
      state = AuthState.unauthenticated;
    } catch (_) {
      await _storage.clearAccessToken();
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
      await _storage.writeAccessToken(session.accessToken);
      state = AuthState(status: AuthStatus.authenticated, user: session.user);
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
      await _storage.writeAccessToken(session.accessToken);
      state = AuthState(status: AuthStatus.authenticated, user: session.user);
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
    await _storage.clearAccessToken();
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
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
