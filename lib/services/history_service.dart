import 'dart:convert';

import 'package:metro/core/constants/storage_keys.dart';
import 'package:metro/models/trip_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  const HistoryService._();

  static Future<List<TripHistory>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(StorageKeys.tripHistory) ?? const [];
    final trips = <TripHistory>[];
    for (final item in raw) {
      try {
        trips.add(
          TripHistory.fromJson(jsonDecode(item) as Map<String, dynamic>),
        );
      } catch (_) {
        continue;
      }
    }
    return trips;
  }

  static Future<void> saveAll(List<TripHistory> trips) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = trips.map((trip) => jsonEncode(trip.toJson())).toList();
    await prefs.setStringList(StorageKeys.tripHistory, encoded);
  }
}
