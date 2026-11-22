---
name: apple-ui-components
description: A dependency-free component kit for building multiplatform apps — a five-state Dynamic Island, liquid-glass surfaces, iOS 27 controls (switch, segmented, sheet, list), a macOS 11 window, motion primitives and one token scale, shipped as web components (HTML/CSS/ES modules) and a matching Flutter package. Use when the user wants Apple-flavoured UI building blocks — glassmorphism, an island, macOS window chrome, iOS switches — in a web app, a Flutter app, or both at once, and wants them to stay pixel-consistent across platforms.
---

# Apple UI Components

Reusable components, one token file, two platforms. No dependencies, no build
step, no framework: the web half is three CSS files and two ES modules, the Flutter
half is 21 exported widgets that read the same numbers.

`web/showcase.html` is the demo — every component on one page, with the markup and
the API next to it. It is an example of the kit, not the kit.

## What is in here

| path | what it is |
|---|---|
| `web/components/tokens.css` | the whole design scale: colour, radii, durations, stacks |
| `web/components/components.css` | island, glass, iOS controls, macOS window, reveal |
| `web/components/fonts.css` | 13 `@font-face`, all local |
| `web/components/island.js` | `DynamicIsland` + `boot()` — the five-state machine |
| `web/components/controls.js` | `bootSwitch`, `bootSegmented`, `bootControls()` |
| `web/showcase.html` | the demo page (self-contained, Persian-safe fonts) |
| `flutter/apple_ui_kit/` | Flutter package: 21 exports (22 widget classes), `example/`, 14 tests |
| `references/island-spec.md` | five states, exact sizes, DOM contract, a11y |
| `references/glass.md` | liquid-glass recipe, cost, why it looked wrong at first |
| `references/motion.md` | 60fps rules: tokens, what may animate, stagger, pausing |
| `references/tokens.md` | CSS variable ↔ Flutter constant, one table |
| `references/web.md` | file map, sizing traps, verified numbers |
| `references/flutter.md` | widget map, install, rules, regressions already paid for |
| `references/checklist.md` | 18 checks before shipping |
| `assets/fonts-licensed/` | Vazirmatn (OFL 1.1) — committed, Persian-capable |
| `scripts/fetch-fonts.py` | pulls the Fontshare faces you may *use*, not redistribute |
| `test/dom-check.mjs` | headless assertions for island, controls, ids, tokens |

## Use it — web

```html
<link rel="stylesheet" href="components/fonts.css">
<link rel="stylesheet" href="components/tokens.css">
<link rel="stylesheet" href="components/components.css">

<div class="island" data-island data-state="idle" role="button" tabindex="0"
     aria-label="Now playing">
  <span class="layer" data-for="idle"><i class="dot"></i></span>
  <span class="layer" data-for="expanded">…</span>
  …
</div>

<script type="module">
  import { boot } from './components/island.js';
  import { bootControls } from './components/controls.js';
  boot();            // upgrades every [data-island], wires [data-island-state]
  bootControls();    // upgrades every .sw and .seg on the page
</script>
```

Serve over HTTP — `python3 -m http.server 8000` — because the JS is ES modules.

API: `new DynamicIsland(el, {initial, group, intro, cycleOn})`, then
`.set(state)`, `.cycle()`, `.playIntro()`, `.on('change', cb)`, `.destroy()`.
States: `idle · compact · expanded · notif · call`. Two islands with the same
`data-island-group` stay in sync.

## Use it — Flutter

```yaml
dependencies:
  apple_ui_kit: {path: ../flutter/apple_ui_kit}
```

```dart
IosListSection(header: 'Playback', children: <Widget>[
  IosListTile(title: 'Spatial audio', trailing: IosSwitch(value: v, onChanged: (b) => setState(...))),
])
```

`flutter analyze` and `flutter test` are part of the contract, not a suggestion.

## The five rules

1. **One token scale, two platforms.** Change `--ios-card-r` and change
   `AppleMetrics.cardRadius` in the same commit. `references/tokens.md` is the map.
2. **Motion is `transform` + `opacity` only** — 180 / 260 / 420 / 560 ms, spring
   `cubic-bezier(.34,1.42,.64,1)` for arrivals, 45 ms stagger capped at 8. The one
   exception is the island's own `width`/`height`, and it is
   `contain: layout paint style` so nothing else reflows.
3. **Glass needs something to blur.** A `backdrop-filter` pane over a near-black
   page is a grey card: put colour behind it (`.glass-stage`) and clip it
   (`overflow: hidden`, `ClipRRect` in Flutter).
4. **No component knows its container.** Sizes clamp against a variable the page
   can set (`--island-max`), not against `100vw` alone — a padded wrapper is the
   most common source of a 20 px horizontal scroll on a phone.
5. **Persian is never drawn in a Latin face.** `--ui` is Latin-only; Persian goes
   in `--fa` (Vazirmatn, OFL, committed). Same rule in Flutter:
   `fontFamilyFallback`, never a Latin family for Arabic script.

## Verify

```bash
npm install && npm test                       # jsdom: island, controls, ids, tokens
cd flutter/apple_ui_kit && flutter analyze && flutter test
```

Both are green as shipped (`test/dom-check.mjs`: 30 assertions; Flutter: 14 tests).

## Licensing

Code MIT. Vazirmatn OFL 1.1. The twelve Fontshare faces are *not* redistributable —
`scripts/fetch-fonts.py` downloads them for you and `.gitignore` keeps them out of
the repo. No Apple fonts, no Apple assets, no Apple screenshots. See
`LICENSES.md`.
