import 'package:geolocator/geolocator.dart';

enum LocationFailure {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}

class LocationResult {
  LocationResult.success(Position value)
      : position = value,
        failure = null;

  LocationResult.failure(LocationFailure reason)
      : position = null,
        failure = reason;

  final Position? position;
  final LocationFailure? failure;
}

class LocationService {
  const LocationService._();

  static Future<LocationResult> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationResult.failure(LocationFailure.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        return LocationResult.failure(LocationFailure.permissionDenied);
      }
      if (permission == LocationPermission.deniedForever) {
        return LocationResult.failure(LocationFailure.permissionDeniedForever);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationResult.success(position);
    } catch (_) {
      return LocationResult.failure(LocationFailure.unavailable);
    }
  }
}
