import 'package:metro/data/fare_data.dart';
import 'package:metro/models/fare_breakdown.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/trip_segment.dart';

class FareCalculatorService {
  const FareCalculatorService._();

  static int fareFor(TransitMode mode, int stationCount, PassengerType type) {
    if (stationCount < 2) return 0;
    if (type == PassengerType.specialNeeds) return FareData.specialNeedsFare;

    final tiers = FareData.tiers[mode];
    if (tiers == null) return 0;
    final price = tiers
        .firstWhere((tier) => stationCount <= tier.maxStations)
        .price;
    return type == PassengerType.senior ? (price + 1) ~/ 2 : price;
  }

  static FareBreakdown calculate(
    List<TripSegment> segments,
    PassengerType type,
  ) {
    final tickets = <FareTicket>[];
    TransitMode? currentMode;
    var stationCount = 0;

    void flush() {
      final mode = currentMode;
      if (mode != null && stationCount > 1) {
        tickets.add(
          FareTicket(
            mode: mode,
            stationCount: stationCount,
            price: fareFor(mode, stationCount, type),
          ),
        );
      }
      currentMode = null;
      stationCount = 0;
    }

    for (final segment in segments) {
      if (segment.isWalk) {
        flush();
        continue;
      }
      final segmentMode = segment.line!.mode;
      if (!FareData.tiers.containsKey(segmentMode)) {
        flush();
        continue;
      }
      if (currentMode != segmentMode) {
        flush();
        currentMode = segmentMode;
        stationCount = 1;
      }
      stationCount += segment.stops;
    }
    flush();

    return FareBreakdown(tickets);
  }
}
