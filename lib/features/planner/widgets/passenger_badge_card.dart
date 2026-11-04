import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/onboarding/welcome_view.dart';
import 'package:metro/features/planner/controllers/passenger_controller.dart';

/// Small pill showing the active passenger type; tapping it changes it.
class PassengerBadgeCard extends StatelessWidget {
  const PassengerBadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PassengerController>();
    const shape = StadiumBorder();

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Obx(
        () => Material(
          color: context.fieldColor,
          shape: shape,
          child: InkWell(
            customBorder: shape,
            onTap: () => Get.to(() => const WelcomeView(isInitialSetup: false)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.badge_outlined, size: 16, color: context.brand),
                  const SizedBox(width: 8),
                  Text(
                    '${'passenger_type'.tr}:',
                    style: TextStyle(fontSize: 12, color: context.mutedColor),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    controller.type.value.labelKey.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: context.onSurfaceStrong,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: context.mutedColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
