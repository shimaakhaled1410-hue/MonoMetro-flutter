import 'package:flutter/material.dart';

class AppLocales {
  const AppLocales._();

  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'EG');
  static const List<Locale> supported = [english, arabic];

  static Locale fromLanguageCode(String code) {
    return code == 'ar' ? arabic : english;
  }
}
