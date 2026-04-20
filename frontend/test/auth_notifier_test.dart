import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/core/storage/secure_token_storage.dart';
import 'package:todos_riverpod/src/feature/auth/data/google_sign_in_adapter.dart';
import 'package:todos_riverpod/src/feature/auth/data/providers/auth_repository_provider.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_repository.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_notifier.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';

void main() {
  group('AuthNotifier', () {
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

    test('restoreSession authenticates when stored token is valid', () async {
      fakeStorage.storedToken = 'saved-token';
      fakeRepository.currentUser = _testUser();

      final notifier = container.read(authNotifierProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      fakeRepository.lastCurrentUserToken = null;
      await notifier.restoreSession();

      final state = container.read(authNotifierProvider);

      expect(fakeRepository.lastCurrentUserToken, 'saved-token');
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.email, 'test@example.com');
    });

    test('restoreSession clears token when stored token is invalid', () async {
      fakeStorage.storedToken = 'expired-token';
      fakeRepository.currentUserError = const AuthException('Invalid token');

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.restoreSession();

      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.unauthenticated);
      expect(fakeStorage.storedToken, isNull);
      expect(fakeStorage.clearAccessTokenCallCount, greaterThanOrEqualTo(1));
    });

    test('signInWithEmailPassword stores token and authenticates on success', () async {
      fakeRepository.emailSession = AuthSession(
        accessToken: 'jwt-token',
        user: _testUser(),
      );

      final notifier = container.read(authNotifierProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.signInWithEmailPassword(
        email: ' test@example.com ',
        password: 'password123',
      );

      final state = container.read(authNotifierProvider);

      expect(fakeRepository.lastEmail, 'test@example.com');
      expect(fakeRepository.lastPassword, 'password123');
      expect(fakeStorage.storedToken, 'jwt-token');
      expect(state.status, AuthStatus.authenticated);
      expect(state.user?.displayName, 'Test User');
    });

    test('signInWithEmailPassword exposes backend auth error on failure', () async {
      fakeRepository.emailError = const AuthException('Invalid email or password');

      final notifier = container.read(authNotifierProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.signInWithEmailPassword(
        email: 'test@example.com',
        password: 'wrong-password',
      );

      final state = container.read(authNotifierProvider);

      expect(state.status, AuthStatus.failure);
      expect(state.errorMessage, 'Invalid email or password');
      expect(fakeStorage.storedToken, isNull);
    });

    test('signOut clears token and returns to unauthenticated', () async {
      fakeStorage.storedToken = 'jwt-token';
      final notifier = container.read(authNotifierProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      fakeStorage.clearAccessTokenCallCount = 0;

      await notifier.signInWithEmailPassword(
        email: 'test@example.com',
        password: 'password123',
      );
      fakeStorage.clearAccessTokenCallCount = 0;
      await notifier.signOut();

      final state = container.read(authNotifierProvider);

      expect(fakeStorage.clearAccessTokenCallCount, 1);
      expect(state.status, AuthStatus.unauthenticated);
      expect(fakeStorage.storedToken, isNull);
    });
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
  AuthUser? currentUser;
  AuthException? currentUserError;
  String? lastEmail;
  String? lastPassword;
  String? lastCurrentUserToken;

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    lastCurrentUserToken = accessToken;

    if (currentUserError != null) {
      throw currentUserError!;
    }

    return currentUser!;
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
          user: _testUser(),
        );
  }
}

class _FakeSecureTokenStorage extends SecureTokenStorage {
  _FakeSecureTokenStorage() : super(const FlutterSecureStorage());

  String? storedToken;
  int clearAccessTokenCallCount = 0;

  @override
  Future<void> clearAccessToken() async {
    clearAccessTokenCallCount++;
    storedToken = null;
  }

  @override
  Future<String?> readAccessToken() async {
    return storedToken;
  }

  @override
  Future<void> writeAccessToken(String token) async {
    storedToken = token;
  }
}
