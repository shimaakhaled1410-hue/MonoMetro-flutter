import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/metro_data.dart';
import '../models/station_model.dart';
import '../services/location_service.dart';

class BrtView extends StatelessWidget {
  const BrtView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brtStations = MetroData.brtRingRoadNames
        .map((name) => MetroData.allStations.firstWhereOrNull((s) => s.name == name))
        .whereType<Station>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('nav_brt'.tr),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: brtStations.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final station = brtStations[index];
          final isInterchange = station.lines.length > 1;

          return Card(
            elevation: 0,
            color: isDark ? const Color(0xFF1E222B) : Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isInterchange ? const Color(0xFFF39C12) : (isDark ? const Color(0xFF2C3240) : Colors.grey.shade200),
                width: isInterchange ? 1.5 : 1,
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF39C12).withValues(alpha: 0.15),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Color(0xFFF39C12), fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                station.localizedName,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              subtitle: isInterchange
                  ? Text(
                      'transfer'.tr,
                      style: const TextStyle(color: Color(0xFFF39C12), fontSize: 12),
                    )
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.location_on_outlined, color: Color(0xFFF39C12)),
                onPressed: () => LocationService.openStationOnMap(station),
              ),
            ),
          );
        },
      ),
    );
  }
}