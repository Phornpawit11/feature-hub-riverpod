import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todos_riverpod/src/feature/auth/presentation/login.screen.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_notifier.dart';
import 'package:todos_riverpod/src/feature/landing/presentation/landing.screen.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo.screen.dart';

enum SGRoute {
  login,
  landing,
  todo;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: SGRoute.login.route,
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
      final location = state.matchedLocation;
      final isLoginRoute = location == SGRoute.login.route;
      final isTodoRoute = location == SGRoute.todo.route;

      if (!authState.isAuthenticated && isTodoRoute) {
        return SGRoute.login.route;
      }

      if (authState.isAuthenticated && isLoginRoute) {
        return SGRoute.todo.route;
      }

      return null;
    },
  );
});
