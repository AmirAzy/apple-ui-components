# Tokens — one source of truth, two platforms

`web/components/tokens.css` is the source. `flutter/apple_ui_kit/lib/src/tokens/`
is the same table in Dart. Change a number in one place and change it in the other
in the same commit, or the two halves drift and nobody notices until a designer
puts the screenshots side by side.

## The scale

| CSS variable | value | Flutter | used by |
|---|---|---|---|
| `--t-fast` | 180 ms | `AppleDuration.fast` | switch, hover |
| `--t-base` | 260 ms | `AppleDuration.base` | island compact↔expanded |
| `--t-slow` | 420 ms | `AppleDuration.slow` | sheets, nav |
| `--t-slower` | 560 ms | `AppleDuration.slower` | island expanded→idle |
| `--ease-spring` | `cubic-bezier(.34,1.42,.64,1)` | `AppleCurves.spring` | anything that "pops" |
| `--ease-out` | `cubic-bezier(.22,.61,.36,1)` | `AppleCurves.out` | reveals |
| `--stagger` | 45 ms | `AppleDuration.stagger` | list reveals, capped at 8 |
| `--mac-win-r` | 10 px | `MacMetrics.windowRadius` | window |
| `--mac-bar-h` | 38 px | `MacMetrics.titleBar` | title bar |
| `--mac-dot` / `--mac-dot-gap` | 12 / 8 px | `MacMetrics.traffic` / `.trafficGap` | traffic lights |
| `--ios-card-r` | 26 px | `AppleMetrics.cardRadius` | inset group |
| `--ios-sheet-r` | 34 px | `AppleMetrics.sheetRadius` | sheet, island expanded |
| `--ios-sw-w` / `--ios-sw-h` | 51 × 31 | `AppleMetrics.switchWidth` / `.switchHeight` | switch |
| `--ios-tab-h` | 56 px | `AppleMetrics.tabBarHeight` | tab bar |
| `--ios-row-h` | 52 px | `AppleMetrics.rowHeight` | list row |
| `--glass-blur` | 28 px | `AppleMetrics.glassBlur` | every glass pane |
| `--pad` | `clamp(20px,4.4vw,64px)` | `AppleMetrics.gutter(context)` | section gutters |
| `--maxw` | 1180 px | `AppleMetrics.maxWidth` | content column |

## Island geometry (CSS-only, no token needed)

| state | size | radius |
|---|---|---|
| idle | 124 × 35 | 30 |
| compact | 216 × 38 | 30 |
| expanded | 344 × 126 | 34 |
| notif | 322 × 62 | 26 |
| call | 300 × 56 | 26 |

Mobile (`≤760 px`): widths clamp to `min(…, var(--island-max, 100vw - 24px))`,
expanded height 138, cover art 52 px.

## Type

Two stacks, deliberately:

- `--ui` — the interface face: Clash Display → system UI. Latin only.
- `--mono` — JetBrains-style mono for code and token names.
- Persian is never in `--ui`: it goes in `--fa` (Vazirmatn, OFL, committed at
  `assets/fonts-licensed/`). Mixing scripts in a Latin face is the one visual bug
  this kit refuses to ship.

## Colour

Dark surface scale in `tokens.css` (`--bg`, `--bg-2`, `--fg`, `--fg-2`, `--fg-3`,
`--line`, `--accent`). Flutter mirrors it as `AppleColorSet.dark` / `.light`; every
widget takes the set it should use. No global mutable theme, no `Theme.of(context)`
lookups in the leaf widgets.
