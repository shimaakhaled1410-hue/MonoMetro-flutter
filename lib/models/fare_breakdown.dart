import 'package:metro/models/transit_mode.dart';

class FareTicket {
  const FareTicket({
    required this.mode,
    required this.stationCount,
    required this.price,
  });

  final TransitMode mode;
  final int stationCount;
  final int price;

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'stationCount': stationCount,
        'price': price,
      };

  factory FareTicket.fromJson(Map<String, dynamic> json) {
    return FareTicket(
      mode: TransitMode.fromName(json['mode'] as String?) ?? TransitMode.metro,
      stationCount: (json['stationCount'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num).toInt(),
    );
  }
}

class FareBreakdown {
  const FareBreakdown(this.tickets);

  final List<FareTicket> tickets;

  int get total => tickets.fold(0, (sum, ticket) => sum + ticket.price);

  bool get hasMultipleTickets => tickets.length > 1;
}
