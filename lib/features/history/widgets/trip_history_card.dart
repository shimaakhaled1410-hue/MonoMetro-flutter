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
        padding: const EdgeInsets.fromLTRB(18, 16, 8, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: start),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: palette.muted,
                            ),
                          ),
                        ),
                        TextSpan(text: end),
                      ],
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: palette.muted),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(
                    text: item.passengerType.labelKey.tr,
                    background: badgeColor.withValues(
                      alpha: isDark ? 0.22 : 0.12,
                    ),
                    foreground: badgeColor,
                  ),
                  _Pill(
                    text: '${item.stationCount} ${'stations'.tr}',
                    background: palette.field,
                    foreground: palette.text,
                  ),
                  _Pill(
                    text: formatTripDuration(item.timeInMinutes),
                    background: palette.field,
                    foreground: palette.text,
                  ),
                  if (FareFormatter.format(item.fare) case final fare?)
                    _Pill(
                      text: fare,
                      background: palette.field,
                      foreground: palette.text,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.only(end: 10),
                itemCount: routeNames.length,
                separatorBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: palette.muted,
                  ),
                ),
                itemBuilder: (_, index) => Center(
                  child: Text(
                    routeNames[index],
                    style: TextStyle(fontSize: 12, color: palette.muted),
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

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
