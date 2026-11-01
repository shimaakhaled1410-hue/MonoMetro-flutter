import 'package:get/get.dart';
import '../data/metro_data.dart';
import '../models/station_model.dart';
import '../services/location_service.dart';
import '../services/metro_graph_service.dart';
import '../utils/app_snackbar.dart';
import 'helpers/metro_location_helper.dart';
import 'helpers/trip_saver_helper.dart';

class MetroController extends GetxController {
  final MetroGraphService _graphService = MetroGraphService();

  var startStationName = ''.obs;
  var endStationName = ''.obs;
  var passengerType = PassengerType.normal.obs;

  var fastestTrip = Rxn<TripResult>();
  var comfortableTrip = Rxn<TripResult>();
  var selectedRouteIndex = 0.obs;

  var isLoadingLocation = false.obs;
  final RxnString selectedDestinationTag = RxnString();

  List<Station> get allStations => MetroData.allStations;
  Station? get selectedStartStation =>
      startStationName.value.isEmpty ? null : _graphService.getStationByName(startStationName.value);
  Station? get selectedEndStation =>
      endStationName.value.isEmpty ? null : _graphService.getStationByName(endStationName.value);
  TripResult? get activeTrip =>
      selectedRouteIndex.value == 0 ? fastestTrip.value : comfortableTrip.value;

  void selectStartStation(String name) => startStationName.value = name;
  void selectEndStation(String name, {String? tag}) {
    endStationName.value = name;
    selectedDestinationTag.value = tag;
  }

  void swapStations() {
    if (startStationName.value.isEmpty && endStationName.value.isEmpty) return;
    final temp = startStationName.value;
    startStationName.value = endStationName.value;
    endStationName.value = temp;
    selectedDestinationTag.value = null;
    if (startStationName.value.isNotEmpty && endStationName.value.isNotEmpty) calculateTrip();
  }

  void setPassengerType(PassengerType type) {
    passengerType.value = type;
    if (startStationName.value.isNotEmpty && endStationName.value.isNotEmpty) calculateTrip();
  }

  void selectRouteOption(int index) => selectedRouteIndex.value = index;

  void calculateTrip() {
    if (startStationName.value.isEmpty || endStationName.value.isEmpty) {
      AppSnackbar.warning(title: 'warning'.tr, message: 'select_both_stations'.tr);
      return;
    }
    if (startStationName.value == endStationName.value) {
      fastestTrip.value = null;
      comfortableTrip.value = null;
      AppSnackbar.warning(title: 'metro_title'.tr, message: 'same_station_error'.tr);
      return;
    }
    if ((startStationName.value == "Stadium" && endStationName.value == "Stadium (Monorail)") ||
        (startStationName.value == "Stadium (Monorail)" && endStationName.value == "Stadium")) {
      fastestTrip.value = null;
      comfortableTrip.value = null;
      AppSnackbar.warning(title: 'notice'.tr, message: 'stadium_walk_notice'.tr);
      return;
    }

    selectedRouteIndex.value = 0;
    fastestTrip.value = _graphService.calculateTrip(
      startStationName.value,
      endStationName.value,
      passengerType.value,
      preferFewerTransfers: false,
    );
    comfortableTrip.value = _graphService.calculateTrip(
      startStationName.value,
      endStationName.value,
      passengerType.value,
      preferFewerTransfers: true,
    );

    if (fastestTrip.value != null && comfortableTrip.value != null) {
      final minFare = fastestTrip.value!.ticketPrice < comfortableTrip.value!.ticketPrice
          ? fastestTrip.value!.ticketPrice
          : comfortableTrip.value!.ticketPrice;
      fastestTrip.value = fastestTrip.value!.copyWith(ticketPrice: minFare);
      comfortableTrip.value = comfortableTrip.value!.copyWith(ticketPrice: minFare);
    }
  }

  void saveActiveTrip() {
    if (activeTrip == null) return;
    TripSaverHelper.save(
      trip: activeTrip!,
      startStation: startStationName.value,
      endStation: endStationName.value,
      passengerType: passengerType.value,
      destinationTag: selectedDestinationTag.value,
    );
  }

  void openStartStationMap() {
    if (selectedStartStation != null) {
      LocationService.openStationOnMap(selectedStartStation!);
    } else {
      AppSnackbar.warning(title: 'metro_title'.tr, message: 'select_dep_station'.tr);
    }
  }

  Future<void> findNearestToCurrentLocation(String filterType) => MetroLocationHelper.findNearest(
        filterType: filterType,
        isLoading: isLoadingLocation,
        onStationFound: (name) => startStationName.value = name,
      );

  Future<void> showNearestStationPicker() =>
      MetroLocationHelper.showPicker((type) => findNearestToCurrentLocation(type));
}