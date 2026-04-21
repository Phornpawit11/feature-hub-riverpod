import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppEnv {
  const AppEnv({
    required this.apiBaseUrl,
    this.googleClientId,
    this.googleServerClientId,
  });

  final String apiBaseUrl;
  final String? googleClientId;
  final String? googleServerClientId;

  factory AppEnv.fromMap(
    Map<String, String> env, {
    TargetPlatform? platform,
    bool isWeb = kIsWeb,
  }) {
    final resolvedPlatform = platform ?? defaultTargetPlatform;

    return AppEnv(
      apiBaseUrl:
          _normalizeValue(env['API_BASE_URL']) ??
          _defaultApiBaseUrl(platform: resolvedPlatform, isWeb: isWeb),
      googleClientId: _normalizeValue(env['GOOGLE_CLIENT_ID']),
      googleServerClientId: _normalizeValue(env['GOOGLE_SERVER_CLIENT_ID']),
    );
  }

  static String? _normalizeValue(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }

  static String _defaultApiBaseUrl({
    required TargetPlatform platform,
    required bool isWeb,
  }) {
    if (!isWeb && platform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }

    return 'http://localhost:3000/api';
  }
}

final appEnvProvider = Provider<AppEnv>((ref) {
  final envMap = dotenv.isInitialized ? dotenv.env : const <String, String>{};
  return AppEnv.fromMap(envMap);
});

Future<void> loadAppEnv() async {
  await dotenv.load(isOptional: true);

  if (dotenv.env.isEmpty) {
    await dotenv.load(fileName: '.env.example');
  }
}
