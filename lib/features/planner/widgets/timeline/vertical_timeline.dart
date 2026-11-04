import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_entry.dart';
import 'package:metro/features/planner/widgets/timeline/timeline_station_row.dart';
import 'package:metro/models/trip_result.dart';

class VerticalTimeline extends StatelessWidget {
  const VerticalTimeline({super.key, required this.trip});

  final TripResult trip;

  @override
  Widget build(BuildContext context) {
    final entries = TimelineEntry.build(trip);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
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
            const SizedBox(height: 14),
            for (final entry in entries) TimelineStationRow(entry: entry),
          ],
        ),
      ),
    );
  }
}
