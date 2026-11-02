import 'package:metro/models/fare_breakdown.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/trip_result.dart';

class TripHistory {
  const TripHistory({
    required this.id,
    required this.startStation,
    required this.endStation,
    required this.stationCount,
    required this.timeInMinutes,
    required this.price,
    required this.tickets,
    required this.timestamp,
    required this.routeStations,
    this.passengerType = PassengerType.normal,
    this.destinationTag,
  });

  final String id;
  final String startStation;
  final String endStation;
  final int stationCount;
  final int timeInMinutes;
  final int price;
  final List<FareTicket> tickets;
  final DateTime timestamp;
  final List<String> routeStations;
  final PassengerType passengerType;
  final String? destinationTag;

  FareBreakdown get fare => FareBreakdown(tickets);

  factory TripHistory.fromTrip({
    required TripResult trip,
    required Station start,
    required Station end,
    required PassengerType passengerType,
    String? destinationTag,
  }) {
    final now = DateTime.now();
    return TripHistory(
      id: now.microsecondsSinceEpoch.toString(),
      startStation: start.name,
      endStation: end.name,
      stationCount: trip.stationCount,
      timeInMinutes: trip.estimatedTimeMinutes,
      price: trip.ticketPrice,
      tickets: trip.fare.tickets,
      timestamp: now,
      routeStations: trip.path.map((station) => station.name).toList(),
      passengerType: passengerType,
      destinationTag: destinationTag,
    );
  }

  bool isSameRouteAs(TripHistory other) {
    if (startStation != other.startStation ||
        endStation != other.endStation ||
        passengerType != other.passengerType ||
        routeStations.length != other.routeStations.length) {
      return false;
    }
    for (var i = 0; i < routeStations.length; i++) {
      if (routeStations[i] != other.routeStations[i]) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startStation': startStation,
        'endStation': endStation,
        'stationCount': stationCount,
        'timeInMinutes': timeInMinutes,
        'price': price,
        'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
        'timestamp': timestamp.toIso8601String(),
        'routeStations': routeStations,
        'passengerType': passengerType.name,
        'destinationTag': destinationTag,
      };

  factory TripHistory.fromJson(Map<String, dynamic> json) {
    final price = (json['price'] as num).toInt();
    return TripHistory(
      id: json['id'] as String,
      startStation: json['startStation'] as String,
      endStation: json['endStation'] as String,
      stationCount: json['stationCount'] as int,
      timeInMinutes: json['timeInMinutes'] as int,
      price: price,
      tickets: _readTickets(json, price),
      timestamp: DateTime.parse(json['timestamp'] as String),
      routeStations: List<String>.from(json['routeStations'] as List),
      passengerType: PassengerType.fromName(json['passengerType'] as String?),
      destinationTag: json['destinationTag'] as String?,
    );
  }

  static List<FareTicket> _readTickets(Map<String, dynamic> json, int price) {
    final stored = json['tickets'] as List?;
    if (stored != null) {
      return stored
          .map((item) => FareTicket.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    final metro = (json['metroPrice'] as num?)?.toInt() ?? 0;
    final monorail = (json['monorailPrice'] as num?)?.toInt() ?? 0;
    final legacy = <FareTicket>[
      if (metro > 0)
        FareTicket(mode: TransitMode.metro, stationCount: 0, price: metro),
      if (monorail > 0)
        FareTicket(
          mode: TransitMode.monorail,
          stationCount: 0,
          price: monorail,
        ),
    ];
    if (legacy.isNotEmpty) return legacy;
    return [
      FareTicket(mode: TransitMode.metro, stationCount: 0, price: price),
    ];
  }
}
