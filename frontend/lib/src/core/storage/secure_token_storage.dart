import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_token_storage.g.dart';

class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  static const String accessTokenKey = 'auth_access_token';
  static const String refreshTokenKey = 'auth_refresh_token';
  static const String pendingVerificationIdKey = 'auth_pending_verification_id';
  static const String pendingVerificationEmailKey =
      'auth_pending_verification_email';
  static const String pendingResendAvailableAtKey =
      'auth_pending_resend_available_at';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() {
    return _storage.read(key: accessTokenKey);
  }

  Future<void> writeAccessToken(String token) {
    return _storage.write(key: accessTokenKey, value: token);
  }

  Future<void> clearAccessToken() {
    return _storage.delete(key: accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: refreshTokenKey);
  }

  Future<void> writeRefreshToken(String token) {
    return _storage.write(key: refreshTokenKey, value: token);
  }

  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await writeAccessToken(accessToken);
    await writeRefreshToken(refreshToken);
  }

  Future<void> clearRefreshToken() {
    return _storage.delete(key: refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  Future<void> writePendingVerification({
    required String verificationId,
    required String email,
    required DateTime resendAvailableAt,
  }) async {
    await _storage.write(
      key: pendingVerificationIdKey,
      value: verificationId,
    );
    await _storage.write(key: pendingVerificationEmailKey, value: email);
    await _storage.write(
      key: pendingResendAvailableAtKey,
      value: resendAvailableAt.toIso8601String(),
    );
  }

  Future<({
    String verificationId,
    String email,
    DateTime resendAvailableAt,
  })?> readPendingVerification() async {
    final verificationId = await _storage.read(key: pendingVerificationIdKey);
    final email = await _storage.read(key: pendingVerificationEmailKey);
    final resendAvailableAtRaw = await _storage.read(
      key: pendingResendAvailableAtKey,
    );

    if (verificationId == null ||
        verificationId.isEmpty ||
        email == null ||
        email.isEmpty ||
        resendAvailableAtRaw == null ||
        resendAvailableAtRaw.isEmpty) {
      return null;
    }

    final resendAvailableAt = DateTime.tryParse(resendAvailableAtRaw);
    if (resendAvailableAt == null) {
      return null;
    }

    return (
      verificationId: verificationId,
      email: email,
      resendAvailableAt: resendAvailableAt,
    );
  }

  Future<void> clearPendingVerification() async {
    await _storage.delete(key: pendingVerificationIdKey);
    await _storage.delete(key: pendingVerificationEmailKey);
    await _storage.delete(key: pendingResendAvailableAtKey);
  }
}

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
SecureTokenStorage secureTokenStorage(Ref ref) {
  return SecureTokenStorage(ref.watch(flutterSecureStorageProvider));
}
