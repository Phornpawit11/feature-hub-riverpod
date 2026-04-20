import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences.dart';
import 'package:todos_riverpod/src/core/theme/app_theme.dart';
import 'package:todos_riverpod/src/feature/auth/presentation/auth_loading.screen.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_notifier.dart';
import 'package:todos_riverpod/src/feature/auth/usecase/auth_state.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(appPreferencesProvider);
    final authState = ref.watch(authNotifierProvider);
    return Sizer(
      builder: (context, orientation, deviceType) {
        if (authState.status == AuthStatus.restoring) {
          return MaterialApp(
            title: "Todos",
            darkTheme: AppTheme.dark,
            theme: AppTheme.light,
            themeMode: preferences.theme,
            home: const AuthLoadingScreen(),
          );
        }

        final GoRouter router = ref.watch(goRouterProvider);
        return MaterialApp.router(
          routerConfig: router,
          title: "Todos",
          darkTheme: AppTheme.dark,
          theme: AppTheme.light,
          themeMode: preferences.theme,
        );
      },
    );
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
