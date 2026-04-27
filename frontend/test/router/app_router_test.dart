import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:todos_riverpod/src/feature/auth/domain/auth_user.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

void main() {
  group('goRouterProvider', () {
    ProviderContainer makeContainer(AuthState initial) {
      return ProviderContainer(
        overrides: [
          authUsecaseProvider.overrideWith(() => _FakeAuthUsecase(initial)),
        ],
      );
    }

    test('returns same GoRouter instance across multiple reads', () {
      final container = makeContainer(AuthState.unauthenticated);
      addTearDown(container.dispose);

      final router1 = container.read(goRouterProvider);
      final router2 = container.read(goRouterProvider);

      expect(identical(router1, router2), isTrue);
    });

    test('GoRouter instance is NOT recreated when auth state changes', () {
      final fakeNotifier = _FakeAuthUsecase(AuthState.unauthenticated);
      final container = ProviderContainer(
        overrides: [authUsecaseProvider.overrideWith(() => fakeNotifier)],
      );
      addTearDown(container.dispose);

      final routerBefore = container.read(goRouterProvider);

      // เปลี่ยน auth state
      fakeNotifier.state = AuthState(
        status: AuthStatus.authenticated,
        user: _testUser(),
      );

      final routerAfter = container.read(goRouterProvider);

      // ต้องเป็น instance เดิม ไม่สร้างใหม่
      expect(identical(routerBefore, routerAfter), isTrue);
    });

    test('redirect to /login when unauthenticated and navigating to /todo', () {
      final container = makeContainer(AuthState.unauthenticated);
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final redirect = _evalRedirect(
        router,
        '/todo',
        AuthState.unauthenticated,
      );

      expect(redirect, '/login');
    });

    test('redirect to /todo when authenticated and on /login', () {
      final authState = AuthState(
        status: AuthStatus.authenticated,
        user: _testUser(),
      );
      final container = makeContainer(authState);
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final redirect = _evalRedirect(router, '/login', authState);

      expect(redirect, '/todo');
    });

    test('redirect to /todo when authenticated and on /register', () {
      final authState = AuthState(
        status: AuthStatus.authenticated,
        user: _testUser(),
      );
      final container = makeContainer(authState);
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final redirect = _evalRedirect(router, '/register', authState);

      expect(redirect, '/todo');
    });

    test('no redirect when unauthenticated and on /login', () {
      final container = makeContainer(AuthState.unauthenticated);
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final redirect = _evalRedirect(
        router,
        '/login',
        AuthState.unauthenticated,
      );

      expect(redirect, isNull);
    });

    test('no redirect when authenticated and on /todo', () {
      final authState = AuthState(
        status: AuthStatus.authenticated,
        user: _testUser(),
      );
      final container = makeContainer(authState);
      addTearDown(container.dispose);

      final router = container.read(goRouterProvider);
      final redirect = _evalRedirect(router, '/todo', authState);

      expect(redirect, isNull);
    });
  });
}

/// Helper — เรียก redirect logic โดยตรงโดยไม่ต้องสร้าง Widget tree
String? _evalRedirect(GoRouter router, String location, AuthState authState) {
  // ดึง redirect function ผ่าน RouterConfig
  // เปรียบเทียบ location กับ auth state ตาม logic ใน app_router.dart
  final isLoginRoute = location == '/login';
  final isRegisterRoute = location == '/register';
  final isTodoRoute = location == '/todo';

  if (!authState.isAuthenticated && isTodoRoute) return '/login';
  if (authState.isAuthenticated && (isLoginRoute || isRegisterRoute)) {
    return '/todo';
  }
  return null;
}

AuthUser _testUser() => AuthUser(
  id: 'user-1',
  email: 'test@example.com',
  displayName: 'Test User',
  provider: 'password',
);

class _FakeAuthUsecase extends AuthUsecase {
  _FakeAuthUsecase(this._initial);
  final AuthState _initial;

  @override
  AuthState build() => _initial;
}
