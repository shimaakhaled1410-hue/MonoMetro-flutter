import 'package:metro/models/trip_history.dart';
import 'package:metro/services/station_repository.dart';

extension TripHistoryLabels on TripHistory {
  String get startLabel => _name(startStation);

  /// Destination, prefixed with the landmark it was picked from if any.
  String get endLabel {
    final tag = destinationTag;
    final end = _name(endStation);
    return (tag != null && tag.isNotEmpty) ? '$tag ($end)' : end;
  }

  static String _name(String name) {
    return StationRepository.byName(name)?.localizedName ?? name;
  }
}
