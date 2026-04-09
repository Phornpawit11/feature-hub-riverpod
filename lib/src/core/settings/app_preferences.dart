import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/settings/app_preferences_state.dart';

part 'app_preferences.g.dart';

@Riverpod(keepAlive: true)
class AppPreferences extends _$AppPreferences {
  @override
  AppPreferencesState build() {
    return AppPreferencesState(
      theme: ThemeMode.system,
      appLanguage: AppLanguage.english,
    );
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(theme: themeMode);
  }

  void updateLanguage(AppLanguage language) {
    state = state.copyWith(appLanguage: language);
  }
}
