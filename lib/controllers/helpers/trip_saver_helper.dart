import 'package:get/get.dart';
import '../../models/station_model.dart';
import '../../models/trip_history_model.dart';
import '../../services/fare_calculator_service.dart';
import '../../services/history_service.dart';
import '../../utils/app_snackbar.dart';
import '../history_controller.dart';

class TripSaverHelper {
  static void save({
    required TripResult trip,
    required String startStation,
    required String endStation,
    required PassengerType passengerType,
    String? destinationTag,
  }) {
    int mCount = 0;
    int monoCount = 0;

    for (var s in trip.path) {
      if (s.lines.contains("Monorail East")) {
        monoCount++;
      } else if (!s.lines.contains("BRT Ring Road")) {
        mCount++;
      }
    }

    final calculatedMetroPrice = mCount > 0
        ? FareCalculatorService.calculateMetroFare(
            mCount,
            passengerType,
          ).toDouble()
        : 0.0;
    final calculatedMonoPrice = monoCount > 0
        ? FareCalculatorService.calculateMonorailFare(
            monoCount,
            passengerType,
          ).toDouble()
        : 0.0;

    final historyItem = TripHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startStation: startStation,
      endStation: endStation,
      stationCount: trip.stationCount,
      timeInMinutes: trip.estimatedTimeMinutes,
      price: trip.ticketPrice.toDouble(),
      metroPrice: calculatedMetroPrice,
      monorailPrice: calculatedMonoPrice,
      timestamp: DateTime.now(),
      routeStations: trip.path.map((s) => s.name).toList(),
      passengerType: passengerType,
      destinationTag: destinationTag,
    );

    HistoryService.saveTrip(historyItem).then((_) {
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().loadHistory();
      }
      AppSnackbar.success(
        title: 'metro_title'.tr,
        message: 'trip_saved_success'.tr,
      );
    });
  }
}
