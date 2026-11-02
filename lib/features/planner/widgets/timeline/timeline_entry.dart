import 'package:flutter/material.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/trip_result.dart';

class TimelineEntry {
  TimelineEntry(this.station);

  final Station station;
  bool isFirst = false;
  bool isLast = false;
  TransitLine? transferTo;
  Station? towards;
  String? walkNoteKey;
  int walkMinutes = 0;
  Color incomingColor = AppColors.timeline;
  Color outgoingColor = AppColors.timeline;

  bool get isInterchange => transferTo != null;

  static List<TimelineEntry> build(TripResult trip) {
    final entries = <TimelineEntry>[];

    for (var i = 0; i < trip.segments.length; i++) {
      final segment = trip.segments[i];
      final lastIndex = segment.stations.length - 1;

      for (var j = 0; j <= lastIndex; j++) {
        final station = segment.stations[j];
        final joinsPrevious =
            j == 0 && entries.isNotEmpty && entries.last.station == station;
        final entry = joinsPrevious ? entries.last : TimelineEntry(station);
        if (!joinsPrevious) entries.add(entry);

        if (segment.isWalk) {
          if (j == 0) {
            entry.outgoingColor = AppColors.walk;
            entry.transferTo = segment.to.primaryLine;
            entry.walkMinutes = segment.walkMinutes;
            entry.walkNoteKey = _walkNoteKey(segment.from);
          } else {
            entry.incomingColor = AppColors.walk;
          }
          continue;
        }

        final line = segment.line!;
        if (j == 0) {
          entry.towards = segment.towards;
          if (joinsPrevious && !trip.segments[i - 1].isWalk) {
            entry.transferTo = line;
          }
        }
        if (j > 0) entry.incomingColor = line.color;
        if (j < lastIndex) entry.outgoingColor = line.color;
      }
    }

    if (entries.isNotEmpty) {
      entries.first.isFirst = true;
      entries.last.isLast = true;
    }
    return entries;
  }

  static String _walkNoteKey(Station from) {
    return from.primaryLine.mode == TransitMode.monorail
        ? 'monorail_to_metro_walk'
        : 'metro_to_monorail_walk';
  }
}
