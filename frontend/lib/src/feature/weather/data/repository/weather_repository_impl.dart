import 'dart:math' as math;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/feature/weather/data/datasource/weather_remote_datasource.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/current_weather_response.dart'
    as current_model;
import 'package:todos_riverpod/src/feature/weather/data/model/forecast_response.dart'
    as forecast_model;
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_repository.dart';

part 'weather_repository_impl.g.dart';

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  return WeatherRepositoryImpl(ref.watch(weatherRemoteDatasourceProvider));
}

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._remoteDatasource);

  final WeatherRemoteSource _remoteDatasource;

  @override
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final responses = await Future.wait([
      _remoteDatasource.fetchCurrentWeather(
        latitude: latitude,
        longitude: longitude,
      ),
      _remoteDatasource.fetchForecast(latitude: latitude, longitude: longitude),
    ]);

    final currentResponse = responses[0] as current_model.CurrentWeatherResponse;
    final forecastResponse = responses[1] as forecast_model.ForecastResponse;

    final timezoneOffset = currentResponse.timezone;
    final firstCurrentWeather = currentResponse.weather.isNotEmpty
        ? currentResponse.weather.first
        : null;

    final forecastList = forecastResponse.list;
    if (forecastList.isEmpty) {
      throw const WeatherException('Forecast data is unavailable right now.');
    }

    final hourly = _mapHourlyForecast(
      forecastList,
      timezoneOffset: timezoneOffset,
    );
    final daily = _mapDailyForecast(
      forecastList,
      timezoneOffset: timezoneOffset,
    );

    final name = currentResponse.name.trim();
    final country = currentResponse.sys.country.trim();
    final locationName = switch ((name, country)) {
      (final city, final nation) when city.isNotEmpty && nation.isNotEmpty =>
        '$city, $nation',
      (final city, _) when city.isNotEmpty => city,
      _ => _fallbackLocationName(forecastResponse),
    };

    final sunsetAt = _toLocationTime(
      currentResponse.sys.sunset,
      timezoneOffset,
    );

    return WeatherSnapshot(
      locationName: locationName,
      updatedAt: _toLocationTime(currentResponse.dt, timezoneOffset),
      current: CurrentWeather(
        temperatureCelsius: currentResponse.main.temp,
        feelsLikeCelsius: currentResponse.main.feelsLike,
        condition: firstCurrentWeather?.main ?? 'Weather',
        description: _titleCase(
          firstCurrentWeather?.description ?? 'Live conditions',
        ),
        iconCode: firstCurrentWeather?.icon ?? '01d',
        humidityPercent: currentResponse.main.humidity,
        windSpeedKph: currentResponse.wind.speed * 3.6,
        sunsetAt: sunsetAt,
        precipitationChance: hourly.isEmpty
            ? 0
            : hourly.first.precipitationChance,
      ),
      hourly: hourly,
      daily: daily,
    );
  }

  List<HourlyForecastItem> _mapHourlyForecast(
    List<forecast_model.ListElement> forecastList, {
    required int timezoneOffset,
  }) {
    return forecastList
        .take(8)
        .map((entry) {
          final weather = _firstWeather(entry);

          return HourlyForecastItem(
            time: _toLocationTime(entry.dt, timezoneOffset),
            temperatureCelsius: entry.main.temp,
            condition: weather?.main ?? 'Weather',
            iconCode: weather?.icon ?? '01d',
            precipitationChance: (entry.pop * 100).round(),
          );
        })
        .toList(growable: false);
  }

  List<DailyForecastItem> _mapDailyForecast(
    List<forecast_model.ListElement> forecastList, {
    required int timezoneOffset,
  }) {
    final grouped = <String, List<forecast_model.ListElement>>{};

    for (final entry in forecastList) {
      final time = _toLocationTime(entry.dt, timezoneOffset);
      final key =
          '${time.year.toString().padLeft(4, '0')}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => <forecast_model.ListElement>[]).add(entry);
    }

    return grouped.values
        .take(7)
        .map((entries) {
          final sorted = [...entries]
            ..sort((left, right) => (left.dt - right.dt).sign);
          final representative = _pickRepresentativeEntry(
            sorted,
            timezoneOffset: timezoneOffset,
          );
          final weather = _firstWeather(representative);

          double high = double.negativeInfinity;
          double low = double.infinity;
          int precipitation = 0;

          for (final entry in sorted) {
            high = math.max(
              high,
              entry.main.tempMax,
            );
            low = math.min(
              low,
              entry.main.tempMin,
            );
            precipitation = math.max(precipitation, (entry.pop * 100).round());
          }

          return DailyForecastItem(
            date: _toLocationTime(representative.dt, timezoneOffset),
            condition: _titleCase(
              weather?.description ?? 'Weather',
            ),
            iconCode: weather?.icon ?? '01d',
            highCelsius: high.isFinite ? high : 0,
            lowCelsius: low.isFinite ? low : 0,
            precipitationChance: precipitation,
          );
        })
        .toList(growable: false);
  }

  forecast_model.ListElement _pickRepresentativeEntry(
    List<forecast_model.ListElement> entries, {
    required int timezoneOffset,
  }) {
    var selected = entries.first;
    int bestDistance = 99;

    for (final entry in entries) {
      final time = _toLocationTime(entry.dt, timezoneOffset);
      final distance = (time.hour - 12).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        selected = entry;
      }
    }

    return selected;
  }

  DateTime _toLocationTime(int timestampSeconds, int timezoneOffsetSeconds) {
    return DateTime.fromMillisecondsSinceEpoch(
      (timestampSeconds + timezoneOffsetSeconds) * 1000,
      isUtc: true,
    );
  }

  forecast_model.Weather? _firstWeather(forecast_model.ListElement entry) {
    if (entry.weather.isEmpty) {
      return null;
    }

    return entry.weather.first;
  }

  String _fallbackLocationName(forecast_model.ForecastResponse forecastResponse) {
    final name = forecastResponse.city.name.trim();
    final country = forecastResponse.city.country.trim();

    if (name.isNotEmpty && country.isNotEmpty) {
      return '$name, $country';
    }
    if (name.isNotEmpty) {
      return name;
    }

    return 'Your forecast';
  }

  String _titleCase(String value) {
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

}
