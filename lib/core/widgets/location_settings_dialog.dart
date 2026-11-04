import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationSettingsDialog {
  const LocationSettingsDialog._();

  static Future<void> show({
    required String title,
    required String message,
    required Future<void> Function() onOpenSettings,
  }) async {
    final shouldOpen = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.location_off_rounded, size: 32),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text('open_settings'.tr),
          ),
        ],
      ),
    );

    if (shouldOpen == true) await onOpenSettings();
  }
}