import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/localization/app_locales.dart';
import 'package:metro/services/settings_service.dart';

class SettingsController extends GetxController {
  SettingsController(this._settings);

  final SettingsService _settings;

  final RxBool isDarkMode = false.obs;
  final RxString languageCode = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _settings.isDarkMode;
    languageCode.value = _settings.languageCode;
  }

  Future<void> toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    await _settings.setDarkMode(isDarkMode.value);
  }

  Future<void> changeLanguage(String code) async {
    if (languageCode.value == code) return;
    languageCode.value = code;
    Get.updateLocale(AppLocales.fromLanguageCode(code));
    await _settings.setLanguageCode(code);
  }
}
