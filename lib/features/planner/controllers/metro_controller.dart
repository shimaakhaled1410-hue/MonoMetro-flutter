import 'package:get/get.dart';
import 'package:metro/core/utils/app_snackbar.dart';
import 'package:metro/features/history/controllers/history_controller.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/routing_preference.dart';
import 'package:metro/models/station.dart';
import 'package:metro/models/transit_mode.dart';
import 'package:metro/models/trip_result.dart';
import 'package:metro/services/location_service.dart';
import 'package:metro/services/map_launcher_service.dart';
import 'package:metro/services/metro_graph_service.dart';
import 'package:metro/services/nearest_station_service.dart';
import 'package:metro/services/settings_service.dart';

class MetroController extends GetxController {
  MetroController({
    required MetroGraphService graphService,
    required SettingsService settings,
    required HistoryController history,
  })  : _graph = graphService,
        _settings = settings,
        _history = history;

  final MetroGraphService _graph;
  final SettingsService _settings;
  final HistoryController _history;

  final Rxn<Station> startStation = Rxn<Station>();
  final Rxn<Station> endStation = Rxn<Station>();
  final RxnString destinationTag = RxnString();
  final Rx<PassengerType> passengerType = PassengerType.normal.obs;

  final Rxn<TripResult> fastestTrip = Rxn<TripResult>();
  final Rxn<TripResult> comfortableTrip = Rxn<TripResult>();
  final RxInt selectedRouteIndex = 0.obs;
  final RxBool isLoadingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    passengerType.value = _settings.passengerType;
  }

  TripResult? get activeTrip {
    return selectedRouteIndex.value == 0
        ? fastestTrip.value
        : comfortableTrip.value;
  }

  bool get hasDistinctOptions {
    final fastest = fastestTrip.value;
    final comfortable = comfortableTrip.value;
    if (fastest == null || comfortable == null) return false;
    return !fastest.hasSamePathAs(comfortable);
  }

  void selectStartStation(Station station) {
    startStation.value = station;
    _clearResults();
  }

  void selectEndStation(Station station, {String? tag}) {
    endStation.value = station;
    destinationTag.value = tag;
    _clearResults();
  }

  void selectRouteOption(int index) => selectedRouteIndex.value = index;

  void swapStations() {
    final start = startStation.value;
    final end = endStation.value;
    if (start == null && end == null) return;

    final hadResults = fastestTrip.value != null;
    startStation.value = end;
    endStation.value = start;
    destinationTag.value = null;
    _clearResults();

    if (hadResults && start != null && end != null) {
      _computeTrips(end, start);
    }
  }

  void setPassengerType(PassengerType type) {
    passengerType.value = type;
    _settings.setPassengerType(type);

    final start = startStation.value;
    final end = endStation.value;
    if (fastestTrip.value != null && start != null && end != null) {
      _computeTrips(start, end);
    }
  }

  void calculateTrip() {
    final start = startStation.value;
    final end = endStation.value;

    if (start == null || end == null) {
      AppSnackbar.warning(
        title: 'warning'.tr,
        message: 'select_both_stations'.tr,
      );
      return;
    }

    _clearResults();

    if (start == end) {
      AppSnackbar.warning(
        title: 'metro_title'.tr,
        message: 'same_station_error'.tr,
      );
      return;
    }

    if (_graph.isWalkLinked(start.name, end.name)) {
      AppSnackbar.warning(
        title: 'notice'.tr,
        message: 'stadium_walk_notice'.trParams({
          'minutes': _graph.walkMinutesBetween(start.name, end.name).toString(),
        }),
      );
      return;
    }

    _computeTrips(start, end);

    if (fastestTrip.value == null) {
      AppSnackbar.error(
        title: 'metro_title'.tr,
        message: 'no_route_found'.tr,
      );
    }
  }

  Future<void> saveActiveTrip() async {
    final trip = activeTrip;
    final start = startStation.value;
    final end = endStation.value;
    if (trip == null || start == null || end == null) return;

    await _history.addTrip(
      trip: trip,
      start: start,
      end: end,
      passengerType: passengerType.value,
      destinationTag: destinationTag.value,
    );
  }

  Future<void> openStationOnMap(Station station) async {
    final opened = await MapLauncherService.openStation(station);
    if (!opened) {
      AppSnackbar.error(
        title: 'metro_title'.tr,
        message: 'map_open_failed'.tr,
      );
    }
  }

  void openStartStationMap() {
    final station = startStation.value;
    if (station == null) {
      AppSnackbar.warning(
        title: 'metro_title'.tr,
        message: 'select_dep_station'.tr,
      );
      return;
    }
    openStationOnMap(station);
  }

  Future<void> useNearestStation(TransitMode mode) async {
    if (isLoadingLocation.value) return;

    isLoadingLocation.value = true;
    try {
      final result = await LocationService.getCurrentPosition();
      final position = result.position;
      if (position == null) {
        final (title, message) = _locationMessage(result.failure);
        AppSnackbar.warning(title: title.tr, message: message.tr);
        return;
      }
      selectStartStation(
        NearestStationService.find(
          position.latitude,
          position.longitude,
          mode: mode,
        ),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  (String, String) _locationMessage(LocationFailure? failure) {
    return switch (failure) {
      LocationFailure.serviceDisabled => (
          'location_notice_title',
          'location_notice_desc',
        ),
      LocationFailure.permissionDenied => (
          'location_permission_title',
          'location_permission_denied',
        ),
      LocationFailure.permissionDeniedForever => (
          'location_permission_title',
          'location_permission_denied_forever',
        ),
      _ => ('location_error_title', 'location_error_desc'),
    };
  }

  void _computeTrips(Station start, Station end) {
    selectedRouteIndex.value = 0;
    fastestTrip.value = _graph.calculateTrip(
      start.name,
      end.name,
      passengerType.value,
      preference: RoutingPreference.fastest,
    );
    comfortableTrip.value = _graph.calculateTrip(
      start.name,
      end.name,
      passengerType.value,
      preference: RoutingPreference.comfortable,
    );
  }

  void _clearResults() {
    fastestTrip.value = null;
    comfortableTrip.value = null;
    selectedRouteIndex.value = 0;
  }
}
