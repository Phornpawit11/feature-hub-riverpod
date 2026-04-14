// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/landing/presentation/landing.screen.dart';
import 'package:todos_riverpod/src/feature/todos/presentation/todo.screen.dart';

part 'app_router.g.dart';

enum SGRoute {
  landing,
  todo;

  String get route => '/${toString().replaceAll('SGRoute.', '')}';
  String get name => toString().replaceAll('SGRoute.', '');
}

@riverpod
GoRouter goRouter(Ref ref) => GoRouter(
  initialLocation: SGRoute.todo.route,
  routes: <GoRoute>[
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
);
