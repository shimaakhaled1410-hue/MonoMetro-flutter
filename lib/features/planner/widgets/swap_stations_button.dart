import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class SwapStationsButton extends StatelessWidget {
  const SwapStationsButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Tooltip(
          message: 'swap_stations'.tr,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(color: context.borderColor, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(Icons.swap_vert_rounded, color: context.brand, size: 22),
            ),
          ),
        ),
      ),
    );
  }
}
