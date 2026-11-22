/// Apple-flavoured Flutter components.
///
/// Two design languages, one package:
/// * macOS Big Sur (11) chrome and controls — [MacWindow], [MacSidebar],
///   [MacToolbar], [MacButton], [MacSegmentedControl], [MacSwitch], [MacSlider],
///   [MacSearchField], [MacListRow].
/// * iOS / iPadOS 27 materials and controls — [IosGlass], [IosNavBar],
///   [IosTabBar], [IosListSection], [IosListTile], [IosSwitch],
///   [IosSegmentedControl], [IosButton], [IosSearchField], [IosSheet].
///
/// Tokens live in [AppleColors], [AppleType] and [AppleMetrics]. Every widget
/// takes an explicit [Brightness] where it matters, so a screen can mix a light
/// window with a dark preview without touching a global theme.
library;

export 'src/ios/button.dart';
export 'src/ios/glass.dart';
export 'src/ios/list.dart';
export 'src/ios/nav_bar.dart';
export 'src/ios/search_field.dart';
export 'src/ios/segmented_control.dart';
export 'src/ios/sheet.dart';
export 'src/ios/switch.dart';
export 'src/ios/tab_bar.dart';
export 'src/macos/button.dart';
export 'src/macos/list_row.dart';
export 'src/macos/search_field.dart';
export 'src/macos/segmented_control.dart';
export 'src/macos/sidebar.dart';
export 'src/macos/slider.dart';
export 'src/macos/switch.dart';
export 'src/macos/toolbar.dart';
export 'src/macos/window.dart';
export 'src/tokens/colors.dart';
export 'src/tokens/metrics.dart';
export 'src/tokens/type.dart';
