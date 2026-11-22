import 'package:flutter/widgets.dart';

/// System colour pairs for the two design languages.
///
/// Values follow Apple's published system colours: macOS 11 Big Sur accent and
/// window greys, iOS 17+ semantic colours reused unchanged by iOS 27.
@immutable
class AppleColorSet {
  const AppleColorSet({
    required this.accent,
    required this.windowBackground,
    required this.contentBackground,
    required this.sidebarBackground,
    required this.controlBackground,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.separator,
    required this.fill,
    required this.glassTint,
    required this.glassStroke,
    required this.shadow,
  });

  final Color accent;
  final Color windowBackground;
  final Color contentBackground;
  final Color sidebarBackground;
  final Color controlBackground;
  final Color label;
  final Color secondaryLabel;
  final Color tertiaryLabel;
  final Color separator;
  final Color fill;
  final Color glassTint;
  final Color glassStroke;
  final Color shadow;

  static const AppleColorSet dark = AppleColorSet(
    accent: Color(0xFF0A84FF),
    windowBackground: Color(0xFF1E1E1E),
    contentBackground: Color(0xFF252525),
    sidebarBackground: Color(0xCC1C1C1E),
    controlBackground: Color(0xFF3A3A3C),
    label: Color(0xFFF5F5F7),
    secondaryLabel: Color(0x99EBEBF5),
    tertiaryLabel: Color(0x4DEBEBF5),
    separator: Color(0x33FFFFFF),
    fill: Color(0x17FFFFFF),
    glassTint: Color(0x4D1C1C1E),
    glassStroke: Color(0x2EFFFFFF),
    shadow: Color(0x66000000),
  );

  static const AppleColorSet light = AppleColorSet(
    accent: Color(0xFF007AFF),
    windowBackground: Color(0xFFECECEC),
    contentBackground: Color(0xFFFFFFFF),
    sidebarBackground: Color(0xE6F2F2F7),
    controlBackground: Color(0xFFFFFFFF),
    label: Color(0xFF1D1D1F),
    secondaryLabel: Color(0x991D1D1F),
    tertiaryLabel: Color(0x4D1D1D1F),
    separator: Color(0x1F000000),
    fill: Color(0x0F000000),
    glassTint: Color(0x66FFFFFF),
    glassStroke: Color(0x29FFFFFF),
    shadow: Color(0x33000000),
  );

  /// Traffic light colours are the same in both appearances.
  static const Color closeButton = Color(0xFFFF5F57);
  static const Color minimiseButton = Color(0xFFFEBC2E);
  static const Color zoomButton = Color(0xFF28C840);

  static AppleColorSet of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}
