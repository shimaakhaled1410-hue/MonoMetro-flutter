import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/utils/format_time.dart';
import '../../models/station_model.dart';
import '../../services/fare_calculator_service.dart';

class RouteOptionCard extends StatelessWidget {
  final String title;
  final TripResult trip;
  final bool isSelected;
  final VoidCallback onTap;

  const RouteOptionCard({
    super.key,
    required this.title,
    required this.trip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    Color bg = isSelected
        ? (isDark ? const Color(0xFF2A364F) : const Color(0xFF1B3A57))
        : (isDark ? const Color(0xFF1E222B) : Colors.white);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primary : (isDark ? const Color(0xFF2C3240) : Colors.grey.shade300),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? Colors.white : primary),
            ),
            const SizedBox(height: 8),
            Text(
              '${trip.stationCount} ${'stations'.tr} • ${formatTripDuration(trip.estimatedTimeMinutes)}',
              style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : (isDark ? Colors.grey.shade400 : Colors.black87)),
            ),
            const SizedBox(height: 4),
            Builder(
              builder: (context) {
                int metroMoves = 0;
                int monoMoves = 0;
                int brtMoves = 0;

                for (int i = 0; i < trip.path.length - 1; i++) {
                  final cur = trip.path[i];
                  final nxt = trip.path[i + 1];

                  if (cur.lines.contains("BRT Ring Road") && nxt.lines.contains("BRT Ring Road")) {
                    brtMoves++;
                  } else if (cur.lines.contains("Monorail East") && nxt.lines.contains("Monorail East")) {
                    monoMoves++;
                  } else {
                    metroMoves++;
                  }
                }

                String priceDisplay = '${trip.ticketPrice} ${'ticket'.tr}';
                int modesCount = (metroMoves > 0 ? 1 : 0) + (monoMoves > 0 ? 1 : 0) + (brtMoves > 0 ? 1 : 0);

                if (modesCount > 1) {
                  List<String> parts = [];
                  if (metroMoves > 0) parts.add('${FareCalculatorService.calculateMetroFare(metroMoves + 1, PassengerType.normal)} مترو');
                  if (monoMoves > 0) parts.add('${FareCalculatorService.calculateMonorailFare(monoMoves + 1, PassengerType.normal)} مونوريل');
                  if (brtMoves > 0) parts.add('${FareCalculatorService.calculateBrtFare(brtMoves + 1, PassengerType.normal)} BRT');
                  priceDisplay += ' (${parts.join(' + ')})';
                }

                return Text(
                  '${trip.transferCount} ${'transfers_count'.tr} • $priceDisplay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}