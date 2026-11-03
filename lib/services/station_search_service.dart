import 'package:metro/core/utils/text_normalizer.dart';
import 'package:metro/data/areas_data.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_network.dart';
import 'package:metro/services/station_repository.dart';

class StationSearchService {
  const StationSearchService._();

  static List<Station> search(String rawQuery, TransitNetwork network) {
    final query = TextNormalizer.normalize(rawQuery);
    if (query.isEmpty) return const [];

    final results = StationRepository.forNetwork(network).where((station) {
      return TextNormalizer.normalize(station.name).contains(query) ||
          TextNormalizer.normalize(station.nameAr).contains(query);
    }).toList();

    for (final entry in AreasData.directory.entries) {
      if (!TextNormalizer.normalize(entry.key).contains(query)) continue;
      final station = StationRepository.byName(entry.value);
      if (station == null || station.network != network) continue;
      if (!results.contains(station)) results.add(station);
    }
    return results;
  }
}
