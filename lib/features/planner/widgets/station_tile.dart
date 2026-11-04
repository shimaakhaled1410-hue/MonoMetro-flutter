import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/station.dart';

class StationTile extends StatelessWidget {
  const StationTile({
    super.key,
    required this.station,
    required this.onTap,
    this.showLines = false,
  });

  final Station station;
  final VoidCallback onTap;
  final bool showLines;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: context.fieldColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 30,
              decoration: BoxDecoration(
                color: context.lineColor(station.primaryLine),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.localizedName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: context.onSurfaceStrong,
                    ),
                  ),
                  if (showLines) ...[
                    const SizedBox(height: 2),
                    Text(
                      station.lines.map((line) => line.labelKey.tr).join(' | '),
                      style: TextStyle(fontSize: 11, color: context.mutedColor),
                    ),
                  ],
                ],
              ),
            ),
            if (station.isInterchange)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.brand.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'transfer'.tr,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.brand,
                  ),
                ),
              ),
            const SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: context.mutedColor,
              // matchTextDirection: true,
            ),
          ],
        ),
      ),
    );
  }
}
