import 'package:metro/data/lines_data.dart';
import 'package:metro/data/stations_data.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';

class StationRepository {
  const StationRepository._();

  static final List<Station> all = _build();

  static final Map<String, Station> _byName = {
    for (final station in all) station.name: station,
  };

  static Station? byName(String name) => _byName[name];

  static List<Station> forLine(TransitLine line) {
    return LinesData.namesFor(line)
        .map(byName)
        .whereType<Station>()
        .toList();
  }

  static List<Station> _build() {
    final linesByName = <String, List<TransitLine>>{};
    for (final segment in LinesData.segments) {
      for (final name in segment.stations) {
        final lines = linesByName.putIfAbsent(name, () => <TransitLine>[]);
        if (!lines.contains(segment.line)) lines.add(segment.line);
      }
    }
    return StationsData.records
        .map(
          (record) => Station(
            name: record.name,
            nameAr: record.nameAr,
            latitude: record.latitude,
            longitude: record.longitude,
            lines: List.unmodifiable(linesByName[record.name] ?? const []),
          ),
        )
        .toList();
  }
}
