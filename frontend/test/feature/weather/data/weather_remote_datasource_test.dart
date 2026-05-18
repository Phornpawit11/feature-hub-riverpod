import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';
import 'package:todos_riverpod/src/feature/weather/data/datasource/weather_remote_datasource.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/current_weather_response.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/forecast_response.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_repository.dart';

void main() {
  group('WeatherRemoteDatasource', () {
    test('fetchCurrentWeather sends metric request with coordinates', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {
                    'coord': {'lon': 100.5018, 'lat': 13.7563},
                    'name': 'Bangkok',
                    'base': 'stations',
                    'weather': [
                      {'id': 801, 'main': 'Clouds', 'description': 'few clouds', 'icon': '02d'},
                    ],
                    'main': {
                      'temp': 31.4,
                      'feels_like': 35.1,
                      'temp_min': 30.1,
                      'temp_max': 32.2,
                      'pressure': 1009,
                      'humidity': 72,
                    },
                    'visibility': 10000,
                    'wind': {'speed': 2.1, 'deg': 180},
                    'clouds': {'all': 20},
                    'sys': {'country': 'TH', 'sunrise': 1, 'sunset': 2},
                    'timezone': 25200,
                    'id': 1609350,
                    'dt': 1,
                    'cod': 200,
                  },
                ),
              );
            },
          ),
        );

      final datasource = WeatherRemoteDatasource(
        dio,
        AppEnv.fromMap(const {'OPENWEATHER_API_KEY': 'weather-key'}),
      );

      final response = await datasource.fetchCurrentWeather(
        latitude: 13.7563,
        longitude: 100.5018,
      );

      expect(capturedOptions.path, '/weather');
      expect(capturedOptions.method, 'GET');
      expect(capturedOptions.queryParameters['lat'], 13.7563);
      expect(capturedOptions.queryParameters['lon'], 100.5018);
      expect(capturedOptions.queryParameters['appid'], 'weather-key');
      expect(capturedOptions.queryParameters['units'], 'metric');
      expect(response, isA<CurrentWeatherResponse>());
      expect(response.name, 'Bangkok');
    });

    test('fetchForecast sends metric request and parses payload', () async {
      late RequestOptions capturedOptions;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'))
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedOptions = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  data: {
                    'cod': '200',
                    'message': 0,
                    'cnt': 1,
                    'list': [
                      {
                        'dt': 1,
                        'main': {
                          'temp': 30.0,
                          'feels_like': 31.0,
                          'temp_min': 29.0,
                          'temp_max': 31.0,
                          'pressure': 1008,
                          'humidity': 80,
                        },
                        'weather': [
                          {'id': 500, 'main': 'Rain', 'description': 'light rain', 'icon': '10d'},
                        ],
                        'clouds': {'all': 80},
                        'wind': {'speed': 3.0, 'deg': 150},
                        'visibility': 10000,
                        'pop': 0.4,
                        'sys': {'pod': 'd'},
                        'dt_txt': '2024-01-01 12:00:00',
                      },
                    ],
                    'city': {
                      'id': 1609350,
                      'name': 'Bangkok',
                      'coord': {'lat': 13.7563, 'lon': 100.5018},
                      'country': 'TH',
                      'timezone': 25200,
                      'sunrise': 1,
                      'sunset': 2,
                    },
                  },
                ),
              );
            },
          ),
        );

      final datasource = WeatherRemoteDatasource(
        dio,
        AppEnv.fromMap(const {'OPENWEATHER_API_KEY': 'weather-key'}),
      );

      final response = await datasource.fetchForecast(
        latitude: 13.7563,
        longitude: 100.5018,
      );

      expect(capturedOptions.path, '/forecast');
      expect(capturedOptions.method, 'GET');
      expect(response, isA<ForecastResponse>());
      expect(response.city.name, 'Bangkok');
      expect(response.list.length, 1);
    });

    test('throws descriptive error when api key is missing', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'));
      final datasource = WeatherRemoteDatasource(dio, AppEnv.fromMap(const {}));

      expect(
        () => datasource.fetchCurrentWeather(latitude: 1, longitude: 2),
        throwsA(
          isA<WeatherException>().having(
            (error) => error.message,
            'message',
            contains('OPENWEATHER_API_KEY'),
          ),
        ),
      );
    });
  });
}
