// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_usecase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WeatherUsecase)
const weatherUsecaseProvider = WeatherUsecaseProvider._();

final class WeatherUsecaseProvider
    extends $NotifierProvider<WeatherUsecase, WeatherState> {
  const WeatherUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherUsecaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherUsecaseHash();

  @$internal
  @override
  WeatherUsecase create() => WeatherUsecase();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherState>(value),
    );
  }
}

String _$weatherUsecaseHash() => r'bdde1385246c66a88b05e5dc1220cae6256759d7';

abstract class _$WeatherUsecase extends $Notifier<WeatherState> {
  WeatherState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<WeatherState, WeatherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WeatherState, WeatherState>,
              WeatherState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
