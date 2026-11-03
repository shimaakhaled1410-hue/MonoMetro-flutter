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
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
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
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.scaffold,
        foregroundColor: p.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: p.text,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.cta,
          foregroundColor: p.onCta,
          minimumSize: const Size(0, 52),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.brand,
          minimumSize: const Size(0, 48),
          shape: buttonShape,
          side: BorderSide(color: p.borderStrong),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.brand),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.field,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        labelStyle: TextStyle(color: p.text),
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.scaffold,
        modalBackgroundColor: p.scaffold,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.field,
        hintStyle: TextStyle(color: p.muted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
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
