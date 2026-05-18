// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(weatherDio)
const weatherDioProvider = WeatherDioProvider._();

final class WeatherDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const WeatherDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return weatherDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$weatherDioHash() => r'f33ea77bc8c6fac16272250f348dc7529b911803';

@ProviderFor(weatherRemoteDatasource)
const weatherRemoteDatasourceProvider = WeatherRemoteDatasourceProvider._();

final class WeatherRemoteDatasourceProvider
    extends
        $FunctionalProvider<
          WeatherRemoteDatasource,
          WeatherRemoteDatasource,
          WeatherRemoteDatasource
        >
    with $Provider<WeatherRemoteDatasource> {
  const WeatherRemoteDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherRemoteDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherRemoteDatasourceHash();

  @$internal
  @override
  $ProviderElement<WeatherRemoteDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeatherRemoteDatasource create(Ref ref) {
    return weatherRemoteDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeatherRemoteDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeatherRemoteDatasource>(value),
    );
  }
}

String _$weatherRemoteDatasourceHash() =>
    r'80c4bd2d7477fea4b6d770b2ffa31be54c987441';
