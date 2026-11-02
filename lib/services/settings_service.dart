import 'package:get/get.dart';
import 'package:metro/core/constants/storage_keys.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  late final SharedPreferences _prefs;

  Future<SettingsService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get isDarkMode => _prefs.getBool(StorageKeys.darkMode) ?? false;

  String get languageCode {
    final saved = _prefs.getString(StorageKeys.languageCode);
    if (saved != null) return saved;
    return Get.deviceLocale?.languageCode == 'ar' ? 'ar' : 'en';
  }

  PassengerType get passengerType {
    return PassengerType.fromName(_prefs.getString(StorageKeys.passengerType));
  }

  bool get onboardingDone =>
      _prefs.getBool(StorageKeys.onboardingDone) ?? false;

  Future<void> setDarkMode(bool value) {
    return _prefs.setBool(StorageKeys.darkMode, value);
  }

  Future<void> setLanguageCode(String code) {
    return _prefs.setString(StorageKeys.languageCode, code);
  }

  Future<void> setPassengerType(PassengerType type) {
    return _prefs.setString(StorageKeys.passengerType, type.name);
  }

  Future<void> markOnboardingDone() {
    return _prefs.setBool(StorageKeys.onboardingDone, true);
  }
}
