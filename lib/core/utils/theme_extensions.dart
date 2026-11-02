import 'package:flutter/material.dart';
import 'package:metro/core/constants/app_colors.dart';

extension AppThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get brand => Theme.of(this).colorScheme.primary;

  Color get surfaceColor => isDark ? AppColors.surfaceDark : Colors.white;

  Color get borderColor =>
      isDark ? AppColors.borderDark : Colors.grey.shade300;

  Color get fieldColor => isDark ? AppColors.fieldDark : AppColors.fieldLight;

  Color get mutedColor => isDark ? Colors.grey.shade400 : Colors.grey.shade600;

  Color get onSurfaceStrong => isDark ? Colors.white : Colors.black87;
}
