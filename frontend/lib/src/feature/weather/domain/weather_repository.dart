import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';

abstract class WeatherRepository {
  Future<WeatherSnapshot> fetchWeather({
    required double latitude,
    required double longitude,
  });
}

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}
