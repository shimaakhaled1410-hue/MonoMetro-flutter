import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/widgets/calculate_trip_button.dart';
import 'package:metro/features/planner/widgets/station_picker_sheet.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';

class BrtPlannerCard extends StatelessWidget {
  const BrtPlannerCard({super.key, required this.controller});

  final MetroController controller;

  void _pick(BuildContext context, {required bool isStart}) {
    StationPickerSheet.show(
      context,
      title: isStart ? 'select_dep_station'.tr : 'select_dest_station'.tr,
      initialLine: TransitLine.brtRing,
      onSelected: (station) => isStart
          ? controller.selectStartStation(station)
          : controller.selectEndStation(station),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Station? Function() stationOf,
    required String placeholderKey,
    required bool isStart,
  }) {
    return Obx(() {
      final station = stationOf();
      return ListTile(
        leading: Icon(icon, color: color),
        title: Text(station?.localizedName ?? placeholderKey.tr),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: () => _pick(context, isStart: isStart),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _tile(
              context,
              icon: Icons.trip_origin,
              color: AppColors.startMarker,
              stationOf: () => controller.startStation.value,
              placeholderKey: 'tap_select_start',
              isStart: true,
            ),
            const Divider(height: 1),
            _tile(
              context,
              icon: Icons.location_on,
              color: AppColors.endMarker,
              stationOf: () => controller.endStation.value,
              placeholderKey: 'tap_select_end',
              isStart: false,
            ),
            const SizedBox(height: 10),
            CalculateTripButton(onPressed: controller.calculateTrip),
          ],
        ),
      ),
    );
  }
}
