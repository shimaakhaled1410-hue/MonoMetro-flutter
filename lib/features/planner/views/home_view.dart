import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/core/widgets/outlined_action_button.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/views/metro_map_view.dart';
import 'package:metro/features/planner/widgets/calculate_trip_button.dart';
import 'package:metro/features/planner/widgets/landmarks_dialog.dart';
import 'package:metro/features/planner/widgets/passenger_badge_card.dart';
import 'package:metro/features/planner/widgets/station_picker_sheet.dart';
import 'package:metro/features/planner/widgets/station_selector_card.dart';
import 'package:metro/features/planner/widgets/swap_stations_button.dart';
import 'package:metro/features/planner/widgets/transit_type_sheet.dart';
import 'package:metro/features/planner/widgets/trip_results_section.dart';
import 'package:metro/models/transit_network.dart';
import 'package:metro/models/transit_mode.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MetroController.of(TransitNetwork.rail);
    final primary = context.brand;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_subway, color: primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'app_title'.tr,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'metro_map'.tr,
            icon: const Icon(Icons.map_rounded),
            onPressed: () => Get.to(() => const MetroMapView()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PassengerBadgeCard(),
            const SizedBox(height: 12),
            StationSelectorCard(
              icon: Icons.trip_origin,
              iconColor: AppColors.startMarker,
              titleKey: 'starting_point',
              placeholderKey: 'tap_select_start',
              stationOf: () => controller.startStation.value,
              onTap: () => StationPickerSheet.show(
                context,
                title: 'select_dep_station'.tr,
                network: TransitNetwork.rail,
                onSelected: controller.selectStartStation,
              ),
              headerAction: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.map_outlined, color: primary, size: 22),
                onPressed: controller.openStartStationMap,
              ),
              bottomAction: OutlinedActionButton(
                icon: Icons.my_location,
                label: Obx(
                  () => controller.isLoadingLocation.value
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'use_nearest_me'.tr,
                          style: TextStyle(color: primary),
                        ),
                ),
                onPressed: () => TransitTypeSheet.show(
                  context,
                  modes: const [TransitMode.metro, TransitMode.monorail],
                  onSelected: controller.useNearestStation,
                ),
              ),
            ),
            SwapStationsButton(onTap: controller.swapStations),
            StationSelectorCard(
              icon: Icons.location_on,
              iconColor: AppColors.endMarker,
              titleKey: 'destination',
              placeholderKey: 'tap_select_end',
              stationOf: () => controller.endStation.value,
              onTap: () => StationPickerSheet.show(
                context,
                title: 'select_dest_station'.tr,
                network: TransitNetwork.rail,
                onSelected: controller.selectEndStation,
              ),
              bottomAction: OutlinedActionButton(
                icon: Icons.explore_rounded,
                label: Text('landmarks'.tr, style: TextStyle(color: primary)),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => LandmarksDialog(
                    onSelect: (station, title) =>
                        controller.selectEndStation(station, tag: title),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CalculateTripButton(onPressed: controller.calculateTrip),
            const SizedBox(height: 16),
            TripResultsSection(controller: controller),
          ],
        ),
      ),
    );
  }
}
