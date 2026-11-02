import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';

class AppearanceCard extends StatelessWidget {
  const AppearanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette_outlined, color: context.brand),
                const SizedBox(width: 10),
                Text(
                  'appearance'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Obx(
              () => SwitchListTile(
                title: Text('dark_mode'.tr),
                value: controller.isDarkMode.value,
                onChanged: (_) => controller.toggleDarkMode(),
                secondary: Icon(
                  controller.isDarkMode.value
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
