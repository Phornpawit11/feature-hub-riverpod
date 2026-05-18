import 'package:flutter/material.dart';

@immutable
class WeatherSnapshot {
  const WeatherSnapshot({
    required this.locationName,
    required this.updatedAt,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  final String locationName;
  final DateTime updatedAt;
  final CurrentWeather current;
  final List<HourlyForecastItem> hourly;
  final List<DailyForecastItem> daily;
}

@immutable
class CurrentWeather {
  const CurrentWeather({
    required this.temperatureCelsius,
    required this.feelsLikeCelsius,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.humidityPercent,
    required this.windSpeedKph,
    required this.sunsetAt,
    required this.precipitationChance,
  });

  final double temperatureCelsius;
  final double feelsLikeCelsius;
  final String condition;
  final String description;
  final String iconCode;
  final int humidityPercent;
  final double windSpeedKph;
  final DateTime sunsetAt;
  final int precipitationChance;
}

@immutable
class HourlyForecastItem {
  const HourlyForecastItem({
    required this.time,
    required this.temperatureCelsius,
    required this.condition,
    required this.iconCode,
    required this.precipitationChance,
  });

  final DateTime time;
  final double temperatureCelsius;
  final String condition;
  final String iconCode;
  final int precipitationChance;
}

@immutable
class DailyForecastItem {
  const DailyForecastItem({
    required this.date,
    required this.condition,
    required this.iconCode,
    required this.highCelsius,
    required this.lowCelsius,
    required this.precipitationChance,
  });

  final DateTime date;
  final String condition;
  final String iconCode;
  final double highCelsius;
  final double lowCelsius;
  final int precipitationChance;
}
