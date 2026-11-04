import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_entry.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_segment_line.dart';

class TimelineStationRow extends StatelessWidget {
  const TimelineStationRow({super.key, required this.entry});

  final TimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isEdge = entry.isFirst || entry.isLast;
    final isInterchange = entry.isInterchange;
    final nodeColor = isInterchange
        ? palette.interchange
        : entry.isFirst
            ? palette.startMarker
            : entry.isLast
                ? palette.endMarker
                : palette.timeline;
    final nodeFill = (isInterchange || isEdge) ? nodeColor : context.surfaceColor;
    final nodeRing = isInterchange ? palette.interchangeRing : nodeColor;

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
                    child: TimelineSegmentLine(
                      color: (entry.outgoing?.colorOf(palette) ??
                              palette.timeline)
                          .withValues(alpha: 0.7),
                      dotted: entry.outgoing?.isWalk ?? false,
                    ),
                  ),
                if (!entry.isFirst)
                  Positioned(
                    top: 0,
                    bottom: 14,
                    child: TimelineSegmentLine(
                      color: (entry.incoming?.colorOf(palette) ??
                              palette.timeline)
                          .withValues(alpha: 0.7),
                      dotted: entry.incoming?.isWalk ?? false,
                    ),
                  ),
                Container(
                  width: isInterchange ? 18 : 14,
                  height: isInterchange ? 18 : 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nodeFill,
                    border: Border.all(
                      color: nodeRing,
                      width: isInterchange ? 2 : 3,
                    ),
                  ),
                  child: isInterchange
                      ? Icon(
                          Icons.sync_alt,
                          size: 10,
                          color: palette.onInterchange,
                        )
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
                            color: context.onSurfaceStrong,
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
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.walk,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.fieldColor,
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.brand,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.transfer_within_a_station,
            color: context.palette.onBrand,
            size: 13,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: context.palette.onBrand,
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
