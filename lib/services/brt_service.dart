import '../data/metro_data.dart';
import '../models/station_model.dart';
import 'fare_calculator_service.dart';

class BrtService {
  static TripResult? calculateBrtTrip({
    required String startStationName,
    required String endStationName,
    required PassengerType passengerType,
  }) {
    final list = MetroData.brtRingRoadNames;
    final startIndex = list.indexOf(startStationName);
    final endIndex = list.indexOf(endStationName);

    if (startIndex == -1 || endIndex == -1) return null;

    List<String> pathNames;
    if (startIndex <= endIndex) {
      pathNames = list.sublist(startIndex, endIndex + 1);
    } else {
      pathNames = list.sublist(endIndex, startIndex + 1).reversed.toList();
    }

    final pathStations = pathNames
        .map((name) => MetroData.allStations.firstWhere((s) => s.name == name))
        .toList();

    final count = pathStations.length;
    final estimatedTime = (count - 1) * 3;
    final fare = FareCalculatorService.calculateBrtFare(count, passengerType);

    return TripResult(
      path: pathStations,
      stationCount: count,
      estimatedTimeMinutes: estimatedTime,
      ticketPrice: fare,
      instructions: [
        'Start at ${pathStations.first.localizedName}',
        'Ride BRT Ring Road for ${count - 1} stops',
        'Arrive at ${pathStations.last.localizedName}',
      ],
      transferCount: 0,
    );
  }
}
