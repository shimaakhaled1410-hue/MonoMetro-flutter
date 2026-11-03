import 'package:flutter/material.dart';
import 'package:metro/core/theme/app_palette.dart';
import 'package:metro/models/transit_line.dart';

extension AppThemeContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Every app color. Prefer this over `Colors.*` and `Color(0x...)`.
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;

  Color get brand => palette.brand;

  Color get surfaceColor => palette.surface;

  Color get borderColor => palette.border;

  Color get fieldColor => palette.field;

  Color get mutedColor => palette.muted;

  Color get onSurfaceStrong => palette.text;

  Color lineColor(TransitLine line) => palette.lineColor(line);
}
