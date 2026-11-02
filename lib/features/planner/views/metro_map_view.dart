import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_assets.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class MetroMapView extends StatelessWidget {
  const MetroMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('metro_map'.tr)),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.8,
          maxScale: 4.5,
          child: Image.asset(
            AppAssets.metroMap,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                'map_load_failed'.tr,
                style: TextStyle(color: context.mutedColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
