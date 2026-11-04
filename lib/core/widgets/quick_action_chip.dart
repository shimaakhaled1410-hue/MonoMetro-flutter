import 'package:flutter/material.dart';
import 'package:metro/core/utils/theme_extensions.dart';

/// Compact pill-shaped shortcut used under the planner card.
class QuickActionChip extends StatelessWidget {
  const QuickActionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final Widget label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const shape = StadiumBorder();

    return Material(
      color: context.fieldColor,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: context.brand),
              const SizedBox(width: 8),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.onSurfaceStrong,
                ),
                child: label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
