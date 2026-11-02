import 'dart:math' as math;

import 'package:metro/models/station.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/services/station_repository.dart';

class NearestStationService {
  const NearestStationService._();

  static const double _earthRadiusMeters = 6371000;

  static Station find(double latitude, double longitude, {TransitMode? mode}) {
    var candidates = StationRepository.all;
    if (mode != null) {
      final filtered = candidates.where((s) => s.servesMode(mode)).toList();
      if (filtered.isNotEmpty) candidates = filtered;
    }

    var nearest = candidates.first;
    var minDistance = double.infinity;
    for (final station in candidates) {
      final distance = distanceMeters(
        latitude,
        longitude,
        station.latitude,
        station.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearest = station;
      }
    }
    return nearest;
  }

  static double distanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _radians(lat2 - lat1);
    final dLon = _radians(lon2 - lon1);
    final a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_radians(lat1)) *
            math.cos(_radians(lat2)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * _earthRadiusMeters * math.asin(math.sqrt(a));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
