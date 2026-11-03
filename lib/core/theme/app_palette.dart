import 'package:flutter/material.dart';
import 'package:metro/models/passenger_type.dart';
import 'package:metro/models/transit_line.dart';
import 'package:metro/models/transit_mode.dart';

/// Single source of truth for every color in the app.
///
/// This is the only file allowed to contain color literals. Widgets read
/// colors through `context.palette` (see `theme_extensions.dart`), never
/// from `Colors.*` or `Color(0x...)`.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brand,
    required this.onBrand,
    required this.cta,
    required this.onCta,
    required this.scaffold,
    required this.surface,
    required this.field,
    required this.border,
    required this.borderStrong,
    required this.text,
    required this.muted,
    required this.selectedRoute,
    required this.onSelectedRoute,
    required this.onSelectedRouteMuted,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.monorail,
    required this.brt,
    required this.walk,
    required this.startMarker,
    required this.endMarker,
    required this.timeline,
    required this.interchange,
    required this.interchangeRing,
    required this.onInterchange,
    required this.success,
    required this.danger,
    required this.warning,
    required this.info,
    required this.passengerNormal,
    required this.passengerSenior,
    required this.passengerSpecial,
    required this.shadow,
  });

  /// Brand color: icons, links, selected states.
  final Color brand;
  /// Content drawn on top of [brand].
  final Color onBrand;
  /// Primary call-to-action button background.
  final Color cta;
  /// Content drawn on top of [cta].
  final Color onCta;
  /// Page background.
  final Color scaffold;
  /// Cards, sheets, app bars.
  final Color surface;
  /// Inputs, tiles and chips sitting on a surface.
  final Color field;
  /// Default hairline and card border.
  final Color border;
  /// Emphasized border, sheet handle, outlined buttons.
  final Color borderStrong;
  /// Primary text.
  final Color text;
  /// Secondary text, labels, inactive icons.
  final Color muted;
  /// Background of the selected route option.
  final Color selectedRoute;
  /// Primary content on [selectedRoute].
  final Color onSelectedRoute;
  /// Secondary content on [selectedRoute].
  final Color onSelectedRouteMuted;
  /// Metro line 1.
  final Color line1;
  /// Metro line 2.
  final Color line2;
  /// Metro line 3.
  final Color line3;
  /// Monorail line.
  final Color monorail;
  /// BRT line.
  final Color brt;
  /// Walking segments.
  final Color walk;
  /// Trip start marker.
  final Color startMarker;
  /// Trip destination marker.
  final Color endMarker;
  /// Timeline default segment and intermediate stop outline.
  final Color timeline;
  /// Interchange node fill in the timeline.
  final Color interchange;
  /// Interchange node outline.
  final Color interchangeRing;
  /// Icon drawn inside the interchange node.
  final Color onInterchange;
  /// Success feedback.
  final Color success;
  /// Errors and destructive actions.
  final Color danger;
  /// Warnings.
  final Color warning;
  /// Informational feedback.
  final Color info;
  /// Normal passenger badge.
  final Color passengerNormal;
  /// Senior passenger badge.
  final Color passengerSenior;
  /// Special needs passenger badge.
  final Color passengerSpecial;
  /// Base color for shadows; apply alpha at the call site.
  final Color shadow;

  static const AppPalette light = AppPalette(
    brand: Color(0xFF22272E),
    onBrand: Color(0xFFFFFFFF),
    cta: Color(0xFF22272E),
    onCta: Color(0xFFFFFFFF),
    scaffold: Color(0xFFF6F6F4),
    surface: Color(0xFFFFFFFF),
    field: Color(0xFFEEEDE9),
    border: Color(0xFFE1E0DB),
    borderStrong: Color(0xFFC9C7C0),
    text: Color(0xFF1B1D1F),
    muted: Color(0xFF5E6166),
    selectedRoute: Color(0xFF22272E),
    onSelectedRoute: Color(0xFFFFFFFF),
    onSelectedRouteMuted: Color(0xFFC9D1DC),
    line1: Color(0xFF1565C0),
    line2: Color(0xFFC62828),
    line3: Color(0xFF2E7D32),
    monorail: Color(0xFF00796B),
    brt: Color(0xFFB85C00),
    walk: Color(0xFF546E7A),
    startMarker: Color(0xFF22272E),
    endMarker: Color(0xFF7B1FA2),
    timeline: Color(0xFF22272E),
    interchange: Color(0xFF22272E),
    interchangeRing: Color(0xFFFFFFFF),
    onInterchange: Color(0xFFFFFFFF),
    success: Color(0xFF2E7D32),
    danger: Color(0xFFC62828),
    warning: Color(0xFFED6C02),
    info: Color(0xFF0288D1),
    passengerNormal: Color(0xFF1565C0),
    passengerSenior: Color(0xFFB85C00),
    passengerSpecial: Color(0xFF00796B),
    shadow: Color(0xFF000000),
  );

  static const AppPalette dark = AppPalette(
    brand: Color(0xFFE6E8EB),
    onBrand: Color(0xFF15181B),
    cta: Color(0xFFE6E8EB),
    onCta: Color(0xFF15181B),
    scaffold: Color(0xFF0F1113),
    surface: Color(0xFF181B1F),
    field: Color(0xFF21252A),
    border: Color(0xFF33383F),
    borderStrong: Color(0xFF454B54),
    text: Color(0xFFF2F3F4),
    muted: Color(0xFF9BA1A9),
    selectedRoute: Color(0xFF2A2F36),
    onSelectedRoute: Color(0xFFFFFFFF),
    onSelectedRouteMuted: Color(0xFFC9D1DC),
    line1: Color(0xFF42A5F5),
    line2: Color(0xFFEF5350),
    line3: Color(0xFF66BB6A),
    monorail: Color(0xFF26A69A),
    brt: Color(0xFFFFB74D),
    walk: Color(0xFF90A4AE),
    startMarker: Color(0xFFE6E8EB),
    endMarker: Color(0xFFCE93D8),
    timeline: Color(0xFFE6E8EB),
    interchange: Color(0xFFE6E8EB),
    interchangeRing: Color(0xFF181B1F),
    onInterchange: Color(0xFF15181B),
    success: Color(0xFF66BB6A),
    danger: Color(0xFFEF5350),
    warning: Color(0xFFFFA726),
    info: Color(0xFF42A5F5),
    passengerNormal: Color(0xFF42A5F5),
    passengerSenior: Color(0xFFFFB74D),
    passengerSpecial: Color(0xFF26A69A),
    shadow: Color(0xFF000000),
  );

  static AppPalette of(bool isDark) => isDark ? dark : light;

  Color lineColor(TransitLine line) {
    switch (line) {
      case TransitLine.line1:
        return line1;
      case TransitLine.line2:
        return line2;
      case TransitLine.line3:
        return line3;
      case TransitLine.monorailEast:
        return monorail;
      case TransitLine.brtRing:
        return brt;
    }
  }

  Color modeColor(TransitMode mode) {
    switch (mode) {
      case TransitMode.metro:
        return brand;
      case TransitMode.monorail:
        return monorail;
      case TransitMode.brt:
        return brt;
    }
  }

  Color passengerColor(PassengerType type) {
    switch (type) {
      case PassengerType.normal:
        return passengerNormal;
      case PassengerType.senior:
        return passengerSenior;
      case PassengerType.specialNeeds:
        return passengerSpecial;
    }
  }

  @override
  AppPalette copyWith({
    Color? brand,
    Color? onBrand,
    Color? cta,
    Color? onCta,
    Color? scaffold,
    Color? surface,
    Color? field,
    Color? border,
    Color? borderStrong,
    Color? text,
    Color? muted,
    Color? selectedRoute,
    Color? onSelectedRoute,
    Color? onSelectedRouteMuted,
    Color? line1,
    Color? line2,
    Color? line3,
    Color? monorail,
    Color? brt,
    Color? walk,
    Color? startMarker,
    Color? endMarker,
    Color? timeline,
    Color? interchange,
    Color? interchangeRing,
    Color? onInterchange,
    Color? success,
    Color? danger,
    Color? warning,
    Color? info,
    Color? passengerNormal,
    Color? passengerSenior,
    Color? passengerSpecial,
    Color? shadow,
  }) {
    return AppPalette(
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      cta: cta ?? this.cta,
      onCta: onCta ?? this.onCta,
      scaffold: scaffold ?? this.scaffold,
      surface: surface ?? this.surface,
      field: field ?? this.field,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      text: text ?? this.text,
      muted: muted ?? this.muted,
      selectedRoute: selectedRoute ?? this.selectedRoute,
      onSelectedRoute: onSelectedRoute ?? this.onSelectedRoute,
      onSelectedRouteMuted: onSelectedRouteMuted ?? this.onSelectedRouteMuted,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      line3: line3 ?? this.line3,
      monorail: monorail ?? this.monorail,
      brt: brt ?? this.brt,
      walk: walk ?? this.walk,
      startMarker: startMarker ?? this.startMarker,
      endMarker: endMarker ?? this.endMarker,
      timeline: timeline ?? this.timeline,
      interchange: interchange ?? this.interchange,
      interchangeRing: interchangeRing ?? this.interchangeRing,
      onInterchange: onInterchange ?? this.onInterchange,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      passengerNormal: passengerNormal ?? this.passengerNormal,
      passengerSenior: passengerSenior ?? this.passengerSenior,
      passengerSpecial: passengerSpecial ?? this.passengerSpecial,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      brand: Color.lerp(brand, other.brand, t)!,
      onBrand: Color.lerp(onBrand, other.onBrand, t)!,
      cta: Color.lerp(cta, other.cta, t)!,
      onCta: Color.lerp(onCta, other.onCta, t)!,
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      field: Color.lerp(field, other.field, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      text: Color.lerp(text, other.text, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      selectedRoute: Color.lerp(selectedRoute, other.selectedRoute, t)!,
      onSelectedRoute: Color.lerp(onSelectedRoute, other.onSelectedRoute, t)!,
      onSelectedRouteMuted: Color.lerp(onSelectedRouteMuted, other.onSelectedRouteMuted, t)!,
      line1: Color.lerp(line1, other.line1, t)!,
      line2: Color.lerp(line2, other.line2, t)!,
      line3: Color.lerp(line3, other.line3, t)!,
      monorail: Color.lerp(monorail, other.monorail, t)!,
      brt: Color.lerp(brt, other.brt, t)!,
      walk: Color.lerp(walk, other.walk, t)!,
      startMarker: Color.lerp(startMarker, other.startMarker, t)!,
      endMarker: Color.lerp(endMarker, other.endMarker, t)!,
      timeline: Color.lerp(timeline, other.timeline, t)!,
      interchange: Color.lerp(interchange, other.interchange, t)!,
      interchangeRing: Color.lerp(interchangeRing, other.interchangeRing, t)!,
      onInterchange: Color.lerp(onInterchange, other.onInterchange, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      passengerNormal: Color.lerp(passengerNormal, other.passengerNormal, t)!,
      passengerSenior: Color.lerp(passengerSenior, other.passengerSenior, t)!,
      passengerSpecial: Color.lerp(passengerSpecial, other.passengerSpecial, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}
