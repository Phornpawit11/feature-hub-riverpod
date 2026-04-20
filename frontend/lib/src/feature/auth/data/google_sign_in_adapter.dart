import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';

class GoogleSignInAdapter {
  GoogleSignInAdapter(this._googleSignIn);

  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    const clientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
    const serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

    await _googleSignIn.initialize(
      clientId: clientId.isEmpty ? null : clientId,
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _isInitialized = true;
  }

  Future<String> getIdToken() async {
    await _ensureInitialized();

    try {
      final account = await _googleSignIn.authenticate();
      final authentication = account.authentication;
      final idToken = authentication.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(
          'Google sign-in did not return an ID token.',
        );
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

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn.instance;
});

final googleSignInAdapterProvider = Provider<GoogleSignInAdapter>((ref) {
  return GoogleSignInAdapter(ref.watch(googleSignInProvider));
});

final isMobileGoogleSignInSupportedProvider = Provider<bool>((ref) {
  if (kIsWeb) {
    return false;
  }

  return switch (defaultTargetPlatform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
});
