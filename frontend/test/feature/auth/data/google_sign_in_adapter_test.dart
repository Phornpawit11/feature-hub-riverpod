import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';

void main() {
  group('resolveGoogleSignInConfiguration', () {
    const env = AppEnv(
      apiBaseUrl: 'http://localhost:3000/api',
      googleClientId: 'mobile-client-id',
      googleServerClientId: 'server-client-id',
    );

    test('uses only server client id on Android', () {
      final config = resolveGoogleSignInConfiguration(
        env,
        platform: TargetPlatform.android,
        isWeb: false,
      );

      expect(config.clientId, isNull);
      expect(config.serverClientId, 'server-client-id');
    });

    test('uses client id and server client id on iOS', () {
      final config = resolveGoogleSignInConfiguration(
        env,
        platform: TargetPlatform.iOS,
        isWeb: false,
      );

      expect(config.clientId, 'mobile-client-id');
      expect(config.serverClientId, 'server-client-id');
    });
  });
}
