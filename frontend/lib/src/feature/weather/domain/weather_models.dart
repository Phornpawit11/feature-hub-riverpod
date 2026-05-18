import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_models.freezed.dart';
part 'weather_models.g.dart';

@freezed
abstract class WeatherSnapshot with _$WeatherSnapshot {
  const factory WeatherSnapshot({
    required String locationName,
    required DateTime updatedAt,
    required CurrentWeather current,
    required List<HourlyForecastItem> hourly,
    required List<DailyForecastItem> daily,
  }) = _WeatherSnapshot;

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) =>
      _$WeatherSnapshotFromJson(json);
}

@freezed
abstract class CurrentWeather with _$CurrentWeather {
  const factory CurrentWeather({
    required double temperatureCelsius,
    required double feelsLikeCelsius,
    required String condition,
    required String description,
    required String iconCode,
    required int humidityPercent,
    required double windSpeedKph,
    required DateTime sunsetAt,
    required int precipitationChance,
  }) = _CurrentWeather;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
}

@freezed
abstract class HourlyForecastItem with _$HourlyForecastItem {
  const factory HourlyForecastItem({
    required DateTime time,
    required double temperatureCelsius,
    required String condition,
    required String iconCode,
    required int precipitationChance,
  }) = _HourlyForecastItem;

  factory HourlyForecastItem.fromJson(Map<String, dynamic> json) =>
      _$HourlyForecastItemFromJson(json);
}

@freezed
abstract class DailyForecastItem with _$DailyForecastItem {
  const factory DailyForecastItem({
    required DateTime date,
    required String condition,
    required String iconCode,
    required double highCelsius,
    required double lowCelsius,
    required int precipitationChance,
  }) = _DailyForecastItem;

  factory DailyForecastItem.fromJson(Map<String, dynamic> json) =>
      _$DailyForecastItemFromJson(json);
}
