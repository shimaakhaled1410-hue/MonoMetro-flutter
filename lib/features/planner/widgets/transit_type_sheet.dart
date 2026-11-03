import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/models/transit_mode.dart';

class TransitTypeSheet extends StatelessWidget {
  const TransitTypeSheet({
    super.key,
    required this.modes,
    required this.onSelected,
  });

  final List<TransitMode> modes;
  final ValueChanged<TransitMode> onSelected;

  static const Map<TransitMode, IconData> _icons = {
    TransitMode.metro: Icons.subway_rounded,
    TransitMode.monorail: Icons.train_rounded,
    TransitMode.brt: Icons.directions_bus_rounded,
  };

  static Future<void> show(
    BuildContext context, {
    required List<TransitMode> modes,
    required ValueChanged<TransitMode> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => TransitTypeSheet(
        modes: modes,
        onSelected: (mode) {
          Navigator.pop(sheetContext);
          onSelected(mode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'select_transit_type'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'choose_transit_type_desc'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: context.mutedColor),
              ),
              const SizedBox(height: 20),
              for (final mode in modes) ...[
                ListTile(
                  leading: Icon(
                    _icons[mode]!,
                    color: context.palette.modeColor(mode),
                  ),
                  title: Text(mode.labelKey.tr),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: context.fieldColor,
                  onTap: () => onSelected(mode),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
