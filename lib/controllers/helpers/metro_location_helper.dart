import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../services/location_service.dart';
import '../../utils/app_snackbar.dart';

class MetroLocationHelper {
  static Future<void> findNearest({
    required String filterType,
    required RxBool isLoading,
    required Function(String) onStationFound,
  }) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      AppSnackbar.warning(
        title: 'location_notice_title'.tr,
        message: 'location_notice_desc'.tr,
      );
      return;
    }

    isLoading.value = true;
    try {
      final pos = await LocationService.getCurrentPosition();
      if (pos != null) {
        final nearest = LocationService.findNearestStation(
          pos.latitude,
          pos.longitude,
          filterType: filterType,
        );
        onStationFound(nearest.name);
      }
    } catch (_) {
      AppSnackbar.error(
        title: 'no_internet_search_title'.tr,
        message: 'no_internet_search_desc'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> showPicker(Function(String) onSelectTransit) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      AppSnackbar.warning(
        title: 'location_notice_title'.tr,
        message: 'location_notice_desc'.tr,
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppSnackbar.error(
          title: 'location_permission_title'.tr,
          message: 'location_permission_denied'.tr,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppSnackbar.error(
        title: 'location_permission_title'.tr,
        message: 'location_permission_denied_forever'.tr,
      );
      return;
    }

    Get.bottomSheet(
      Material(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'select_transit_type'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'choose_transit_type_desc'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              _buildTile(
                Icons.subway_rounded,
                const Color(0xFF1F5F5B),
                'metro'.tr,
                () => onSelectTransit('metro'),
              ),
              const SizedBox(height: 10),
              _buildTile(
                Icons.train_rounded,
                const Color(0xFFFD5E5C),
                'monorail'.tr,
                () => onSelectTransit('monorail'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildTile(
    IconData icon,
    Color color,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.grey.withValues(alpha: 0.08),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
