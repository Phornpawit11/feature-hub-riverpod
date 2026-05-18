import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_models.dart';
import 'package:todos_riverpod/src/feature/weather/presentation/weather_visual_tone.dart';

void main() {
  group('resolveWeatherToneKind', () {
    test('maps clear day icon to clearDay', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Clear',
            description: 'clear sky',
            iconCode: '01d',
          ),
        ),
        WeatherToneKind.clearDay,
      );
    });

    test('maps clear night icon to clearNight', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Clear',
            description: 'clear sky',
            iconCode: '01n',
          ),
        ),
        WeatherToneKind.clearNight,
      );
    });

    test('maps rain and drizzle family to rain', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Rain',
            description: 'light drizzle',
            iconCode: '10d',
          ),
        ),
        WeatherToneKind.rain,
      );
    });

    test('maps thunderstorm to thunderstorm', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Thunderstorm',
            description: 'thunderstorm with rain',
            iconCode: '11d',
          ),
        ),
        WeatherToneKind.thunderstorm,
      );
    });

    test('maps mist, fog, and haze family to mist', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Mist',
            description: 'haze',
            iconCode: '50d',
          ),
        ),
        WeatherToneKind.mist,
      );
    });

    test('falls back to cloudy for unknown daytime condition', () {
      expect(
        resolveWeatherToneKind(
          _currentWeather(
            condition: 'Ash',
            description: 'volcanic ash',
            iconCode: '04d',
          ),
        ),
        WeatherToneKind.cloudy,
      );
    });
  });
}

CurrentWeather _currentWeather({
  required String condition,
  required String description,
  required String iconCode,
}) {
  return CurrentWeather(
    temperatureCelsius: 28,
    feelsLikeCelsius: 30,
    condition: condition,
    description: description,
    iconCode: iconCode,
    humidityPercent: 70,
    windSpeedKph: 12,
    sunsetAt: DateTime.utc(2024, 1, 1, 18),
    precipitationChance: 24,
  );
}
