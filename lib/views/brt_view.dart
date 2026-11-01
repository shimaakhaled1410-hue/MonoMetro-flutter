import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../models/station_model.dart';
import '../services/brt_service.dart';
import 'widgets/brt_station_picker_sheet.dart';
import 'widgets/vertical_timeline.dart';

class BrtView extends StatefulWidget {
  const BrtView({super.key});

  @override
  State<BrtView> createState() => _BrtViewState();
}

class _BrtViewState extends State<BrtView> {
  final MetroController controller = Get.find<MetroController>();
  String? brtStartStation;
  String? brtEndStation;
  TripResult? brtTrip;

  void _openPicker(bool isStart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrtStationPickerSheet(
        title: isStart ? 'select_dep_station'.tr : 'select_dest_station'.tr,
        onSelected: (name) {
          setState(() {
            if (isStart) {
              brtStartStation = name;
            } else {
              brtEndStation = name;
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _calculateTrip() {
    if (brtStartStation == null || brtEndStation == null) {
      Get.snackbar('warning'.tr, 'select_both_stations'.tr);
      return;
    }
    if (brtStartStation == brtEndStation) {
      Get.snackbar('warning'.tr, 'same_station_error'.tr);
      return;
    }

    setState(() {
      brtTrip = BrtService.calculateBrtTrip(
        startStationName: brtStartStation!,
        endStationName: brtEndStation!,
        passengerType: controller.passengerType.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('nav_brt'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.trip_origin, color: Color(0xFF43A047)),
                      title: Text(brtStartStation ?? 'tap_select_start'.tr),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () => _openPicker(true),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Color(0xFFE53935)),
                      title: Text(brtEndStation ?? 'tap_select_end'.tr),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () => _openPicker(false),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _calculateTrip,
                        icon: const Icon(Icons.alt_route_rounded, size: 20),
                        label: Text('calculate_trip'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (brtTrip != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'fastest_route'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${brtTrip!.stationCount} ${'stations'.tr} • ${brtTrip!.estimatedTimeMinutes} ${'est_time'.tr}',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '0 ${'transfers_count'.tr} • ${brtTrip!.ticketPrice} ${'ticket'.tr}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              VerticalTimeline(trip: brtTrip!),
            ],
          ],
        ),
      ),
    );
  }
}