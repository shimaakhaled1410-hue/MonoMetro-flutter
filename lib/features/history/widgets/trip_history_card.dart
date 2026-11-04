import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/fare_formatter.dart';
import 'package:metro/core/utils/format_date.dart';
import 'package:metro/core/utils/format_time.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/history/widgets/trip_history_labels.dart';
import 'package:metro/models/trip_history.dart';

/// Saved trip in the history list. Tap to open details, swipe to delete.
class TripHistoryCard extends StatelessWidget {
  const TripHistoryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final TripHistory item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final badgeColor = palette.passengerColor(item.passengerType);
    final fare = FareFormatter.format(item.fare);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey('dismiss_${item.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: 24),
          decoration: BoxDecoration(
            color: palette.danger.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.delete_outline_rounded, color: palette.danger),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatClock(item.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: item.startLabel),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 16,
                                    color: palette.muted,
                                  ),
                                ),
                              ),
                              TextSpan(text: item.endLabel),
                            ],
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: palette.text,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: palette.muted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Pill(
                        text: item.passengerType.labelKey.tr,
                        background: badgeColor.withValues(
                          alpha: context.isDark ? 0.22 : 0.12,
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
                      if (fare != null)
                        _Pill(
                          text: fare,
                          background: palette.field,
                          foreground: palette.text,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
