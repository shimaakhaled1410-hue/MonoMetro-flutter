import 'package:flutter/material.dart';
import 'package:metro/core/theme/app_palette.dart';

class AppThemes {
  const AppThemes._();

  static final ThemeData lightTheme = _build(
    AppPalette.light,
    Brightness.light,
  );

  static final ThemeData darkTheme = _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final barForeground = isDark ? p.text : p.brand;
    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: p.brand,
      brightness: brightness,
    ).copyWith(
      primary: p.brand,
      onPrimary: p.onBrand,
      surface: p.surface,
      onSurface: p.text,
      onSurfaceVariant: p.muted,
      surfaceContainerHighest: p.field,
      outline: p.borderStrong,
      outlineVariant: p.border,
      error: p.danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.scaffold,
      extensions: <ThemeExtension<dynamic>>[p],
      cardTheme: CardThemeData(
        elevation: 0,
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.surface,
        foregroundColor: barForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: barForeground,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.cta,
          foregroundColor: p.onCta,
          shape: roundedShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.brand,
          side: BorderSide(color: p.borderStrong),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.brand),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.field,
        side: BorderSide.none,
        labelStyle: TextStyle(color: p.text),
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.scaffold,
        modalBackgroundColor: p.scaffold,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.field,
        hintStyle: TextStyle(color: p.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: p.brand,
        unselectedLabelColor: p.muted,
        indicatorColor: p.brand,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: p.brand),
    );
  }
}
