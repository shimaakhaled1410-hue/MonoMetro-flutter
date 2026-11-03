import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/features/planner/widgets/route_option_card.dart';
import 'package:metro/features/planner/widgets/timeline/vertical_timeline.dart';

class TripResultsSection extends StatelessWidget {
  const TripResultsSection({super.key, required this.controller});

  final MetroController controller;

  @override
  Widget build(BuildContext context) {
    final primary = context.brand;

    return Obx(() {
      final fastest = controller.fastestTrip.value;
      final comfortable = controller.comfortableTrip.value;
      final active = controller.activeTrip;

      if (fastest == null || comfortable == null || active == null) {
        return const SizedBox.shrink();
      }

      final hasDistinctOptions = controller.hasDistinctOptions;
      final selectedIndex = controller.selectedRouteIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            hasDistinctOptions ? 'route_options'.tr : 'transit_directions'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          if (hasDistinctOptions)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RouteOptionCard(
                      title: 'fastest_route'.tr,
                      trip: fastest,
                      isSelected: selectedIndex == 0,
                      onTap: () => controller.selectRouteOption(0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RouteOptionCard(
                      title: 'fewest_transfers'.tr,
                      trip: comfortable,
                      isSelected: selectedIndex == 1,
                      onTap: () => controller.selectRouteOption(1),
                    ),
                  ),
                ],
              ),
            )
          else
            RouteOptionCard(
              title: 'fastest_route'.tr,
              trip: fastest,
              isSelected: true,
              onTap: () {},
            ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(Icons.bookmark_add_outlined, color: primary),
            label: Text(
              'save_trip'.tr,
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            onPressed: controller.saveActiveTrip,
          ),
          const SizedBox(height: 16),
          VerticalTimeline(trip: active),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
