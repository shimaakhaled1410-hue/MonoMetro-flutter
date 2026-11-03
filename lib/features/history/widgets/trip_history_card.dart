import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/fare_formatter.dart';
import 'package:metro/core/utils/format_time.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/trip_history.dart';
import 'package:metro/services/station_repository.dart';

class TripHistoryCard extends StatelessWidget {
  const TripHistoryCard({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final TripHistory item;
  final VoidCallback onDelete;

  String _stationName(String name) {
    return StationRepository.byName(name)?.localizedName ?? name;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final start = _stationName(item.startStation);
    final tag = item.destinationTag;
    final end = (tag != null && tag.isNotEmpty)
        ? '$tag (${_stationName(item.endStation)})'
        : _stationName(item.endStation);
    final palette = context.palette;
    final badgeColor = palette.passengerColor(item.passengerType);
    final routeNames = item.routeStations.map(_stationName).toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.route, color: palette.brand),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: start),
                        const WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              // matchTextDirection: true,
                            ),
                          ),
                        ),
                        TextSpan(text: end),
                      ],
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: badgeColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    item.passengerType.labelKey.tr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: palette.danger),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              [
                '${item.stationCount} ${'stations'.tr}',
                formatTripDuration(item.timeInMinutes),
                ?FareFormatter.format(item.fare),
              ].join(' • '),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: routeNames.length,
                separatorBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: palette.muted,
                    // matchTextDirection: true,
                  ),
                ),
                itemBuilder: (_, index) => Center(
                  child: Chip(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    label: Text(
                      routeNames[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: palette.field,
                    side: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
