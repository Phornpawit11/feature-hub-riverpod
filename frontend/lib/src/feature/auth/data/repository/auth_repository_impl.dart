import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';

part 'auth_repository_impl.g.dart';

@riverpod
class AuthRepositoryImpl extends _$AuthRepositoryImpl
    implements AuthRepository {
  AuthRemoteDatasource get _remoteDatasource =>
      ref.watch(authRemoteDatasourceProvider);
  GoogleSignInAdapter get _googleSignInAdapter =>
      ref.watch(googleSignInAdapterProvider);
  @override
  FutureOr<void> build() {
    ref.keepAlive();
  }

  @override
  Future<AuthUser> getCurrentUser(String accessToken) {
    return _remoteDatasource.getCurrentUser(accessToken);
  }

  @override
  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  }) {
    return _remoteDatasource.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    final idToken = await _googleSignInAdapter.getIdToken();
    return _remoteDatasource.signInWithGoogle(idToken: idToken);
  }
}
