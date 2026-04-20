import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {
  SecureTokenStorage(this._storage);

  static const String accessTokenKey = 'auth_access_token';
  static const String refreshTokenKey = 'auth_refresh_token';

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
}

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  return SecureTokenStorage(ref.watch(flutterSecureStorageProvider));
});
