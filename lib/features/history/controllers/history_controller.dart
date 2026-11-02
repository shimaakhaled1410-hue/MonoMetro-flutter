import 'package:get/get.dart';
import 'package:metro/core/utils/app_snackbar.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/trip_history.dart';
import 'package:metro/models/trip_result.dart';
import 'package:metro/services/history_service.dart';

class HistoryController extends GetxController {
  final RxList<TripHistory> historyList = <TripHistory>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> _pending = Future<void>.value();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      historyList.assignAll(await HistoryService.load());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTrip({
    required TripResult trip,
    required Station start,
    required Station end,
    required PassengerType passengerType,
    String? destinationTag,
  }) async {
    final entry = TripHistory.fromTrip(
      trip: trip,
      start: start,
      end: end,
      passengerType: passengerType,
      destinationTag: destinationTag,
    );

    if (historyList.any(entry.isSameRouteAs)) {
      AppSnackbar.info(
        title: 'metro_title'.tr,
        message: 'trip_already_saved'.tr,
      );
      return;
    }

    historyList.insert(0, entry);
    await _persist();
    AppSnackbar.success(
      title: 'metro_title'.tr,
      message: 'trip_saved_success'.tr,
    );
  }

  void deleteItemWithUndo(TripHistory item) {
    final index = historyList.indexWhere((trip) => trip.id == item.id);
    if (index < 0) return;

    historyList.removeAt(index);
    _persist();

    AppSnackbar.showWithUndo(
      title: 'route_deleted_title'.tr,
      message: 'route_deleted_desc'.tr,
      onUndo: () {
        final restoreIndex = index.clamp(0, historyList.length);
        historyList.insert(restoreIndex, item);
        _persist();
      },
    );
  }

  void clearAllWithUndo() {
    if (historyList.isEmpty) return;

    final backup = List<TripHistory>.of(historyList);
    historyList.clear();
    _persist();

    AppSnackbar.showWithUndo(
      title: 'history_cleared_title'.tr,
      message: 'history_cleared_desc'.tr,
      onUndo: () {
        historyList.assignAll(backup);
        _persist();
      },
    );
  }

  Future<void> _persist() {
    final snapshot = List<TripHistory>.of(historyList);
    _pending = _pending
        .catchError((_) {})
        .then((_) => HistoryService.saveAll(snapshot));
    return _pending;
  }
}
