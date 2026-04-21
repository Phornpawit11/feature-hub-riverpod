import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';

void main() {
  group('AuthRemoteDatasource', () {
    test('checkEmailAvailability sends request and parses availability', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {'available': true},
                ),
              );
            },
          ),
        );

      final datasource = AuthRemoteDatasource(dio);

      final available = await datasource.checkEmailAvailability(
        email: 'test@example.com',
      );

      expect(capturedOptions.path, '/auth/check-email');
      expect(capturedOptions.method, 'POST');
      expect(capturedOptions.data, {'email': 'test@example.com'});
      expect(available, isTrue);
    });

    test(
      'registerWithEmailPassword sends register request and parses session',
      () async {
        late RequestOptions capturedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                capturedOptions = options;
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    data: {
                      'accessToken': 'jwt-token',
                      'refreshToken': 'refresh-token',
                      'user': {
                        'id': 'user-1',
                        'email': 'test@example.com',
                        'displayName': 'Test User',
                        'provider': 'password',
                        'avatarUrl': null,
                      },
                    },
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        final session = await datasource.registerWithEmailPassword(
          displayName: 'Test User',
          email: 'test@example.com',
          password: 'password123',
        );

        expect(capturedOptions.path, '/auth/register');
        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.data, {
          'displayName': 'Test User',
          'email': 'test@example.com',
          'password': 'password123',
        });
        expect(session.accessToken, 'jwt-token');
        expect(session.refreshToken, 'refresh-token');
        expect(session.user.displayName, 'Test User');
      },
    );

    test(
      'signInWithEmailPassword sends login request and parses session',
      () async {
        late RequestOptions capturedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                capturedOptions = options;
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    data: {
                      'accessToken': 'jwt-token',
                      'refreshToken': 'refresh-token',
                      'user': {
                        'id': 'user-1',
                        'email': 'test@example.com',
                        'displayName': 'Test User',
                        'provider': 'password',
                        'avatarUrl': null,
                      },
                    },
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        final session = await datasource.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(capturedOptions.path, '/auth/login');
        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.data, {
          'email': 'test@example.com',
          'password': 'password123',
        });
        expect(session.accessToken, 'jwt-token');
        expect(session.refreshToken, 'refresh-token');
        expect(session.user.email, 'test@example.com');
        expect(session.user.provider, 'password');
      },
    );

    test(
      'signInWithGoogle sends id token request and parses session',
      () async {
        late RequestOptions capturedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                capturedOptions = options;
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    data: {
                      'accessToken': 'jwt-token',
                      'refreshToken': 'refresh-token',
                      'user': {
                        'id': 'user-2',
                        'email': 'google@example.com',
                        'displayName': 'Google User',
                        'provider': 'google',
                        'avatarUrl': 'https://example.com/avatar.png',
                      },
                    },
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        final session = await datasource.signInWithGoogle(
          idToken: 'google-token',
        );

        expect(capturedOptions.path, '/auth/google');
        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.data, {'idToken': 'google-token'});
        expect(session.refreshToken, 'refresh-token');
        expect(session.user.email, 'google@example.com');
        expect(session.user.provider, 'google');
      },
    );

    test(
      'refreshSession sends refresh token request and parses session',
      () async {
        late RequestOptions capturedOptions;
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                capturedOptions = options;
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    data: {
                      'accessToken': 'new-access-token',
                      'refreshToken': 'new-refresh-token',
                      'user': {
                        'id': 'user-1',
                        'email': 'test@example.com',
                        'displayName': 'Test User',
                        'provider': 'password',
                        'avatarUrl': null,
                      },
                    },
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        final session = await datasource.refreshSession(
          refreshToken: 'refresh-token',
        );

        expect(capturedOptions.path, '/auth/refresh');
        expect(capturedOptions.method, 'POST');
        expect(capturedOptions.data, {'refreshToken': 'refresh-token'});
        expect(session.accessToken, 'new-access-token');
        expect(session.refreshToken, 'new-refresh-token');
      },
    );

    test('logout sends refresh token request', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {'success': true},
                ),
              );
            },
          ),
        );

      final datasource = AuthRemoteDatasource(dio);

      await datasource.logout(refreshToken: 'refresh-token');

      expect(capturedOptions.path, '/auth/logout');
      expect(capturedOptions.method, 'POST');
      expect(capturedOptions.data, {'refreshToken': 'refresh-token'});
    });

    test('getCurrentUser attaches bearer token and parses user', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {
                    'id': 'user-1',
                    'email': 'test@example.com',
                    'displayName': 'Test User',
                    'provider': 'password',
                    'avatarUrl': null,
                  },
                ),
              );
            },
          ),
        );

      final datasource = AuthRemoteDatasource(dio);

      final user = await datasource.getCurrentUser('jwt-token');

      expect(capturedOptions.path, '/auth/me');
      expect(capturedOptions.method, 'GET');
      expect(capturedOptions.headers['Authorization'], 'Bearer jwt-token');
      expect(user.email, 'test@example.com');
    });

    test(
      'maps string error message and status code to AuthException',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response<Map<String, dynamic>>(
                      requestOptions: options,
                      statusCode: 401,
                      data: {'message': 'Invalid email or password'},
                    ),
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        await expectLater(
          () => datasource.signInWithEmailPassword(
            email: 'test@example.com',
            password: 'wrong-password',
          ),
          throwsA(
            isA<AuthException>()
                .having(
                  (error) => error.message,
                  'message',
                  'Invalid email or password',
                )
                .having((error) => error.statusCode, 'statusCode', 401),
          ),
        );
      },
    );

    test(
      'maps validation error list to joined AuthException message',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'))
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response<Map<String, dynamic>>(
                      requestOptions: options,
                      statusCode: 400,
                      data: {
                        'message': [
                          'email must be an email',
                          'password is required',
                        ],
                      },
                    ),
                  ),
                );
              },
            ),
          );

        final datasource = AuthRemoteDatasource(dio);

        await expectLater(
          () => datasource.signInWithEmailPassword(
            email: 'bad-email',
            password: '',
          ),
          throwsA(
            isA<AuthException>().having(
              (error) => error.message,
              'message',
              'email must be an email, password is required',
            ),
          ),
        );
      },
    );
  });
}
