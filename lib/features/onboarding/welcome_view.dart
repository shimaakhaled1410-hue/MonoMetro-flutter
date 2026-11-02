import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/navigation/main_navigation_view.dart';
import 'package:metro/features/onboarding/widgets/passenger_category_tile.dart';
import 'package:metro/features/planner/controllers/metro_controller.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/services/settings_service.dart';

class _Category {
  const _Category(this.type, this.titleKey, this.descriptionKey, this.icon);

  final PassengerType type;
  final String titleKey;
  final String descriptionKey;
  final IconData icon;
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key, this.isInitialSetup = true});

  final bool isInitialSetup;

  static const List<_Category> _categories = [
    _Category(
      PassengerType.normal,
      'normal_passenger',
      'normal_desc',
      Icons.person_outline_rounded,
    ),
    _Category(
      PassengerType.senior,
      'senior_passenger',
      'senior_desc',
      Icons.elderly_rounded,
    ),
    _Category(
      PassengerType.specialNeeds,
      'special_needs',
      'special_desc',
      Icons.accessible_forward_rounded,
    ),
  ];

  Future<void> _onContinue() async {
    await Get.find<SettingsService>().markOnboardingDone();
    if (isInitialSetup) {
      Get.offAll(
        () => const MainNavigationView(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MetroController>();
    final primary = context.brand;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_subway_rounded,
                    size: 40,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'welcome_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'welcome_subtitle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: context.mutedColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Obx(
                  () => ListView.separated(
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final category = _categories[index];
                      return PassengerCategoryTile(
                        title: category.titleKey.tr,
                        subtitle: category.descriptionKey.tr,
                        icon: category.icon,
                        isSelected:
                            controller.passengerType.value == category.type,
                        onTap: () => controller.setPassengerType(category.type),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: context.isDark ? Colors.black87 : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _onContinue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'get_started'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      // matchTextDirection: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
