import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/legal_texts.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/settings/widgets/settings_section.dart';

class LegalCard extends StatelessWidget {
  const LegalCard({super.key});

  void _showLegalDialog(BuildContext context, String title, String content) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.policy_outlined, color: dialogContext.brand),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'close'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String titleKey,
    required String Function(String languageCode) contentOf,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon),
      title: Text(titleKey.tr),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: context.mutedColor,
        // matchTextDirection: true,
      ),
      onTap: () => _showLegalDialog(
        context,
        titleKey.tr,
        contentOf(Get.locale?.languageCode ?? 'en'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      icon: Icons.security_rounded,
      title: 'legal_title'.tr,
      children: [
        _item(
          context,
          icon: Icons.privacy_tip_outlined,
          titleKey: 'privacy_policy',
          contentOf: LegalTexts.getPrivacyPolicy,
        ),
        _item(
          context,
          icon: Icons.description_outlined,
          titleKey: 'terms_conditions',
          contentOf: LegalTexts.getTermsConditions,
        ),
      ],
    );
  }
}
