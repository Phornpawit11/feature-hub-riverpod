import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';

part 'google_sign_in_adapter.g.dart';

class GoogleSignInConfiguration {
  const GoogleSignInConfiguration({this.clientId, this.serverClientId});

  final String? clientId;
  final String? serverClientId;
}

@visibleForTesting
GoogleSignInConfiguration resolveGoogleSignInConfiguration(
  AppEnv env, {
  TargetPlatform? platform,
  bool isWeb = kIsWeb,
}) {
  final resolvedPlatform = platform ?? defaultTargetPlatform;

  if (isWeb) {
    return GoogleSignInConfiguration(
      clientId: env.googleClientId,
      serverClientId: env.googleServerClientId,
    );
  }

  return switch (resolvedPlatform) {
    // Android requires the server/web client id for backend-auth flows.
    // Passing a mobile client id here can trigger configuration errors.
    TargetPlatform.android => GoogleSignInConfiguration(
      serverClientId: env.googleServerClientId,
    ),
    TargetPlatform.iOS => GoogleSignInConfiguration(
      clientId: env.googleClientId,
      serverClientId: env.googleServerClientId,
    ),
    _ => GoogleSignInConfiguration(
      clientId: env.googleClientId,
      serverClientId: env.googleServerClientId,
    ),
  };
}

class GoogleSignInAdapter {
  GoogleSignInAdapter(this._googleSignIn, this._env);

  final GoogleSignIn _googleSignIn;
  final AppEnv _env;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    final config = resolveGoogleSignInConfiguration(_env);

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      if (config.serverClientId == null) {
        throw const AuthException(
          'Missing GOOGLE_SERVER_CLIENT_ID for Android Google sign-in.',
        );
      }
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      if (config.clientId == null) {
        throw const AuthException(
          'Missing GOOGLE_CLIENT_ID for iOS Google sign-in.',
        );
      }
    }

    await _googleSignIn.initialize(
      clientId: config.clientId,
      serverClientId: config.serverClientId,
    );
    _isInitialized = true;
  }

  Future<void> signOut() async {
    if (!_isInitialized) return;
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // best-effort — ไม่ throw เพื่อไม่ให้ขัด logout flow หลัก
    }
  }

  Future<String> getIdToken() async {
    await _ensureInitialized();

    try {
      final account = await _googleSignIn.authenticate();
      final authentication = account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException('Google sign-in did not return an ID token.');
      }

      return idToken;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      throw AuthException(error.description ?? 'Google sign-in failed.');
    }
  }
}

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn.instance;
}

@Riverpod(keepAlive: true)
GoogleSignInAdapter googleSignInAdapter(Ref ref) {
  return GoogleSignInAdapter(
    ref.watch(googleSignInProvider),
    ref.watch(appEnvProvider),
  );
}

@Riverpod(keepAlive: true)
bool isMobileGoogleSignInSupported(Ref ref) {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
}
