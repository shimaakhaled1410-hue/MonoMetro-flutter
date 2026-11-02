import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';

enum SegmentType { ride, walk }

class TripSegment {
  const TripSegment({
    required this.type,
    required this.stations,
    this.line,
    this.towards,
    this.walkMinutes = 0,
  });

  final SegmentType type;
  final List<Station> stations;
  final TransitLine? line;
  final Station? towards;
  final int walkMinutes;

  bool get isWalk => type == SegmentType.walk;

  Station get from => stations.first;

  Station get to => stations.last;

  int get stops => stations.length - 1;
}
