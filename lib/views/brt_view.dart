import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/metro_controller.dart';
import '../services/fare_calculator_service.dart';
import 'widgets/brt_station_picker_sheet.dart';
import 'widgets/vertical_timeline.dart';

class BrtView extends StatelessWidget {
  const BrtView({super.key});

  static const Color brtColor = Color(0xFFF39C12);

  void _pickStation(BuildContext context, MetroController controller, bool isStart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BrtStationPickerSheet(
        title: isStart ? 'select_dep_station'.tr : 'select_dest_station'.tr,
        onSelected: (name) {
          if (isStart) {
            controller.selectStartStation(name);
          } else {
            controller.selectEndStation(name);
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<MetroController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_bus_rounded, color: brtColor),
            const SizedBox(width: 8),
            Text(
              'nav_brt'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, color: brtColor),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: isDark ? const Color(0xFF1E222B) : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: brtColor, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Obx(() => ListTile(
                      leading: const Icon(Icons.trip_origin, color: brtColor),
                      title: Text(controller.selectedStartStation?.localizedName ?? 'tap_select_start'.tr),
                      trailing: const Icon(Icons.arrow_drop_down, color: brtColor),
                      onTap: () => _pickStation(context, controller, true),
                    )),
                    const Divider(height: 1),
                    Obx(() => ListTile(
                      leading: const Icon(Icons.location_on, color: brtColor),
                      title: Text(controller.selectedEndStation?.localizedName ?? 'tap_select_end'.tr),
                      trailing: const Icon(Icons.arrow_drop_down, color: brtColor),
                      onTap: () => _pickStation(context, controller, false),
                    )),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: brtColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => controller.calculateTrip(),
                        icon: const Icon(Icons.alt_route_rounded, size: 20),
                        label: Text('calculate_trip'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final activeTrip = controller.activeTrip;
              if (activeTrip == null) return const SizedBox.shrink();

              final brtFare = FareCalculatorService.calculateBrtFare(
                activeTrip.stationCount,
                controller.passengerType.value,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2215) : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: brtColor, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'fastest_route'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: brtColor),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${activeTrip.stationCount} ${'stations'.tr} • ${activeTrip.estimatedTimeMinutes} ${'est_time'.tr}',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade300 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0 ${'transfers_count'.tr} • $brtFare ${'ticket'.tr}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: brtColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: brtColor, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.bookmark_add_outlined, color: brtColor),
                    label: Text(
                      'save_trip'.tr,
                      style: const TextStyle(color: brtColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => controller.saveActiveTrip(),
                  ),
                  const SizedBox(height: 16),
                  VerticalTimeline(trip: activeTrip, lineColor: brtColor),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}