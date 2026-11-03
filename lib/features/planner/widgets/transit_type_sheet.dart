import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/models/transit_mode.dart';

class _ModeStyle {
  const _ModeStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}

class TransitTypeSheet extends StatelessWidget {
  const TransitTypeSheet({
    super.key,
    required this.modes,
    required this.onSelected,
  });

  final List<TransitMode> modes;
  final ValueChanged<TransitMode> onSelected;

  static const Map<TransitMode, _ModeStyle> _styles = {
    TransitMode.metro: _ModeStyle(Icons.subway_rounded, Color(0xFF1F5F5B)),
    TransitMode.monorail: _ModeStyle(Icons.train_rounded, Color(0xFFFD5E5C)),
    TransitMode.brt: _ModeStyle(
      Icons.directions_bus_rounded,
      Color(0xFFF39C12),
    ),
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
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              for (final mode in modes) ...[
                ListTile(
                  leading: Icon(
                    _styles[mode]!.icon,
                    color: _styles[mode]!.color,
                  ),
                  title: Text(mode.labelKey.tr),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.grey.withValues(alpha: 0.08),
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
