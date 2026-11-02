import 'package:metro/models/fare_breakdown.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/trip_segment.dart';

class TripResult {
  TripResult({
    required this.segments,
    required this.fare,
    required this.estimatedTimeMinutes,
  });

  final List<TripSegment> segments;
  final FareBreakdown fare;
  final int estimatedTimeMinutes;

  late final List<Station> path = _buildPath();

  int get stationCount => path.length;

  int get transferCount => segments.isEmpty ? 0 : segments.length - 1;

  int get ticketPrice => fare.total;

  List<Station> _buildPath() {
    final result = <Station>[];
    for (final segment in segments) {
      for (final station in segment.stations) {
        if (result.isEmpty || result.last != station) result.add(station);
      }
    }
    return result;
  }

  bool hasSamePathAs(TripResult other) {
    if (path.length != other.path.length) return false;
    for (var i = 0; i < path.length; i++) {
      if (path[i] != other.path[i]) return false;
    }
    return true;
  }
}
