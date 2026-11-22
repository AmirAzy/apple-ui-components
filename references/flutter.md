# Flutter kit — the native half

`flutter/apple_ui_kit` is the same design language as widgets, with the same
numbers as `tokens.css`. 21 widgets, no Material dependency, explicit `brightness`.

## Layout

```
flutter/apple_ui_kit/
├── lib/apple_ui_kit.dart          # barrel, 21 exports
├── lib/src/tokens/                # colors.dart · metrics.dart · type.dart
├── lib/src/macos/                 # window, toolbar, sidebar, button,
│                                  # segmented_control, switch, slider,
│                                  # search_field, list_row
├── lib/src/ios/                   # glass, nav_bar, tab_bar, list, switch,
│                                  # segmented_control, button, search_field, sheet
├── example/                       # one screen: Big Sur window + iOS 27 phone
└── test/                          # 14 widget tests
```

## Install

```yaml
dependencies:
  apple_ui_kit:
    path: ../flutter/apple_ui_kit
```

```dart
import 'package:apple_ui_kit/apple_ui_kit.dart';

IosListSection(
  header: 'Playback',
  children: <Widget>[
    IosListTile(
      title: 'Spatial audio',
      leadingIcon: Icons.graphic_eq,
      trailing: IosSwitch(value: true, onChanged: (bool v) {}),
    ),
  ],
)
```

## Component map

| Web (`components.css`) | Flutter | notes |
|---|---|---|
| `.island` | — | the island is web-only for now; `IosNavBar` + `IosTabBar` cover the native chrome |
| `.glass-panel` / `.glass-stage` | `IosGlass` | `BackdropFilter(28)` + tint + 0.5 hairline, always clipped |
| `.glass-row` | `IosListTile` inside `IosListSection` | row min 52, inset group 16 |
| `.sw` 51 × 31 | `IosSwitch` | thumb 27, `activeColor` default `#34C759` |
| `.seg` | `IosSegmentedControl` | measured widths when unbounded |
| `.macwin` | `MacWindow` | title bar 38, traffic lights 12 / gap 8, radius 10 |
| `.macsidebar` | `MacSidebar` + `MacSidebarItem` | sections, badges, hover, selection |
| `.macrow` | `MacListRow` | 28 row, subtitle, disclosure |
| — (no web twin yet) | `MacToolbar`, `MacButton`, `MacSlider`, `MacSearchField`, `IosButton`, `IosNavBar`, `IosTabBar`, `IosSheet`, `IosSearchField` | all token-driven |

## The three rules the widgets follow

1. **No theme dependence.** Every widget that cares takes `Brightness` explicitly,
   so it works inside any app shell, in either appearance.
2. **Tokens only.** Radii, sizes, durations and colours come from `AppleMetrics`,
   `AppleColorSet`, `AppleType`. A hard-coded hex in a widget is a bug.
3. **Explicit props over inherited state.** A widget's behaviour is visible in its
   constructor, not in an ancestor.

## Fonts

SF Pro is not bundled (licence). `AppleType` sets sizes, weights and tracking and
leaves `fontFamilyFallback` at
`SF Pro Text → SF Pro Display → -apple-system → Segoe UI → Roboto`, so Apple
platforms get the real font and everything else degrades sanely. For Persian text
use your own face (the web demo uses Vazirmatn, OFL) — never let a Latin face shape
Arabic script.

## Verified

```
flutter analyze   → No issues found!
flutter test      → 14 tests, all passed
flutter build web → built (demo-web/, canvaskit served locally)
```

The 14 tests cover: window + traffic-light indices, switch toggles in both
languages of design, segmented selection, slider drag, every component in both
brightness values, sheet dismiss on flick, and the full example screen at
1500 × 1000.

## Regressions already paid for here

- `Expanded` inside a `Row` with unbounded width throws — measure segment widths
  with `TextPainter` instead (the same bug as `.seg` on the web).
- `BoxDecoration.border` adds to the box: `width: total + 4` with a 0.5 border
  loses a pixel and overflows by exactly one.
- An unclipped `BackdropFilter` blurs the entire layer behind it: `IosGlass` is
  always inside a `ClipRRect`.
