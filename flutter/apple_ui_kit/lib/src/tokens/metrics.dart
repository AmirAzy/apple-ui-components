import 'package:flutter/widgets.dart';

/// Radii, sizes and durations shared by the components.
///
/// Big Sur kept Apple's tighter corner radii (5 to 10). iOS 27's liquid glass
/// surface pushed them out (26 to 34 for cards and sheets), so both sets are
/// kept apart on purpose instead of being averaged.
abstract final class AppleMetrics {
  // macOS Big Sur
  static const double windowRadius = 10;
  static const double controlRadius = 6;
  static const double smallControlRadius = 5;
  static const double windowTitleBarHeight = 38;
  static const double toolbarHeight = 52;
  static const double sidebarRowHeight = 28;
  static const double listRowHeight = 28;
  static const double trafficLightSize = 12;
  static const double trafficLightGap = 8;
  static const double macSwitchWidth = 38;
  static const double macSwitchHeight = 22;

  // iOS 27
  static const double cardRadius = 26;
  static const double sheetRadius = 34;
  static const double iosSwitchWidth = 51;
  static const double iosSwitchHeight = 31;
  static const double iosSwitchThumb = 27;
  static const double iosTabBarHeight = 56;
  static const double iosNavBarHeight = 54;
  static const double iosRowHeight = 52;
  static const double iosGroupInset = 16;
  static const double glassBlur = 28;
  static const double sheetGrabberWidth = 36;
  static const double sheetGrabberHeight = 5;

  // Shared motion. Fast and short, the way both systems move chrome around.
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration sheet = Duration(milliseconds: 380);

  static EdgeInsets get macWindowPadding => const EdgeInsets.all(8);
}
