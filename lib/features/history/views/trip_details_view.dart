import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/fare_formatter.dart';
import 'package:metro/core/utils/format_date.dart';
import 'package:metro/core/utils/format_time.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/features/history/widgets/trip_history_labels.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_segment_line.dart';
import 'package:metro/features/planner/widgets/timeline/vertical_timeline.dart';
import 'package:metro/models/trip_history.dart';
import 'package:metro/services/metro_graph_service.dart';
import 'package:metro/services/station_repository.dart';

/// Full view of a saved trip: summary, stats and the stop-by-stop timeline.
class TripDetailsView extends StatelessWidget {
  const TripDetailsView({super.key, required this.item});

  final TripHistory item;

  /// Pops the screen and deletes in the same synchronous step. The second
  /// tap of a double tap finds the trip already gone and does nothing, so the
  /// screen can't be popped twice. The undo snackbar then shows on the list.
  void _delete(BuildContext context) {
    final controller = Get.find<HistoryController>();
    final exists = controller.historyList.any((trip) => trip.id == item.id);
    if (!exists) return;

    Navigator.of(context).pop();
    controller.deleteItemWithUndo(item);
  }

  @override
  Widget build(BuildContext context) {
    final trip = Get.find<MetroGraphService>().rebuildTrip(
      item.routeStations,
      item.passengerType,
    );
    final fare = FareFormatter.format(item.fare);

    final stats = <_StatData>[
      _StatData(
        Icons.schedule_rounded,
        formatTripDuration(item.timeInMinutes),
      ),
      _StatData(
        Icons.linear_scale_rounded,
        '${item.stationCount} ${'stations'.tr}',
      ),
      if (trip != null && trip.transferCount > 0)
        _StatData(
          Icons.swap_horiz_rounded,
          '${trip.transferCount} ${'transfers_count'.tr}',
        ),
      ?(fare == null ? null : _StatData(Icons.payments_outlined, fare)),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('trip_details'.tr)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _RouteHeader(item: item),
          const SizedBox(height: 12),
          _StatsGrid(stats: stats),
          const SizedBox(height: 16),
          if (trip != null)
            VerticalTimeline(trip: trip)
          else
            _StopsFallback(names: item.routeStations),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: context.palette.danger,
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: Text('delete'.tr),
              onPressed: () => _delete(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteHeader extends StatelessWidget {
  const _RouteHeader({required this.item});

  final TripHistory item;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final badgeColor = palette.passengerColor(item.passengerType);
    const rowHeight = 28.0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event_rounded, size: 16, color: palette.muted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${dayLabel(item.timestamp)} · ${formatClock(item.timestamp)}',
                    style: TextStyle(fontSize: 12, color: palette.muted),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(
                      alpha: context.isDark ? 0.22 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.passengerType.labelKey.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        SizedBox(
                          height: rowHeight,
                          child: Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: palette.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: palette.startMarker,
                                  width: 3.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: TimelineSegmentLine(
                              color: palette.borderStrong,
                              dotted: true,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: rowHeight,
                          child: Center(
                            child: Icon(
                              Icons.location_on_rounded,
                              size: 26,
                              color: palette.endMarker,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _NameRow(height: rowHeight, text: item.startLabel),
                        const SizedBox(height: 24),
                        _NameRow(height: rowHeight, text: item.endLabel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  const _NameRow({required this.height, required this.text});

  final double height;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: context.onSurfaceStrong,
          ),
        ),
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.value);

  final IconData icon;
  final String value;
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final List<_StatData> stats;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < stats.length; i += 2) {
      final second = i + 1 < stats.length ? stats[i + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _StatTile(data: stats[i])),
                const SizedBox(width: 12),
                Expanded(
                  child: second == null
                      ? const SizedBox.shrink()
                      : _StatTile(data: second),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.fieldColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, size: 20, color: context.brand),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data.value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.onSurfaceStrong,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plain list of stops, used when the saved path can no longer be matched to
/// the network (for example after station data changed).
class _StopsFallback extends StatelessWidget {
  const _StopsFallback({required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'stations_timeline'.tr,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: context.onSurfaceStrong,
              ),
            ),
            const SizedBox(height: 12),
            for (final name in names)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.palette.timeline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        StationRepository.byName(name)?.localizedName ?? name,
                        style: TextStyle(
                          fontSize: 15,
                          color: context.onSurfaceStrong,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
