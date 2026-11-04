import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/widgets/calculate_trip_button.dart';
import 'package:metro/features/planner/widgets/station_picker_sheet.dart';
import 'package:metro/features/planner/widgets/trip_planner_card.dart';
import 'package:metro/models/transit_network.dart';

class BrtPlannerCard extends StatelessWidget {
  const BrtPlannerCard({super.key, required this.controller});

  final MetroController controller;

  void _pick(BuildContext context, {required bool isStart}) {
    StationPickerSheet.show(
      context,
      title: isStart ? 'select_dep_station'.tr : 'select_dest_station'.tr,
      network: TransitNetwork.brt,
      onSelected: (station) => isStart
          ? controller.selectStartStation(station)
          : controller.selectEndStation(station),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TripPlannerCard(
          startOf: () => controller.startStation.value,
          endOf: () => controller.endStation.value,
          onSwap: controller.swapStations,
          onStartTap: () => _pick(context, isStart: true),
          onEndTap: () => _pick(context, isStart: false),
        ),
        const SizedBox(height: 20),
        CalculateTripButton(onPressed: controller.calculateTrip),
      ],
    );
  }
}
