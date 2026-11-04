import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final palette = context.palette;
    final radius = BorderRadius.circular(22);

    final titleColor =
        isSelected ? palette.onSelectedRouteMuted : context.mutedColor;
    final mainColor =
        isSelected ? palette.onSelectedRoute : context.onSurfaceStrong;
    final subColor =
        isSelected ? palette.onSelectedRouteMuted : context.mutedColor;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? palette.selectedRoute : context.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(
            color: isSelected ? palette.selectedRoute : context.borderColor,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: titleColor,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: palette.onSelectedRoute,
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  formatTripDuration(trip.estimatedTimeMinutes),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                    height: 1.1,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${trip.stationCount} ${'stations'.tr}',
                  style: TextStyle(fontSize: 12, color: subColor),
                ),
                if (details != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: mainColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
