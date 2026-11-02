import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/station.dart';

class BrtStationTile extends StatelessWidget {
  const BrtStationTile({
    super.key,
    required this.station,
    required this.number,
    required this.onOpenMap,
  });

  final Station station;
  final int number;
  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final isInterchange = station.isInterchange;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: context.isDark ? AppColors.surfaceDark : Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isInterchange ? AppColors.brt : context.borderColor,
          width: isInterchange ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.brt.withValues(alpha: 0.15),
          child: Text(
            '$number',
            style: const TextStyle(
              color: AppColors.brt,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          station.localizedName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: isInterchange
            ? Text(
                'transfer'.tr,
                style: const TextStyle(color: AppColors.brt, fontSize: 12),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.location_on_outlined, color: AppColors.brt),
          onPressed: onOpenMap,
        ),
      ),
    );
  }
}
