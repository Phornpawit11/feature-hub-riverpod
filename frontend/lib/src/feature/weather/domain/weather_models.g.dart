// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherSnapshot _$WeatherSnapshotFromJson(Map<String, dynamic> json) =>
    _WeatherSnapshot(
      locationName: json['locationName'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      current: CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyForecastItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyForecastItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherSnapshotToJson(_WeatherSnapshot instance) =>
    <String, dynamic>{
      'locationName': instance.locationName,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'current': instance.current,
      'hourly': instance.hourly,
      'daily': instance.daily,
    };

_CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    _CurrentWeather(
      temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
      feelsLikeCelsius: (json['feelsLikeCelsius'] as num).toDouble(),
      condition: json['condition'] as String,
      description: json['description'] as String,
      iconCode: json['iconCode'] as String,
      humidityPercent: (json['humidityPercent'] as num).toInt(),
      windSpeedKph: (json['windSpeedKph'] as num).toDouble(),
      sunsetAt: DateTime.parse(json['sunsetAt'] as String),
      precipitationChance: (json['precipitationChance'] as num).toInt(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(_CurrentWeather instance) =>
    <String, dynamic>{
      'temperatureCelsius': instance.temperatureCelsius,
      'feelsLikeCelsius': instance.feelsLikeCelsius,
      'condition': instance.condition,
      'description': instance.description,
      'iconCode': instance.iconCode,
      'humidityPercent': instance.humidityPercent,
      'windSpeedKph': instance.windSpeedKph,
      'sunsetAt': instance.sunsetAt.toIso8601String(),
      'precipitationChance': instance.precipitationChance,
    };

_HourlyForecastItem _$HourlyForecastItemFromJson(Map<String, dynamic> json) =>
    _HourlyForecastItem(
      time: DateTime.parse(json['time'] as String),
      temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
      condition: json['condition'] as String,
      iconCode: json['iconCode'] as String,
      precipitationChance: (json['precipitationChance'] as num).toInt(),
    );

Map<String, dynamic> _$HourlyForecastItemToJson(_HourlyForecastItem instance) =>
    <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'temperatureCelsius': instance.temperatureCelsius,
      'condition': instance.condition,
      'iconCode': instance.iconCode,
      'precipitationChance': instance.precipitationChance,
    };

_DailyForecastItem _$DailyForecastItemFromJson(Map<String, dynamic> json) =>
    _DailyForecastItem(
      date: DateTime.parse(json['date'] as String),
      condition: json['condition'] as String,
      iconCode: json['iconCode'] as String,
      highCelsius: (json['highCelsius'] as num).toDouble(),
      lowCelsius: (json['lowCelsius'] as num).toDouble(),
      precipitationChance: (json['precipitationChance'] as num).toInt(),
    );

Map<String, dynamic> _$DailyForecastItemToJson(_DailyForecastItem instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'condition': instance.condition,
      'iconCode': instance.iconCode,
      'highCelsius': instance.highCelsius,
      'lowCelsius': instance.lowCelsius,
      'precipitationChance': instance.precipitationChance,
    };
