import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/core/constants/app_colors.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class CalculateTripButton extends StatelessWidget {
  const CalculateTripButton({super.key, required this.onPressed, this.color});

  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final background =
        color ?? (context.isDark ? AppColors.selectedRouteDark : context.brand);

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.alt_route_rounded, size: 20),
        label: Text(
          'calculate_trip'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
