import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preferences_state.freezed.dart';
part 'app_preferences_state.g.dart';

enum AppLanguage {
  english('English', Locale('en')),
  thai('ไทย', Locale('th'));

  const AppLanguage(this.label, this.locale);

  final String label;
  final Locale locale;
}

@freezed
abstract class AppPreferencesState with _$AppPreferencesState {
  factory AppPreferencesState({
    required AppLanguage appLanguage,
    required ThemeMode theme,
  }) = _AppPreferencesState;

  factory AppPreferencesState.fromJson(Map<String, dynamic> json) =>
      _$AppPreferencesStateFromJson(json);
}
