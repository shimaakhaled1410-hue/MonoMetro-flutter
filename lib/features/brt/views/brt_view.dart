import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/features/brt/widgets/brt_planner_card.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/widgets/trip_results_section.dart';
import 'package:metro/models/transit_network.dart';

class BrtView extends StatelessWidget {
  const BrtView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MetroController.of(TransitNetwork.brt);

    return Scaffold(
      appBar: AppBar(title: Text('nav_brt'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BrtPlannerCard(controller: controller),
            const SizedBox(height: 16),
            TripResultsSection(controller: controller),
          ],
        ),
      ),
    );
  }
}
