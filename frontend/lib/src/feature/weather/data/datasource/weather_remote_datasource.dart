import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todos_riverpod/src/core/config/app_env.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/current_weather_response.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/forecast_response.dart';
import 'package:todos_riverpod/src/feature/weather/domain/weather_repository.dart';

part 'weather_remote_datasource.g.dart';

@riverpod
Dio weatherDio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: const {'Content-Type': 'application/json'},
    ),
  );
}

@riverpod
WeatherRemoteDatasource weatherRemoteDatasource(Ref ref) {
  return WeatherRemoteDatasource(
    ref.watch(weatherDioProvider),
    ref.watch(appEnvProvider),
  );
}

class WeatherRemoteDatasource implements WeatherRemoteSource {
  WeatherRemoteDatasource(this._dio, this._appEnv);

  final Dio _dio;
  final AppEnv _appEnv;

  @override
  Future<CurrentWeatherResponse> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    return _getCurrentWeather(
      '/weather',
      queryParameters: _buildQueryParameters(latitude, longitude),
    );
  }

  @override
  Future<ForecastResponse> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    return _getForecast(
      '/forecast',
      queryParameters: _buildQueryParameters(latitude, longitude),
    );
  }

  Map<String, dynamic> _buildQueryParameters(
    double latitude,
    double longitude,
  ) {
    final apiKey = _appEnv.openWeatherApiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw const WeatherException(
        'Weather API key is missing. Add OPENWEATHER_API_KEY to your .env file.',
      );
    }

    return {
      'lat': latitude,
      'lon': longitude,
      'appid': apiKey,
      'units': 'metric',
    };
  }

  Future<CurrentWeatherResponse> _getCurrentWeather(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data == null) {
        throw const WeatherException('Invalid weather response from server.');
      }

      return CurrentWeatherResponse.fromJson(data);
    } on DioException catch (error) {
      throw WeatherException(_extractErrorMessage(error));
    }
  }

  Future<ForecastResponse> _getForecast(
    String path, {
    required Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data == null) {
        throw const WeatherException('Invalid weather response from server.');
      }
      return ForecastResponse.fromJson(data);
    } on DioException catch (error) {
      throw WeatherException(_extractErrorMessage(error));
    }
  }

  String _extractErrorMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return _titleCase(message.trim());
      }
    }

    return switch (error.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        'Unable to reach OpenWeather right now. Please try again.',
      _ => 'Unable to load weather right now. Please try again.',
    };
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }

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

abstract class WeatherRemoteSource {
  Future<CurrentWeatherResponse> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  });

  Future<ForecastResponse> fetchForecast({
    required double latitude,
    required double longitude,
  });
}
