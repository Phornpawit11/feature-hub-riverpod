import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weather_location_service.g.dart';

@riverpod
WeatherLocationService weatherLocationService(Ref ref) {
  return GeolocatorWeatherLocationService();
}

class WeatherCoordinates {
  const WeatherCoordinates({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

abstract class WeatherLocationService {
  Future<WeatherCoordinates?> getCurrentCoordinates();
}

class GeolocatorWeatherLocationService implements WeatherLocationService {
  @override
  Future<WeatherCoordinates?> getCurrentCoordinates() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      return WeatherCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
      return null;
    }
  }
}
