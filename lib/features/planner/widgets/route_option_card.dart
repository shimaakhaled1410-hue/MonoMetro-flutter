import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/core/utils/fare_formatter.dart';
import 'package:metro/core/utils/format_time.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/trip_result.dart';

class RouteOptionCard extends StatelessWidget {
  const RouteOptionCard({
    super.key,
    required this.title,
    required this.trip,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final TripResult trip;
  final bool isSelected;
  final VoidCallback onTap;

  String? _details() {
    final parts = <String>[
      if (trip.transferCount > 0)
        '${trip.transferCount} ${'transfers_count'.tr}',
      ?FareFormatter.format(trip.fare),
    ];
    return parts.isEmpty ? null : parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final details = _details();
    final isDark = context.isDark;
    final primary = context.brand;

    final background = isSelected
        ? (isDark ? AppColors.selectedRouteDark : AppColors.selectedRouteLight)
        : context.surfaceColor;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? primary : context.borderColor,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isSelected ? Colors.white : primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${trip.stationCount} ${'stations'.tr} • ${formatTripDuration(trip.estimatedTimeMinutes)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : context.mutedColor,
                ),
              ),
              if (details != null) ...[
                const SizedBox(height: 4),
                Text(
                  details,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isSelected ? Colors.white : context.onSurfaceStrong,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
