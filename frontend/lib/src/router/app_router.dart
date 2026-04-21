import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todos_riverpod/src/feature/auth/presentation/login.screen.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_usecase.dart';
import 'package:todos_riverpod/src/feature/landing/presentation/landing.screen.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo.screen.dart';

enum SGRoute {
  login,
  landing,
  todo;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

/// Listenable ที่ sync กับ AuthState — ใช้กับ GoRouter.refreshListenable
/// เพื่อไม่ให้ GoRouter ถูกสร้างใหม่ทุกครั้งที่ auth state เปลี่ยน
class _AuthStateListenable extends ValueNotifier<AuthState> {
  _AuthStateListenable(super.value);
  void update(AuthState state) => value = state;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref.read(authUsecaseProvider));

  // อัปเดต listenable เมื่อ auth state เปลี่ยน — GoRouter จะ re-evaluate redirect
  ref.listen<AuthState>(authUsecaseProvider, (_, next) {
    listenable.update(next);
  });

  final router = GoRouter(
    initialLocation: SGRoute.login.route,
    refreshListenable: listenable,
    routes: <GoRoute>[
      GoRoute(
        path: SGRoute.login.route,
        name: SGRoute.login.name,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: SGRoute.landing.route,
        name: SGRoute.landing.name,
        builder: (BuildContext context, GoRouterState state) {
          return const LandingScreen();
        },
      ),
      GoRoute(
        path: SGRoute.todo.route,
        name: SGRoute.todo.name,
        builder: (BuildContext context, GoRouterState state) {
          return const TodoScreen();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final auth = listenable.value;
      final location = state.matchedLocation;
      final isLoginRoute = location == SGRoute.login.route;
      final isTodoRoute = location == SGRoute.todo.route;

      if (!auth.isAuthenticated && isTodoRoute) {
        return SGRoute.login.route;
      }

      if (auth.isAuthenticated && isLoginRoute) {
        return SGRoute.todo.route;
      }

      return null;
    },
  );

  ref.onDispose(listenable.dispose);
  return router;
});
