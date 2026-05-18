import 'package:flutter_test/flutter_test.dart';
import 'package:todos_riverpod/src/feature/weather/data/datasource/weather_remote_datasource.dart';
import 'package:todos_riverpod/src/feature/weather/data/model/current_weather_response.dart'
    as current_model;
import 'package:todos_riverpod/src/feature/weather/data/model/forecast_response.dart'
    as forecast_model;
import 'package:todos_riverpod/src/feature/weather/data/repository/weather_repository_impl.dart';

void main() {
  group('WeatherRepositoryImpl', () {
    test('maps current and forecast responses into weather snapshot', () async {
      final repository = WeatherRepositoryImpl(_FakeWeatherRemoteDatasource());

      final snapshot = await repository.fetchWeather(
        latitude: 13.7563,
        longitude: 100.5018,
      );

      expect(snapshot.locationName, 'Bangkok, TH');
      expect(snapshot.current.temperatureCelsius.round(), 31);
      expect(snapshot.current.description, 'Broken Clouds');
      expect(snapshot.hourly, isNotEmpty);
      expect(snapshot.daily, isNotEmpty);
      expect(snapshot.daily.first.highCelsius, greaterThanOrEqualTo(31));
      expect(snapshot.daily.first.lowCelsius, lessThanOrEqualTo(28));
    });
  });
}

class _FakeWeatherRemoteDatasource implements WeatherRemoteSource {
  @override
  Future<current_model.CurrentWeatherResponse> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    return const current_model.CurrentWeatherResponse(
      coord: current_model.Coord(lon: 100.5018, lat: 13.7563),
      weather: [
        current_model.Weather(
          id: 804,
          main: 'Clouds',
          description: 'broken clouds',
          icon: '04d',
        ),
      ],
      base: 'stations',
      main: current_model.Main(
        temp: 31.2,
        feelsLike: 34.0,
        tempMin: 30.0,
        tempMax: 32.0,
        pressure: 1009,
        humidity: 70,
      ),
      visibility: 10000,
      wind: current_model.Wind(speed: 2.8, deg: 180),
      clouds: current_model.Clouds(all: 80),
      dt: 1700000000,
      sys: current_model.Sys(
        country: 'TH',
        sunrise: 1699970000,
        sunset: 1700030000,
      ),
      timezone: 25200,
      id: 1609350,
      name: 'Bangkok',
      cod: 200,
    );
  }

  @override
  Future<forecast_model.ForecastResponse> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    return forecast_model.ForecastResponse(
      cod: '200',
      message: 0,
      cnt: 6,
      list: [
        _entry(1700000000, 30, 29, 31, 0.2, '03d', 'scattered clouds'),
        _entry(1700010800, 29, 28, 30, 0.1, '10n', 'light rain'),
        _entry(1700021600, 28, 27, 29, 0.5, '10n', 'moderate rain'),
        _entry(1700086400, 32, 30, 33, 0.0, '01d', 'clear sky'),
        _entry(1700097200, 31, 29, 32, 0.1, '02d', 'few clouds'),
        _entry(1700108000, 30, 28, 31, 0.0, '02n', 'few clouds'),
      ],
      city: const forecast_model.City(
        id: 1609350,
        name: 'Bangkok',
        coord: forecast_model.Coord(lat: 13.7563, lon: 100.5018),
        country: 'TH',
        timezone: 25200,
        sunrise: 1699970000,
        sunset: 1700030000,
      ),
    );
  }

  forecast_model.ListElement _entry(
    int dt,
    double temp,
    double min,
    double max,
    double pop,
    String icon,
    String description,
  ) {
    return forecast_model.ListElement(
      dt: dt,
      main: forecast_model.MainClass(
        temp: temp,
        feelsLike: temp + 1,
        tempMin: min,
        tempMax: max,
        pressure: 1009,
        humidity: 72,
      ),
      weather: [
        forecast_model.Weather(
          id: 800,
          main: icon.startsWith('10') ? 'Rain' : 'Clouds',
          description: description,
          icon: icon,
        ),
      ],
      clouds: const forecast_model.Clouds(all: 80),
      wind: const forecast_model.Wind(speed: 2.5, deg: 180),
      visibility: 10000,
      pop: pop,
      sys: forecast_model.Sys(
        pod: icon.endsWith('n') ? forecast_model.Pod.N : forecast_model.Pod.D,
      ),
      dtTxt: DateTime.fromMillisecondsSinceEpoch(dt * 1000, isUtc: true),
    );
  }
}
