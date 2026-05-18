// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_location_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherLocationService)
const weatherLocationServiceProvider = WeatherLocationServiceProvider._();

final class WeatherLocationServiceProvider
    extends
        $FunctionalProvider<
          WeatherLocationService,
          WeatherLocationService,
          WeatherLocationService
        >
    with $Provider<WeatherLocationService> {
  const WeatherLocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherLocationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherLocationServiceHash();

  @$internal
  @override
  $ProviderElement<WeatherLocationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherLocationService create(Ref ref) {
    return weatherLocationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherLocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherLocationService>(value),
    );
  }
}

String _$weatherLocationServiceHash() =>
    r'e8c2b50dbd4646d12e8ba1ff6422d9378cc9f89b';
