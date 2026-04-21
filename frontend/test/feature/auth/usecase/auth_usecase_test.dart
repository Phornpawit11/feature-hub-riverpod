import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/data/providers/auth_repository_provider.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';

void main() {
  group('AuthUsecase', () {
    late _FakeAuthRepository fakeRepository;
    late _FakeSecureTokenStorage fakeStorage;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeAuthRepository();
      fakeStorage = _FakeSecureTokenStorage();

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepository),
          secureTokenStorageProvider.overrideWithValue(fakeStorage),
          isMobileGoogleSignInSupportedProvider.overrideWithValue(true),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'restoreSession authenticates when stored access token is valid',
      () async {
        fakeStorage.storedAccessToken = 'saved-access-token';
        fakeRepository.currentUser = _testUser();

        final notifier = container.read(authUsecaseProvider.notifier);
        await Future<void>.delayed(Duration.zero);
        fakeRepository.lastCurrentUserToken = null;
        await notifier.restoreSession();

        final state = container.read(authUsecaseProvider);

        expect(fakeRepository.lastCurrentUserToken, 'saved-access-token');
        expect(state.status, AuthStatus.authenticated);
        expect(state.user?.email, 'test@example.com');
      },
    );

    test(
      'restoreSession refreshes tokens when access token is invalid',
      () async {
        fakeStorage.storedAccessToken = 'expired-access-token';
        fakeStorage.storedRefreshToken = 'refresh-token';
        fakeRepository.currentUserError = const AuthException(
          'Invalid token',
          statusCode: 401,
        );
        fakeRepository.refreshSessionResult = AuthSession(
          accessToken: 'new-access-token',
          refreshToken: 'new-refresh-token',
          user: _testUser(),
        );

        final notifier = container.read(authUsecaseProvider.notifier);
        await notifier.restoreSession();

        final state = container.read(authUsecaseProvider);

        expect(fakeRepository.lastRefreshToken, 'refresh-token');
        expect(fakeStorage.storedAccessToken, 'new-access-token');
        expect(fakeStorage.storedRefreshToken, 'new-refresh-token');
        expect(state.status, AuthStatus.authenticated);
      },
    );

    test(
      'restoreSession does NOT call getCurrentUser after successful refresh',
      () async {
        fakeStorage.storedAccessToken = 'expired-access-token';
        fakeStorage.storedRefreshToken = 'refresh-token';
        fakeRepository.currentUserError = const AuthException(
          'Invalid token',
          statusCode: 401,
        );
        fakeRepository.refreshSessionResult = AuthSession(
          accessToken: 'new-access-token',
          refreshToken: 'new-refresh-token',
          user: _testUser(),
        );

        final notifier = container.read(authUsecaseProvider.notifier);
        fakeRepository.lastCurrentUserToken = null;
        await notifier.restoreSession();

        // getCurrentUser ควรถูกเรียกแค่ครั้งเดียว (ตอน access token เดิมยังไม่หมดอายุ)
        // และหลัง refresh ต้องไม่เรียกซ้ำ
        expect(
          fakeRepository.lastCurrentUserToken,
          'expired-access-token',
          reason: 'getCurrentUser called only for initial token check, not after refresh',
        );
      },
    );

    test(
      'restoreSession clears tokens when refresh token is invalid',
      () async {
        fakeStorage.storedAccessToken = 'expired-access-token';
        fakeStorage.storedRefreshToken = 'bad-refresh-token';
        fakeRepository.currentUserError = const AuthException(
          'Invalid token',
          statusCode: 401,
        );
        fakeRepository.refreshError = const AuthException(
          'Invalid refresh token',
          statusCode: 401,
        );

        final notifier = container.read(authUsecaseProvider.notifier);
        await notifier.restoreSession();

        final state = container.read(authUsecaseProvider);

        expect(state.status, AuthStatus.unauthenticated);
        expect(fakeStorage.storedAccessToken, isNull);
        expect(fakeStorage.storedRefreshToken, isNull);
        expect(fakeStorage.clearTokensCallCount, greaterThanOrEqualTo(1));
      },
    );

    test(
      'signInWithEmailPassword stores tokens and authenticates on success',
      () async {
        fakeRepository.emailSession = AuthSession(
          accessToken: 'jwt-token',
          refreshToken: 'refresh-token',
          user: _testUser(),
        );

        final notifier = container.read(authUsecaseProvider.notifier);
        await Future<void>.delayed(Duration.zero);
        await notifier.signInWithEmailPassword(
          email: ' test@example.com ',
          password: 'password123',
        );

        final state = container.read(authUsecaseProvider);

        expect(fakeRepository.lastEmail, 'test@example.com');
        expect(fakeRepository.lastPassword, 'password123');
        expect(fakeStorage.storedAccessToken, 'jwt-token');
        expect(fakeStorage.storedRefreshToken, 'refresh-token');
        expect(state.status, AuthStatus.authenticated);
        expect(state.user?.displayName, 'Test User');
      },
    );

    test(
      'signInWithEmailPassword exposes backend auth error on failure',
      () async {
        fakeRepository.emailError = const AuthException(
          'Invalid email or password',
        );

        final notifier = container.read(authUsecaseProvider.notifier);
        await Future<void>.delayed(Duration.zero);
        await notifier.signInWithEmailPassword(
          email: 'test@example.com',
          password: 'wrong-password',
        );

        final state = container.read(authUsecaseProvider);

        expect(state.status, AuthStatus.failure);
        expect(state.errorMessage, 'Invalid email or password');
        expect(fakeStorage.storedAccessToken, isNull);
        expect(fakeStorage.storedRefreshToken, isNull);
      },
    );

    test(
      'signOut calls logout best-effort, clears tokens and unauthenticates',
      () async {
        fakeStorage.storedAccessToken = 'jwt-token';
        fakeStorage.storedRefreshToken = 'refresh-token';
        fakeRepository.currentUser = _testUser();
        final notifier = container.read(authUsecaseProvider.notifier);
        await Future<void>.delayed(Duration.zero);
        fakeStorage.clearTokensCallCount = 0;

        await notifier.signOut();

        final state = container.read(authUsecaseProvider);

        // Google signOut ถูก wrap ด้วย try-catch — MissingPluginException ใน test env
        // จะถูก catch แล้ว signOut ยังทำงานต่อได้ปกติ
        expect(fakeRepository.lastLogoutRefreshToken, 'refresh-token');
        expect(fakeStorage.clearTokensCallCount, 1);
        expect(state.status, AuthStatus.unauthenticated);
        expect(fakeStorage.storedAccessToken, isNull);
        expect(fakeStorage.storedRefreshToken, isNull);
      },
    );

    test(
      'signOut succeeds even when Google signOut fails (best-effort)',
      () async {
        // Google signOut wrap ด้วย try-catch ดังนั้นแม้ platform ไม่พร้อมก็ไม่ crash
        final notifier = container.read(authUsecaseProvider.notifier);

        // Let the initial restoreSession microtask drain before resetting state
        await Future<void>.delayed(Duration.zero);

        fakeStorage.storedAccessToken = 'token';
        fakeStorage.storedRefreshToken = 'refresh';
        fakeStorage.clearTokensCallCount = 0;

        await expectLater(notifier.signOut(), completes);

        final state = container.read(authUsecaseProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(fakeStorage.clearTokensCallCount, 1);
      },
    );
  });
}

