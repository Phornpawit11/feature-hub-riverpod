import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences.dart';
import 'package:todos_riverpod/src/core/theme/app_theme.dart';
import 'package:todos_riverpod/src/router/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(goRouterProvider);
    final preferences = ref.watch(appPreferencesProvider);
    return Sizer(
      builder: (context, orientation, deviceType) {
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
