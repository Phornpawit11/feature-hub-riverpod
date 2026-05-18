import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todos_riverpod/src/feature/weather/data/location/weather_location_service.dart';
import 'package:todos_riverpod/src/feature/weather/data/repository/weather_repository_impl.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_repository.dart';
import 'package:todos_riverpod/src/feature/weather/usecase/weather_state.dart';

final weatherUsecaseProvider =
    NotifierProvider<WeatherUsecase, WeatherState>(WeatherUsecase.new);

class WeatherUsecase extends Notifier<WeatherState> {
  static const WeatherCoordinates _fallbackBangkok = WeatherCoordinates(
    latitude: 13.7563,
    longitude: 100.5018,
  );

  WeatherRepository get _repository => ref.read(weatherRepositoryProvider);
  WeatherLocationService get _locationService =>
      ref.read(weatherLocationServiceProvider);
  Future<void>? _inFlightLoad;

  @override
  WeatherState build() {
    Future.microtask(loadWeather);
    return const WeatherState.loading();
  }

  Future<void> loadWeather() async {
    final existingLoad = _inFlightLoad;
    if (existingLoad != null) {
      return existingLoad;
    }

    final future = _loadWeatherInternal();
    _inFlightLoad = future;
    return future.whenComplete(() {
      if (identical(_inFlightLoad, future)) {
        _inFlightLoad = null;
      }
    });
  }

  Future<void> _loadWeatherInternal() async {
    final previousSnapshot = state.snapshot;
    final wasUsingFallback = state.isUsingFallbackLocation;
    state = WeatherState.loading(
      snapshot: previousSnapshot,
      isUsingFallbackLocation: wasUsingFallback,
      isRefreshing: previousSnapshot != null,
    );

    try {
      final coordinates = await _locationService.getCurrentCoordinates();
      final isUsingFallback = coordinates == null;
      final resolvedCoordinates = coordinates ?? _fallbackBangkok;

      final snapshot = await _repository.fetchWeather(
        latitude: resolvedCoordinates.latitude,
        longitude: resolvedCoordinates.longitude,
      );

      state = WeatherState.success(
        snapshot: snapshot,
        isUsingFallbackLocation: isUsingFallback,
      );
    } on WeatherException catch (error) {
      state = WeatherState.error(
        errorMessage: error.message,
        snapshot: previousSnapshot,
        isUsingFallbackLocation: previousSnapshot != null
            ? wasUsingFallback
            : true,
      );
    } catch (_) {
      state = WeatherState.error(
        errorMessage: 'Something went wrong while loading weather.',
        snapshot: previousSnapshot,
        isUsingFallbackLocation: previousSnapshot != null
            ? wasUsingFallback
            : true,
      );
    }
  }
}
