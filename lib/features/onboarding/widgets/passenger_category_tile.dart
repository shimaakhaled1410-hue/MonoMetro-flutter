import 'package:flutter/material.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class PassengerCategoryTile extends StatelessWidget {
  const PassengerCategoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primary = context.brand;
    final onPrimary = isDark ? Colors.black87 : Colors.white;

    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: isDark ? 0.15 : 0.06)
                : context.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? primary : context.borderColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isSelected ? primary : context.fieldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isSelected ? onPrimary : context.mutedColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? primary : context.onSurfaceStrong,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: context.mutedColor),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? primary : context.mutedColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
