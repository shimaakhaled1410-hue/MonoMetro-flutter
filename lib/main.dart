import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/app/app.dart';
import 'package:metro/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<SettingsService>(() => SettingsService().init());

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (_) => const MonoMetroApp(),
    ),
  );
}
