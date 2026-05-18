// ignore_for_file: invalid_annotation_target

// To parse this JSON data, do
//
//     final currentWeatherResponse = currentWeatherResponseFromJson(jsonString);

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_weather_response.freezed.dart';
part 'current_weather_response.g.dart';

CurrentWeatherResponse currentWeatherResponseFromJson(String str) =>
    CurrentWeatherResponse.fromJson(json.decode(str));

String currentWeatherResponseToJson(CurrentWeatherResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class CurrentWeatherResponse with _$CurrentWeatherResponse {
  const factory CurrentWeatherResponse({
    @JsonKey(name: "coord") required Coord coord,
    @JsonKey(name: "weather") required List<Weather> weather,
    @JsonKey(name: "base") required String base,
    @JsonKey(name: "main") required Main main,
    @JsonKey(name: "visibility") required int visibility,
    @JsonKey(name: "wind") required Wind wind,
    @JsonKey(name: "clouds") required Clouds clouds,
    @JsonKey(name: "dt") required int dt,
    @JsonKey(name: "sys") required Sys sys,
    @JsonKey(name: "timezone") required int timezone,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "cod") required int cod,
  }) = _CurrentWeatherResponse;

  factory CurrentWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherResponseFromJson(json);
}

@freezed
abstract class Clouds with _$Clouds {
  const factory Clouds({@JsonKey(name: "all") required int all}) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
abstract class Coord with _$Coord {
  const factory Coord({
    @JsonKey(name: "lon") required double lon,
    @JsonKey(name: "lat") required double lat,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@freezed
abstract class Main with _$Main {
  const factory Main({
    @JsonKey(name: "temp") required double temp,
    @JsonKey(name: "feels_like") required double feelsLike,
    @JsonKey(name: "temp_min") required double tempMin,
    @JsonKey(name: "temp_max") required double tempMax,
    @JsonKey(name: "pressure") required int pressure,
    @JsonKey(name: "humidity") required int humidity,
    @JsonKey(name: "sea_level") int? seaLevel,
    @JsonKey(name: "grnd_level") int? grndLevel,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@freezed
abstract class Sys with _$Sys {
  const factory Sys({
    @JsonKey(name: "country") required String country,
    @JsonKey(name: "sunrise") required int sunrise,
    @JsonKey(name: "sunset") required int sunset,
  }) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}

@freezed
abstract class Weather with _$Weather {
  const factory Weather({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "main") required String main,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "icon") required String icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
}

@freezed
abstract class Wind with _$Wind {
  const factory Wind({
    @JsonKey(name: "speed") required double speed,
    @JsonKey(name: "deg") required int deg,
    @JsonKey(name: "gust") double? gust,
  }) = _Wind;

  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);
}
