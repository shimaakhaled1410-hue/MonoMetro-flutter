import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    final brand = context.brand;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isInterchange ? brand : context.borderColor,
          width: isInterchange ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: brand.withValues(alpha: 0.12),
          child: Text(
            '$number',
            style: TextStyle(color: brand, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          station.localizedName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: isInterchange
            ? Text('transfer'.tr, style: TextStyle(color: brand, fontSize: 12))
            : null,
        trailing: IconButton(
          icon: Icon(Icons.location_on_outlined, color: brand),
          onPressed: onOpenMap,
        ),
      ),
    );
  }
}
