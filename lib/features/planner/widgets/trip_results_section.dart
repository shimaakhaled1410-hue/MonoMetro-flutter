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
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: context.onSurfaceStrong,
            ),
          ),
          const SizedBox(height: 12),
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
                  const SizedBox(width: 12),
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
          FilledButton.tonalIcon(
            style: FilledButton.styleFrom(
              backgroundColor: context.fieldColor,
              foregroundColor: context.onSurfaceStrong,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.bookmark_add_outlined),
            label: Text(
              'save_trip'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
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
