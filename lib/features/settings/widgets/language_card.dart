import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/settings/controllers/settings_controller.dart';
import 'package:metro/features/settings/widgets/settings_section.dart';

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(label),
        trailing: Icon(
          selected
              ? Icons.radio_button_checked_rounded
              : Icons.radio_button_unchecked_rounded,
          color: selected ? context.brand : context.mutedColor,
        ),
        onTap: () => controller.changeLanguage(code),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return SettingsSection(
      icon: Icons.language_rounded,
      title: 'language_title'.tr,
      children: [
        _option(controller, context, code: 'ar', label: 'arabic'.tr),
        _option(controller, context, code: 'en', label: 'english'.tr),
      ],
    );
  }
}
