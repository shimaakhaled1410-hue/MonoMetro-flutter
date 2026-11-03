import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  Widget _option(
    SettingsController controller,
    BuildContext context, {
    required String code,
    required String label,
  }) {
    return Obx(() {
      final selected = controller.languageCode.value == code;
      return ListTile(
        title: Text(label),
        trailing: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: selected ? context.brand : context.mutedColor,
        ),
        onTap: () => controller.changeLanguage(code),
      );
    });
  }

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
                Icon(Icons.language_rounded, color: context.brand),
                const SizedBox(width: 10),
                Text(
                  'language_title'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _option(controller, context, code: 'ar', label: 'arabic'.tr),
            _option(controller, context, code: 'en', label: 'english'.tr),
          ],
        ),
      ),
    );
  }
}
