import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';
import 'package:todos_riverpod/src/core/network/api_client_provider.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

void main() {
  group('dioProvider auth refresh', () {
    test('retries once after a successful refresh', () async {
      final storage = _FakeSecureTokenStorage(
        storedAccessToken: 'stale-access-token',
        storedRefreshToken: 'refresh-token',
      );
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _user()),
      );
      final protectedAdapter = _ProtectedResourceAdapter();
      final refreshAdapter = _RefreshAdapter();

      final rawDio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
        ..httpClientAdapter = refreshAdapter;

      final container = ProviderContainer(
        overrides: [
          appEnvProvider.overrideWithValue(
            const AppEnv(apiBaseUrl: 'http://localhost:3000/api'),
          ),
          secureTokenStorageProvider.overrideWithValue(storage),
          authUsecaseProvider.overrideWith(() => fakeNotifier),
          authRawDioProvider.overrideWithValue(rawDio),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider)
        ..httpClientAdapter = protectedAdapter;

      final response = await dio.get<Map<String, dynamic>>('/protected');

      expect(response.data, {'ok': true, 'path': '/protected'});
      expect(refreshAdapter.refreshCallCount, 1);
      expect(protectedAdapter.protectedRequestCount, 2);
      expect(storage.storedAccessToken, 'fresh-access-token');
      expect(storage.storedRefreshToken, 'fresh-refresh-token');
      expect(fakeNotifier.state.status, AuthStatus.authenticated);
    });

    test('serializes concurrent refresh attempts', () async {
      final storage = _FakeSecureTokenStorage(
        storedAccessToken: 'stale-access-token',
        storedRefreshToken: 'refresh-token',
      );
      final fakeNotifier = _FakeAuthUsecase(
        AuthState(status: AuthStatus.authenticated, user: _user()),
      );
      final protectedAdapter = _ProtectedResourceAdapter();
      final refreshAdapter = _RefreshAdapter(
        delay: const Duration(milliseconds: 10),
      );

      final rawDio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
        ..httpClientAdapter = refreshAdapter;

      final container = ProviderContainer(
        overrides: [
          appEnvProvider.overrideWithValue(
            const AppEnv(apiBaseUrl: 'http://localhost:3000/api'),
          ),
          secureTokenStorageProvider.overrideWithValue(storage),
          authUsecaseProvider.overrideWith(() => fakeNotifier),
          authRawDioProvider.overrideWithValue(rawDio),
        ],
      );
      addTearDown(container.dispose);

      final dio = container.read(dioProvider)
        ..httpClientAdapter = protectedAdapter;

      final responses = await Future.wait([
        dio.get<Map<String, dynamic>>('/protected/one'),
        dio.get<Map<String, dynamic>>('/protected/two'),
      ]);

      expect(refreshAdapter.refreshCallCount, 1);
      expect(protectedAdapter.protectedRequestCount, 4);
      expect(responses.map((response) => response.data?['path']).toSet(), {
        '/protected/one',
        '/protected/two',
      });
    });
  });
}

AuthUser _user() {
  return AuthUser(
    id: 'user-1',
    email: 'test@example.com',
    displayName: 'Test User',
    provider: 'password',
  );
}

class _ProtectedResourceAdapter implements HttpClientAdapter {
  int protectedRequestCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final authorization = options.headers['Authorization']?.toString() ?? '';
    final path = options.uri.path;

    if (path == '/api/protected' ||
        path == '/api/protected/one' ||
        path == '/api/protected/two') {
      protectedRequestCount++;

      if (authorization.contains('stale-access-token')) {
        return _jsonResponse(401, {'message': 'Invalid token'});
      }

      if (authorization.contains('fresh-access-token')) {
        return _jsonResponse(200, {
          'ok': true,
          'path': path.replaceFirst('/api', ''),
        });
      }
    }

    return _jsonResponse(404, {'message': 'Not found'});
  }
}

class _RefreshAdapter implements HttpClientAdapter {
  _RefreshAdapter({this.delay});

  final Duration? delay;
  int refreshCallCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.path == '/api/auth/refresh') {
      refreshCallCount++;

      if (delay != null) {
        await Future<void>.delayed(delay!);
      }

      return _jsonResponse(200, {
        'accessToken': 'fresh-access-token',
        'refreshToken': 'fresh-refresh-token',
        'user': _user().toJson(),
      });
    }

    return _jsonResponse(404, {'message': 'Not found'});
  }
}

ResponseBody _jsonResponse(int statusCode, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

class _FakeSecureTokenStorage extends SecureTokenStorage {
  _FakeSecureTokenStorage({this.storedAccessToken, this.storedRefreshToken})
    : super(const FlutterSecureStorage());

  String? storedAccessToken;
  String? storedRefreshToken;

  @override
  Future<void> clearTokens() async {
    storedAccessToken = null;
    storedRefreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async => storedAccessToken;

  @override
  Future<String?> readRefreshToken() async => storedRefreshToken;

  @override
  Future<void> writeAccessToken(String token) async {
    storedAccessToken = token;
  }

  @override
  Future<void> writeRefreshToken(String token) async {
    storedRefreshToken = token;
  }
}

class _FakeAuthUsecase extends AuthUsecase {
  _FakeAuthUsecase(this._initialState);

  final AuthState _initialState;

  @override
  AuthState build() => _initialState;
}
