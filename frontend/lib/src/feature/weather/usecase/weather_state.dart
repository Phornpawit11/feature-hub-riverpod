import 'package:flutter/foundation.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';

enum WeatherStatus { loading, success, error }

@immutable
class WeatherState {
  const WeatherState({
    required this.status,
    this.snapshot,
    this.errorMessage,
    this.isUsingFallbackLocation = false,
    this.isRefreshing = false,
  });

  const WeatherState.loading({
    WeatherSnapshot? snapshot,
    bool isUsingFallbackLocation = false,
    bool isRefreshing = false,
  }) : this(
         status: WeatherStatus.loading,
         snapshot: snapshot,
         isUsingFallbackLocation: isUsingFallbackLocation,
         isRefreshing: isRefreshing,
       );

  const WeatherState.success({
    required WeatherSnapshot snapshot,
    bool isUsingFallbackLocation = false,
    bool isRefreshing = false,
  }) : this(
         status: WeatherStatus.success,
         snapshot: snapshot,
         isUsingFallbackLocation: isUsingFallbackLocation,
         isRefreshing: isRefreshing,
       );

  const WeatherState.error({
    required String errorMessage,
    WeatherSnapshot? snapshot,
    bool isUsingFallbackLocation = false,
  }) : this(
         status: WeatherStatus.error,
         snapshot: snapshot,
         errorMessage: errorMessage,
         isUsingFallbackLocation: isUsingFallbackLocation,
       );

  final WeatherStatus status;
  final WeatherSnapshot? snapshot;
  final String? errorMessage;
  final bool isUsingFallbackLocation;
  final bool isRefreshing;

  bool get isBusy => status == WeatherStatus.loading;
  bool get isLoading => status == WeatherStatus.loading && snapshot == null;
  bool get hasData => snapshot != null;

  WeatherState copyWith({
    WeatherStatus? status,
    WeatherSnapshot? snapshot,
    String? errorMessage,
    bool clearError = false,
    bool? isUsingFallbackLocation,
    bool? isRefreshing,
  }) {
    return WeatherState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isUsingFallbackLocation:
          isUsingFallbackLocation ?? this.isUsingFallbackLocation,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}
