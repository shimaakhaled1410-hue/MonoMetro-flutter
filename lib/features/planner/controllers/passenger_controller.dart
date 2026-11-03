import 'package:get/get.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/services/settings_service.dart';

class PassengerController extends GetxController {
  PassengerController(this._settings);

  final SettingsService _settings;

  final Rx<PassengerType> type = PassengerType.normal.obs;

  @override
  void onInit() {
    super.onInit();
    type.value = _settings.passengerType;
  }

  void setType(PassengerType value) {
    type.value = value;
    _settings.setPassengerType(value);
  }
}
