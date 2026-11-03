import 'package:flutter/material.dart';
import 'package:metro/core/theme/app_palette.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/trip_result.dart';

/// What connects a timeline stop to its neighbour: a transit line or a walk.
/// Colors are resolved from the palette at paint time so they follow the theme.
class TimelineLink {
  const TimelineLink.walk() : line = null;
  const TimelineLink.transit(TransitLine this.line);

  final TransitLine? line;

  bool get isWalk => line == null;

  Color colorOf(AppPalette palette) {
    final line = this.line;
    return line == null ? palette.walk : palette.lineColor(line);
  }
}

class TimelineEntry {
  TimelineEntry(this.station);

  final Station station;
  bool isFirst = false;
  bool isLast = false;
  TransitLine? transferTo;
  Station? towards;
  TransitLine? travelLine;
  String? walkNoteKey;
  int walkMinutes = 0;
  TimelineLink? incoming;
  TimelineLink? outgoing;

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
            entry.outgoing = const TimelineLink.walk();
            entry.transferTo = segment.to.primaryLine;
            entry.walkMinutes = segment.walkMinutes;
            entry.walkNoteKey = _walkNoteKey(segment.from);
          } else {
            entry.incoming = const TimelineLink.walk();
          }
          continue;
        }

        final line = segment.line!;
        if (j == 0) {
          entry.towards = segment.towards;
          entry.travelLine = line;
          if (joinsPrevious && !trip.segments[i - 1].isWalk) {
            entry.transferTo = line;
          }
        }
        if (j > 0) entry.incoming = TimelineLink.transit(line);
        if (j < lastIndex) entry.outgoing = TimelineLink.transit(line);
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
