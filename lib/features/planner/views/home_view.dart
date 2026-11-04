import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/core/widgets/quick_action_chip.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/views/metro_map_view.dart';
import 'package:metro/features/planner/widgets/calculate_trip_button.dart';
import 'package:metro/features/planner/widgets/landmarks_sheet.dart';
import 'package:metro/features/planner/widgets/passenger_badge_card.dart';
import 'package:metro/features/planner/widgets/station_picker_sheet.dart';
import 'package:metro/features/planner/widgets/transit_type_sheet.dart';
import 'package:metro/features/planner/widgets/trip_planner_card.dart';
import 'package:metro/features/planner/widgets/trip_results_section.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/transit_network.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MetroController.of(TransitNetwork.rail);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'metro_map'.tr,
            style: IconButton.styleFrom(
              backgroundColor: context.fieldColor,
              foregroundColor: context.onSurfaceStrong,
            ),
            icon: const Icon(Icons.map_rounded),
            onPressed: () => Get.to(() => const MetroMapView()),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PassengerBadgeCard(),
            const SizedBox(height: 16),
            TripPlannerCard(
              startOf: () => controller.startStation.value,
              endOf: () => controller.endStation.value,
              onSwap: controller.swapStations,
              onStartMapTap: controller.openStartStationMap,
              onStartTap: () => StationPickerSheet.show(
                context,
                title: 'select_dep_station'.tr,
                network: TransitNetwork.rail,
                onSelected: controller.selectStartStation,
              ),
              onEndTap: () => StationPickerSheet.show(
                context,
                title: 'select_dest_station'.tr,
                network: TransitNetwork.rail,
                onSelected: controller.selectEndStation,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  QuickActionChip(
                    icon: Icons.my_location_rounded,
                    label: Obx(
                      () => controller.isLoadingLocation.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('use_nearest_me'.tr),
                    ),
                    onPressed: () => TransitTypeSheet.show(
                      context,
                      modes: const [TransitMode.metro, TransitMode.monorail],
                      onSelected: controller.useNearestStation,
                    ),
                  ),
                  const SizedBox(width: 8),
                  QuickActionChip(
                    icon: Icons.explore_rounded,
                    label: Text('landmarks'.tr),
                    onPressed: () => LandmarksSheet.show(
                      context,
                      onSelect: (station, title) =>
                          controller.selectEndStation(station, tag: title),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CalculateTripButton(onPressed: controller.calculateTrip),
            const SizedBox(height: 24),
            TripResultsSection(controller: controller),
          ],
        ),
      ),
    );
  }
}
