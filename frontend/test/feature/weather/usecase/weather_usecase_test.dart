import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/weather/data/location/weather_location_service.dart';
import 'package:todos_riverpod/src/feature/weather/data/repository/weather_repository_impl.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_repository.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_state.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_usecase.dart';

void main() {
  group('WeatherUsecase', () {
    late _FakeWeatherRepository fakeRepository;
    late _FakeWeatherLocationService fakeLocationService;
    late ProviderContainer container;

    setUp(() {
      fakeRepository = _FakeWeatherRepository();
      fakeLocationService = _FakeWeatherLocationService();
      container = ProviderContainer(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(fakeRepository),
          weatherLocationServiceProvider.overrideWithValue(fakeLocationService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('uses gps coordinates when available', () async {
      fakeLocationService.coordinates = const WeatherCoordinates(
        latitude: 1.23,
        longitude: 4.56,
      );

      final notifier = container.read(weatherUsecaseProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.loadWeather();

      final state = container.read(weatherUsecaseProvider);
      expect(fakeRepository.lastLatitude, 1.23);
      expect(fakeRepository.lastLongitude, 4.56);
      expect(state.status, WeatherStatus.success);
      expect(state.isUsingFallbackLocation, isFalse);
    });

    test('falls back to bangkok when gps is unavailable', () async {
      fakeLocationService.coordinates = null;

      final notifier = container.read(weatherUsecaseProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.loadWeather();

      final state = container.read(weatherUsecaseProvider);
      expect(fakeRepository.lastLatitude, closeTo(13.7563, 0.0001));
      expect(fakeRepository.lastLongitude, closeTo(100.5018, 0.0001));
      expect(state.isUsingFallbackLocation, isTrue);
      expect(state.status, WeatherStatus.success);
    });

    test('exposes repository error as weather error state', () async {
      fakeRepository.error = const WeatherException('OpenWeather failed');

      final notifier = container.read(weatherUsecaseProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.loadWeather();

      final state = container.read(weatherUsecaseProvider);
      expect(state.status, WeatherStatus.error);
      expect(state.errorMessage, 'OpenWeather failed');
    });

    test('deduplicates concurrent loadWeather calls', () async {
      fakeRepository.completer = Completer<WeatherSnapshot>();

      final notifier = container.read(weatherUsecaseProvider.notifier);
      await Future<void>.delayed(Duration.zero);

      final first = notifier.loadWeather();
      final second = notifier.loadWeather();

      expect(fakeRepository.fetchCallCount, 1);

      fakeRepository.completer!.complete(_testSnapshot());
      await Future.wait([first, second]);
    });
  });
}

class _FakeWeatherRepository implements WeatherRepository {
  double? lastLatitude;
  double? lastLongitude;
  WeatherException? error;
  int fetchCallCount = 0;
  Completer<WeatherSnapshot>? completer;

  @override
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    fetchCallCount++;
    lastLatitude = latitude;
    lastLongitude = longitude;

    if (error != null) {
      throw error!;
    }

    final pending = completer;
    if (pending != null) {
      return pending.future;
    }

    return _testSnapshot();
  }
}

WeatherSnapshot _testSnapshot() {
  return WeatherSnapshot(
      locationName: 'Bangkok, TH',
      updatedAt: DateTime.utc(2024, 1, 1, 12),
      current: CurrentWeather(
        temperatureCelsius: 30,
        feelsLikeCelsius: 33,
        condition: 'Clouds',
        description: 'Warm evening',
        iconCode: '03d',
        humidityPercent: 70,
        windSpeedKph: 12,
        sunsetAt: DateTime.utc(2024, 1, 1, 18),
        precipitationChance: 20,
      ),
      hourly: [
        HourlyForecastItem(
          time: DateTime.utc(2024, 1, 1, 13),
          temperatureCelsius: 30,
          condition: 'Clouds',
          iconCode: '03d',
          precipitationChance: 10,
        ),
      ],
      daily: [
        DailyForecastItem(
          date: DateTime(2024),
          condition: 'Broken clouds',
          iconCode: '03d',
          highCelsius: 31,
          lowCelsius: 28,
          precipitationChance: 10,
        ),
      ],
    );
}

class _FakeWeatherLocationService implements WeatherLocationService {
  WeatherCoordinates? coordinates = const WeatherCoordinates(
    latitude: 13.7563,
    longitude: 100.5018,
  );

  @override
  Future<WeatherCoordinates?> getCurrentCoordinates() async => coordinates;
}