AuthUser _testUser() {
  return AuthUser(
    id: 'user-1',
    email: 'test@example.com',
    displayName: 'Test User',
    provider: 'password',
  );
}

class _FakeAuthRepository implements AuthRepository {
  AuthSession? emailSession;
  AuthException? emailError;
  AuthSession? googleSession;
  AuthException? googleError;
  AuthSession? refreshSessionResult;
  AuthException? refreshError;
  AuthUser? currentUser;
  AuthException? currentUserError;
  final Map<String, AuthUser> userByToken = {};
  String? lastEmail;
  String? lastPassword;
  String? lastCurrentUserToken;
  String? lastRefreshToken;
  String? lastLogoutRefreshToken;

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    lastCurrentUserToken = accessToken;

    if (userByToken.containsKey(accessToken)) {
      return userByToken[accessToken]!;
    }

    if (currentUserError != null) {
      throw currentUserError!;
    }

    return currentUser!;
  }

  @override
  Future<void> logout({required String refreshToken}) async {
    lastLogoutRefreshToken = refreshToken;
  }

  @override
  Future<AuthSession> refreshSession({required String refreshToken}) async {
    lastRefreshToken = refreshToken;

    if (refreshError != null) {
      throw refreshError!;
    }

    return refreshSessionResult!;
  }

  @override
  Future<AuthSession> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;

    if (emailError != null) {
      throw emailError!;
    }

    return emailSession ??
        AuthSession(
          accessToken: 'jwt-token',
          refreshToken: 'refresh-token',
          user: _testUser(),
        );
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    if (googleError != null) {
      throw googleError!;
    }

    return googleSession ??
        AuthSession(
          accessToken: 'google-token',
          refreshToken: 'google-refresh-token',
          user: _testUser(),
        );
  }
}

class _FakeSecureTokenStorage extends SecureTokenStorage {
  _FakeSecureTokenStorage() : super(const FlutterSecureStorage());

  String? storedAccessToken;
  String? storedRefreshToken;
  int clearTokensCallCount = 0;

  @override
  Future<void> clearTokens() async {
    clearTokensCallCount++;
    storedAccessToken = null;
    storedRefreshToken = null;
  }

  @override
  Future<String?> readAccessToken() async {
    return storedAccessToken;
  }

  @override
  Future<String?> readRefreshToken() async {
    return storedRefreshToken;
  }

  @override
  Future<void> writeAccessToken(String token) async {
    storedAccessToken = token;
  }

  @override
  Future<void> writeRefreshToken(String token) async {
    storedRefreshToken = token;
  }
}
