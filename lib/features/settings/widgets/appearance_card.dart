import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';
import 'package:metro/features/settings/widgets/settings_section.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return SettingsSection(
      icon: Icons.palette_outlined,
      title: 'appearance'.tr,
      children: [
        Obx(
          () => SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text('dark_mode'.tr),
            value: controller.isDarkMode.value,
            onChanged: (_) => controller.toggleDarkMode(),
            secondary: Icon(
              controller.isDarkMode.value
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
