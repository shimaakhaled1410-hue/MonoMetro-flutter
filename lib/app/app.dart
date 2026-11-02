import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:metro/app/initial_binding.dart';
import 'package:metro/core/localization/app_locales.dart';
import 'package:metro/core/localization/app_translations.dart';
import 'package:metro/core/theme/app_themes.dart';
import 'package:metro/features/onboarding/splash_view.dart';
import 'package:metro/services/settings_service.dart';

class MonoMetroApp extends StatelessWidget {
  const MonoMetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();

    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'MonoMetro',
      builder: DevicePreview.appBuilder,
      locale: AppLocales.fromLanguageCode(settings.languageCode),
      fallbackLocale: AppLocales.english,
      supportedLocales: AppLocales.supported,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      translations: AppTranslations(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
      home: const SplashView(),
    );
  }
}
