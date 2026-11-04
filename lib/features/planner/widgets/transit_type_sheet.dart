import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';
import 'package:metro/core/widgets/app_sheet.dart';
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
    return AppSheet.show<void>(
      context,
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
    return AppSheet(
      title: 'select_transit_type'.tr,
      subtitle: 'choose_transit_type_desc'.tr,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < modes.length; i++) ...[
              if (i > 0) const SizedBox(height: 10),
              _ModeTile(
                mode: modes[i],
                icon: _icons[modes[i]]!,
                onTap: () => onSelected(modes[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.icon,
    required this.onTap,
  });

  final TransitMode mode;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.modeColor(mode);
    final radius = BorderRadius.circular(20);

    return Material(
      color: context.fieldColor,
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: context.isDark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  mode.labelKey.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: context.onSurfaceStrong,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: context.mutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
