import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/features/brt/widgets/brt_planner_card.dart';
import 'package:metro/features/brt/widgets/brt_station_tile.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/widgets/trip_results_section.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/services/station_repository.dart';

class BrtView extends StatelessWidget {
  const BrtView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MetroController>();
    final stations = StationRepository.forLine(TransitLine.brtRing);

    return Scaffold(
      appBar: AppBar(title: Text('nav_brt'.tr)),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BrtPlannerCard(controller: controller),
                  const SizedBox(height: 16),
                  const TripResultsSection(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) => BrtStationTile(
                station: stations[index],
                number: index + 1,
                onOpenMap: () => controller.openStationOnMap(stations[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
