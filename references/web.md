# Web components — how the layer is organised

Four files, in the order you link them:

```html
<link rel="stylesheet" href="components/fonts.css">     <!-- 13 @font-face, all local -->
<link rel="stylesheet" href="components/tokens.css">    <!-- the design scale -->
<link rel="stylesheet" href="components/components.css"> <!-- the components -->
```

There is no `boot.js`: call `boot()` and `bootControls()` yourself, or copy
those two lines from `showcase.html`. Explicit is better than a magic
auto-runner. (Earlier versions of this file said "Four files" and listed a
`boot.js` in the snippet — the snippet was aspirational; the code never had
one.)

## What is in each file

| file | contents | lines |
|---|---|---|
| `tokens.css` | `:root` scale — colour, radii, durations, font stacks, `box-sizing` reset, focus ring | 59 |
| `fonts.css` | 13 `@font-face` rules pointing at `../../assets/fonts*/` | 111 |
| `components.css` | island, glass, iOS switch + segmented, buttons, search, slider, tab bar, badge, toast, macOS window, reveal utility | ~400 |
| `island.js` | `DynamicIsland`, `boot()` — the five-state machine | 196 |
| `controls.js` | `bootSwitch`, `bootSegmented`, `bootSearch`, `bootSlider`, `bootToast`, `bootControls()` | 183 |

No dependencies, no build step, no CSS-in-JS. The JS is two ES modules with named
exports; nothing runs until you call `boot()` / `bootControls()`.

## The components

| selector | what it is | JS needed? |
|---|---|---|
| `.island` + `.layer[data-for]` | five-state dynamic island | yes — `boot()` |
| `.island-dock` | a fixed, centred wrapper for the pill | no |
| `.glass-stage` + `.glass-panel` | liquid glass with a colour bed | no |
| `.glass-row` | a 52 px settings row inside a panel | no |
| `.sw` | iOS 27 switch, 51 × 31 | yes — `bootControls()` |
| `.seg` + `.thumb` | segmented control with a measured thumb | yes |
| `.btn` (+ `-filled` / `-tinted` / `-plain` / `-destructive`, `-sm` / `-lg`) | iOS buttons, 44 tall | no |
| `.macbtn` | macOS push button, 24 tall | no |
| `.search` + `.s-clear` | search field, 36 tall | yes — clear button |
| `input.slider` | slider, 28 px thumb, `--fill` gradient | yes — fill sync |
| `.tabbar` + `.tabbar-item` | floating tab bar, 56 tall | no |
| `.badge` | numeric / dot badge | no |
| `.toast` + `[data-toast-show]` | bottom-centre toast, auto-hides | yes |
| `.iosnav` | large-title nav bar | no |
| `.macwin` + `.macbar` / `.macsidebar` / `.macrow` | macOS 11 window chrome | no |
| `[data-reveal]` + `--d` | reveal on scroll with a 45 ms stagger | IO observer, ~10 lines |

## Sizing rules that keep it honest

- The island's mobile clamp is `var(--island-max, calc(100vw - 24px))`. A component
  cannot know its container's padding, so a page with gutters should set
  `--island-max` on the wrapper — the showcase does exactly that at ≤560 px.
- `.seg` places its thumb from `getBoundingClientRect()`, not from `1 / n`: labels
  have different widths and a guessed thumb is visible at a glance.
- `.macwin` sets `direction: ltr` internally. A macOS window is LTR even on an RTL
  page; inheriting the page direction flips the traffic lights and the sidebar.

## Verified

Chromium (headless, 1440 × 950 and 390 × 844), served over HTTP:

| check | desktop | mobile |
|---|---|---|
| horizontal overflow | 0 px | 0 px |
| island expanded size | 344 × 126 | 314 × 138 (clamped) |
| fonts loaded | Vazirmatn ✓ Clash Display ✓ | ✓ |
| console errors | none | none |
| failed requests | none | none |

Plus `npm test` (jsdom): island state machine and group sync, switch, segmented
control, unique ids, anchors resolve, tokens present, no third-party assets.

## Integrating with a framework

The components are attribute-driven, so they drop into React/Vue/Svelte without a
wrapper library:

```jsx
useEffect(() => { const i = new DynamicIsland(ref.current); return () => i.destroy(); }, []);
```

Two rules when you wrap them: keep `data-state` as the source of truth (do not
mirror it in local state), and call `destroy()` on unmount or the group keeps a
dead instance and steals state updates.

## Known limits

- `backdrop-filter` is not free: one or two panes per screen, never per row.
- The island assumes a dark page; on a light background it still works, but the
  hairline (`rgba(255,255,255,.09)`) needs re-theming.
- `fonts.css` points at Fontshare files that are not in the repo — run
  `python3 scripts/fetch-fonts.py` once, or accept system fallbacks.
