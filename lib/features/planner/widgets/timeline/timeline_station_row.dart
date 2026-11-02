import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_entry.dart';

class TimelineStationRow extends StatelessWidget {
  const TimelineStationRow({super.key, required this.entry});

  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isEdge = entry.isFirst || entry.isLast;
    final isInterchange = entry.isInterchange;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!entry.isLast)
                  Positioned(
                    top: 14,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      color: entry.outgoingColor.withValues(alpha: 0.7),
                    ),
                  ),
                if (!entry.isFirst)
                  Positioned(
                    top: 0,
                    bottom: 14,
                    child: Container(
                      width: 3,
                      color: entry.incomingColor.withValues(alpha: 0.7),
                    ),
                  ),
                Container(
                  width: isInterchange ? 18 : 14,
                  height: isInterchange ? 18 : 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isInterchange
                        ? Colors.amber.shade700
                        : (isEdge ? AppColors.timeline : context.surfaceColor),
                    border: Border.all(
                      color: isInterchange
                          ? Colors.amber.shade300
                          : AppColors.timeline,
                      width: isInterchange ? 2 : 3,
                    ),
                  ),
                  child: isInterchange
                      ? const Icon(Icons.sync_alt, size: 10, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.station.localizedName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 15,
                            fontWeight: (isEdge || isInterchange)
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isEdge)
                        _EdgeBadge(
                          label: entry.isFirst ? 'start'.tr : 'end'.tr,
                        ),
                    ],
                  ),
                  if (entry.transferTo != null) ...[
                    const SizedBox(height: 6),
                    _TransferBadge(
                      label: '${'transfer'.tr} ${entry.transferTo!.labelKey.tr}',
                    ),
                  ],
                  if (entry.walkNoteKey != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      entry.walkNoteKey!.trParams({
                        'minutes': entry.walkMinutes.toString(),
                      }),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.walk,
                      ),
                    ),
                  ],
                  if (entry.towards != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      '${'take_line_towards'.tr} ${entry.towards!.localizedName}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.brand,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EdgeBadge extends StatelessWidget {
  const _EdgeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.borderDark : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TransferBadge extends StatelessWidget {
  const _TransferBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.timeline,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.transfer_within_a_station, color: Colors.white, size: 13),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
