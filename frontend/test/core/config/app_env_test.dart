import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';

void main() {
  group('AppEnv', () {
    test('reads values from env map', () {
      final env = AppEnv.fromMap(const {
        'API_BASE_URL': 'https://api.example.com',
        'GOOGLE_CLIENT_ID': 'client-id',
        'GOOGLE_SERVER_CLIENT_ID': 'server-client-id',
      });

      expect(env.apiBaseUrl, 'https://api.example.com');
      expect(env.googleClientId, 'client-id');
      expect(env.googleServerClientId, 'server-client-id');
    });

    test('falls back to android emulator base url when env is missing', () {
      final env = AppEnv.fromMap(
        const {},
        platform: TargetPlatform.android,
        isWeb: false,
      );

      expect(env.apiBaseUrl, 'http://10.0.2.2:3000/api');
    });

    test('falls back to localhost base url on non-android platforms', () {
      final env = AppEnv.fromMap(
        const {},
        platform: TargetPlatform.iOS,
        isWeb: false,
      );

      expect(env.apiBaseUrl, 'http://localhost:3000/api');
    });

    test('normalizes blank google ids to null', () {
      final env = AppEnv.fromMap(const {
        'GOOGLE_CLIENT_ID': '   ',
        'GOOGLE_SERVER_CLIENT_ID': '',
      });

      expect(env.googleClientId, isNull);
      expect(env.googleServerClientId, isNull);
    });
  });
}
