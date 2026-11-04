import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_segment_line.dart';
import 'package:metro/models/station.dart';

/// One card holding both ends of the trip, joined by a connector, with a
/// swap button on the trailing side.
class TripPlannerCard extends StatelessWidget {
  const TripPlannerCard({
    super.key,
    required this.startOf,
    required this.endOf,
    required this.onStartTap,
    required this.onEndTap,
    this.onSwap,
    this.onStartMapTap,
  });

  final Station? Function() startOf;
  final Station? Function() endOf;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final VoidCallback? onSwap;
  final VoidCallback? onStartMapTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    const radius = BorderRadius.all(Radius.circular(24));

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: palette.shadow.withValues(
              alpha: context.isDark ? 0.35 : 0.06,
            ),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(width: 18),
              _Connector(
                start: palette.startMarker,
                end: palette.endMarker,
                line: palette.borderStrong,
                surface: palette.surface,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  children: [
                    _StationRow(
                      captionKey: 'starting_point',
                      placeholderKey: 'tap_select_start',
                      stationOf: startOf,
                      onTap: onStartTap,
                      trailing: onStartMapTap == null
                          ? null
                          : IconButton(
                              tooltip: 'starting_point'.tr,
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                Icons.map_outlined,
                                size: 20,
                                color: palette.muted,
                              ),
                              onPressed: onStartMapTap,
                            ),
                    ),
                    Divider(height: 1, color: palette.border),
                    _StationRow(
                      captionKey: 'destination',
                      placeholderKey: 'tap_select_end',
                      stationOf: endOf,
                      onTap: onEndTap,
                    ),
                  ],
                ),
              ),
              if (onSwap != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: IconButton(
                      tooltip: 'swap_stations'.tr,
                      style: IconButton.styleFrom(
                        backgroundColor: palette.field,
                        foregroundColor: palette.text,
                      ),
                      icon: const Icon(Icons.swap_vert_rounded),
                      onPressed: onSwap,
                    ),
                  ),
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector({
    required this.start,
    required this.end,
    required this.line,
    required this.surface,
  });

  final Color start;
  final Color end;
  final Color line;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: TimelineSegmentLine(color: line, dotted: true),
                ),
                const Spacer(),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.5),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: surface,
                shape: BoxShape.circle,
                border: Border.all(color: start, width: 3.5),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.5),
            child: Icon(Icons.location_on_rounded, color: end, size: 26),
          ),
        ],
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  const _StationRow({
    required this.captionKey,
    required this.placeholderKey,
    required this.stationOf,
    required this.onTap,
    this.trailing,
  });

  final Widget? trailing;
  final String captionKey;
  final String placeholderKey;
  final Station? Function() stationOf;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(child: _label(context)),
            ?trailing,
          ],
        ),
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          captionKey.tr,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: context.mutedColor,
          ),
        ),
        const SizedBox(height: 3),
        Obx(() {
          final station = stationOf();
          return Text(
            station == null ? placeholderKey.tr : station.localizedName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: station == null
                  ? context.mutedColor
                  : context.onSurfaceStrong,
            ),
          );
        }),
      ],
    );
  }
}
