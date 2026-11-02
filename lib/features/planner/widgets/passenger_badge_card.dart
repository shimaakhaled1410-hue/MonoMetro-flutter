import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/onboarding/welcome_view.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';

class PassengerBadgeCard extends StatelessWidget {
  const PassengerBadgeCard({super.key, required this.controller});

  final MetroController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.badge_outlined, color: context.brand, size: 20),
            const SizedBox(width: 8),
            Text(
              'passenger_type'.tr,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Obx(
              () => InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () =>
                    Get.to(() => const WelcomeView(isInitialSetup: false)),
                child: Chip(
                  label: Text(
                    controller.passengerType.value.labelKey.tr,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: context.fieldColor,
                  side: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
