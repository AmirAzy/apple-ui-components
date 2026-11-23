# Tokens — one source of truth, two platforms

`web/components/tokens.css` is the source. `flutter/apple_ui_kit/lib/src/tokens/`
is the same table in Dart. Change a number in one place and change it in the other
in the same commit, or the two halves drift and nobody notices until a designer
puts the screenshots side by side.

> Honest note: this table lists only the variables that actually exist in
> `tokens.css`. Earlier versions of this file named variables (`--ios-card-r`,
> `--mac-win-r`, `--ease-spring`, …) that were never defined — the sizes lived
> as literals in `components.css`. Those names are gone from this doc; if a
> size needs a token, add it to `tokens.css` first, then list it here.

## The scale

| CSS variable | value | Flutter | used by |
|---|---|---|---|
| `--r-card` | 26 px | `AppleMetrics.cardRadius` | inset group, glass panel |
| `--r-sheet` | 34 px | `AppleMetrics.sheetRadius` | sheet, island expanded |
| `--r-ctrl` | 12 px | `AppleMetrics.controlRadius` (6 px) | small controls — see note |
| `--r-pill` | 999 px | — | pills, island, segmented |
| `--glass-blur` | 28 px | `AppleMetrics.glassBlur` | every glass pane |
| `--t-fast` | 180 ms | `AppleMetrics.fast` (160 ms) | switch, hover |
| `--t-base` | 260 ms | `AppleMetrics.normal` (260 ms) | island compact↔expanded |
| `--t-slow` | 420 ms | `AppleMetrics.sheet` (380 ms) | sheets, nav |
| `--t-slower` | 560 ms | — | island expanded→idle |
| `--spring` | `cubic-bezier(.34,1.42,.64,1)` | — | anything that "pops" |
| `--ease-out` | `cubic-bezier(.22,.61,.36,1)` | — | reveals |
| `--pad` | `clamp(20px,4.4vw,64px)` | — | section gutters |
| `--maxw` | 1180 px | — | content column |

Sizes that are still literals in `components.css` (no CSS variable yet), with
their Flutter counterpart: island 124×35 / 216×38 / 344×126 / 322×62 / 300×56,
switch 51×31 (`AppleMetrics.iosSwitchWidth/Height`, thumb 27), tab bar 56
(`iosTabBarHeight`), list row 52 (`iosRowHeight`), macOS window radius 10
(`windowRadius`), title bar 38 (`windowTitleBarHeight`), traffic lights 12
with an 8 px gap (`trafficLightSize/Gap`), macOS switch 38×22
(`macSwitchWidth/Height`).

**Known drift:** web durations (180 / 420 / 560 ms) and Flutter durations
(160 / 380 ms) do not match yet, and `--r-ctrl` (12 px) is not the same number
as Flutter's `controlRadius` (6 px). Both are listed here so the next pass can
align them instead of discovering them by eye.

## Island geometry (CSS-only, no token needed)

| state | size | radius |
|---|---|---|
| idle | 124 × 35 | pill |
| compact | 216 × 38 | pill |
| expanded | 344 × 126 | 34 |
| notif | 322 × 62 | 26 |
| call | 300 × 56 | pill |

Mobile (`≤760 px`): widths clamp to `min(…, var(--island-max, 100vw - 24px))`,
expanded height 138, cover art 52 px.

## Type

Three stacks, deliberately:

- `--fa` — Vazirmatn, for Persian / Arabic script. Persian is never in `--ui`.
- `--en` — Clash Display, for Latin display text.
- `--ui` — Satoshi, the interface face. Latin only.
- `--mono` — Azeret Mono, for code and token names.

Mixing scripts in a Latin face is the one visual bug this kit refuses to ship.

## Colour

Dark surface scale in `tokens.css`: `--ink` / `--ink-2` (backgrounds),
`--text` / `--text-dim` / `--text-faint`, `--line` / `--line-soft`,
`--glass` / `--glass-strong`, accents `--violet` / `--cyan` / `--lime` /
`--green` / `--pink`. Flutter mirrors it as `AppleColorSet.dark` / `.light`;
every widget takes the set it should use. No global mutable theme, no
`Theme.of(context)` lookups in the leaf widgets.
