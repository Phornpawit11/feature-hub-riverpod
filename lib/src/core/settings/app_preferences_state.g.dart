// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppPreferencesState _$AppPreferencesStateFromJson(Map<String, dynamic> json) =>
    _AppPreferencesState(
      appLanguage: $enumDecode(_$AppLanguageEnumMap, json['appLanguage']),
      theme: $enumDecode(_$ThemeModeEnumMap, json['theme']),
    );

Map<String, dynamic> _$AppPreferencesStateToJson(
  _AppPreferencesState instance,
) => <String, dynamic>{
  'appLanguage': _$AppLanguageEnumMap[instance.appLanguage]!,
  'theme': _$ThemeModeEnumMap[instance.theme]!,
};

const _$AppLanguageEnumMap = {
  AppLanguage.english: 'english',
  AppLanguage.thai: 'thai',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
