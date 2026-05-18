// ignore_for_file: invalid_annotation_target

// To parse this JSON data, do
//
//     final forecastResponse = forecastResponseFromJson(jsonString);

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_response.freezed.dart';
part 'forecast_response.g.dart';

ForecastResponse forecastResponseFromJson(String str) =>
    ForecastResponse.fromJson(json.decode(str));

String forecastResponseToJson(ForecastResponse data) =>
    json.encode(data.toJson());

@freezed
abstract class ForecastResponse with _$ForecastResponse {
  const factory ForecastResponse({
    @JsonKey(name: "cod") required String cod,
    @JsonKey(name: "message") int? message,
    @JsonKey(name: "cnt") required int cnt,
    @JsonKey(name: "list") required List<ListElement> list,
    @JsonKey(name: "city") required City city,
  }) = _ForecastResponse;

  factory ForecastResponse.fromJson(Map<String, dynamic> json) =>
      _$ForecastResponseFromJson(json);
}

@freezed
abstract class City with _$City {
  const factory City({
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "coord") required Coord coord,
    @JsonKey(name: "country") required String country,
    @JsonKey(name: "population") int? population,
    @JsonKey(name: "timezone") required int timezone,
    @JsonKey(name: "sunrise") required int sunrise,
    @JsonKey(name: "sunset") required int sunset,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}

@freezed
abstract class Coord with _$Coord {
  const factory Coord({
    @JsonKey(name: "lat") required double lat,
    @JsonKey(name: "lon") required double lon,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);
}

@freezed
abstract class ListElement with _$ListElement {
  const factory ListElement({
    @JsonKey(name: "dt") required int dt,
    @JsonKey(name: "main") required MainClass main,
    @JsonKey(name: "weather") required List<Weather> weather,
    @JsonKey(name: "clouds") required Clouds clouds,
    @JsonKey(name: "wind") required Wind wind,
    @JsonKey(name: "visibility") required int visibility,
    @JsonKey(name: "pop") required double pop,
    @JsonKey(name: "rain") Rain? rain,
    @JsonKey(name: "sys") required Sys sys,
    @JsonKey(name: "dt_txt") required DateTime dtTxt,
  }) = _ListElement;

  factory ListElement.fromJson(Map<String, dynamic> json) =>
      _$ListElementFromJson(json);
}

@freezed
abstract class Clouds with _$Clouds {
  const factory Clouds({@JsonKey(name: "all") required int all}) = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
abstract class MainClass with _$MainClass {
  const factory MainClass({
    @JsonKey(name: "temp") required double temp,
    @JsonKey(name: "feels_like") required double feelsLike,
    @JsonKey(name: "temp_min") required double tempMin,
    @JsonKey(name: "temp_max") required double tempMax,
    @JsonKey(name: "pressure") required int pressure,
    @JsonKey(name: "sea_level") int? seaLevel,
    @JsonKey(name: "grnd_level") int? grndLevel,
    @JsonKey(name: "humidity") required int humidity,
    @JsonKey(name: "temp_kf") double? tempKf,
  }) = _MainClass;

  factory MainClass.fromJson(Map<String, dynamic> json) =>
      _$MainClassFromJson(json);
}

@freezed
abstract class Rain with _$Rain {
  const factory Rain({@JsonKey(name: "3h") required double the3H}) = _Rain;

  factory Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);
}

@freezed
abstract class Sys with _$Sys {
  const factory Sys({@JsonKey(name: "pod") required Pod pod}) = _Sys;

  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);
}

enum Pod {
  @JsonValue("d")
  D,
  @JsonValue("n")
  N,
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
