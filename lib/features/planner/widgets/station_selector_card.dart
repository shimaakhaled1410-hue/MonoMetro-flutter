import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/station.dart';

class StationSelectorCard extends StatelessWidget {
  const StationSelectorCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.titleKey,
    required this.placeholderKey,
    required this.stationOf,
    required this.onTap,
    required this.bottomAction,
    this.headerAction,
  });

  final IconData icon;
  final Color iconColor;
  final String titleKey;
  final String placeholderKey;
  final Station? Function() stationOf;
  final VoidCallback onTap;
  final Widget bottomAction;
  final Widget? headerAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titleKey.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.mutedColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ?headerAction,
              ],
            ),
            const SizedBox(height: 6),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.fieldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        final station = stationOf();
                        return Text(
                          station == null
                              ? placeholderKey.tr
                              : station.localizedName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: station == null
                                ? FontWeight.normal
                                : FontWeight.bold,
                            color: station == null
                                ? context.mutedColor
                                : context.onSurfaceStrong,
                          ),
                        );
                      }),
                    ),
                    Icon(Icons.arrow_drop_down, color: context.brand),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            bottomAction,
          ],
        ),
      ),
    );
  }
}
