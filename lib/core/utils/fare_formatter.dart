import 'package:get/get.dart';
import 'package:metro/models/fare_breakdown.dart';

class FareFormatter {
  const FareFormatter._();

  static String format(FareBreakdown fare) {
    final total = '${fare.total} ${'egp'.tr}';
    if (!fare.hasMultipleTickets) return total;
    final parts = fare.tickets
        .map((ticket) => '${ticket.price} ${ticket.mode.shortLabelKey.tr}')
        .join(' + ');
    return '$total ($parts)';
  }
}
