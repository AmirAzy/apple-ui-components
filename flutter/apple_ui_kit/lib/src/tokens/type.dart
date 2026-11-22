import 'package:flutter/widgets.dart';

/// Text styles that approximate San Francisco with the platform default font.
///
/// The kit never ships a font file: on Apple platforms the system font already
/// is SF, and elsewhere the platform default keeps metrics sane. Letter spacing
/// is where SF's optical sizing shows up, so it is spelled out per style.
abstract final class AppleType {
  static const List<String> _fallback = <String>[
    'SF Pro Text',
    'SF Pro Display',
    '-apple-system',
    'Segoe UI',
    'Roboto',
  ];

  static TextStyle _style(
    double size,
    FontWeight weight,
    double spacing, {
    double? height,
  }) =>
      TextStyle(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        height: height,
        fontFamilyFallback: _fallback,
      );

  // macOS 11 window chrome leans small: 13 as the body size, 11 for sidebar.
  static TextStyle get macTitle => _style(13, FontWeight.w600, -0.08);
  static TextStyle get macBody => _style(13, FontWeight.w400, -0.08);
  static TextStyle get macSidebarSection => _style(11, FontWeight.w600, 0.06);
  static TextStyle get macSidebarRow => _style(13, FontWeight.w400, -0.08);
  static TextStyle get macSmall => _style(11, FontWeight.w400, 0.0);

  // iOS 27: 17 is the body size, large titles are 34.
  static TextStyle get iosLargeTitle => _style(34, FontWeight.w700, 0.37);
  static TextStyle get iosTitle2 => _style(22, FontWeight.w600, -0.26);
  static TextStyle get iosHeadline => _style(17, FontWeight.w600, -0.41);
  static TextStyle get iosBody => _style(17, FontWeight.w400, -0.41);
  static TextStyle get iosSubhead => _style(15, FontWeight.w400, -0.24);
  static TextStyle get iosFootnote => _style(13, FontWeight.w400, -0.08);
  static TextStyle get iosCaption => _style(11, FontWeight.w400, 0.07);
  static TextStyle get iosTabLabel => _style(10, FontWeight.w500, 0.0);
}
