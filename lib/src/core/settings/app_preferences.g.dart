// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppPreferences)
const appPreferencesProvider = AppPreferencesProvider._();

final class AppPreferencesProvider
    extends $NotifierProvider<AppPreferences, AppPreferencesState> {
  const AppPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPreferencesHash();

  @$internal
  @override
  AppPreferences create() => AppPreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppPreferencesState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppPreferencesState>(value),
    );
  }
}

String _$appPreferencesHash() => r'7e45e5c93e0dd04f267a3eb45c7c80657e5e1d7f';

abstract class _$AppPreferences extends $Notifier<AppPreferencesState> {
  AppPreferencesState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppPreferencesState, AppPreferencesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppPreferencesState, AppPreferencesState>,
              AppPreferencesState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
