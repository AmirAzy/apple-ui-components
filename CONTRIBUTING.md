# Contributing

Short version: **one token scale, two platforms, tests before the commit.**

## Before you change anything

1. Read [`SKILL.md`](SKILL.md) and the relevant file in [`references/`](references/).
   The five rules in the README are the contract, not decoration.
2. Run the tests once, so you know what green looks like here:

```bash
npm install && npm test
cd flutter/apple_ui_kit && flutter analyze && flutter test
```

## Adding or changing a web component

- **CSS goes in `web/components/components.css`, behaviour in `controls.js`
  or `island.js`.** Nothing runs until the page calls `boot()` /
  `bootControls()` — do not add an auto-runner.
- **Sizes come from `tokens.css` or are documented as literals.**
  Do not invent a token name in a doc; add the variable first
  (`references/tokens.md` explains why).
- **Motion is `transform` + `opacity` only**, 180 / 260 / 420 / 560 ms.
  The island's own width/height is the one exception, and it is contained.
- **Accessibility is part of the component**, not a follow-up: keyboard
  reachable, ARIA state (`aria-checked`, `aria-selected`, `aria-pressed`),
  visible focus, and a reduced-motion path that keeps every state.
- **Add it to `web/showcase.html`** with its markup and a snippet, next to
  the other components. A component with no demo is a component nobody can
  try.
- **Extend `test/dom-check.mjs`** for the new behaviour (toggle, select,
  clear, show) and keep `npm test` green.
- **Re-take the screenshots** in `docs/screenshots/` and update
  [`docs/components.md`](docs/components.md) if the catalogue changes.

## Changing a token

Change the CSS variable **and** the Flutter constant in the same commit
(`AppleMetrics` / `AppleColorSet`), and update `references/tokens.md`.
If the two numbers cannot match yet, say so in that file — a documented
drift is fixable, a silent one is not.

## Changing a Flutter widget

- Keep the explicit `Brightness` parameter; do not fall back to `Theme`.
- Keep the widget free of Material dependencies.
- Add or update a widget test in `test/components_test.dart`.
- Update `flutter/apple_ui_kit/README.md` — the widget tables there are the
  map, and a widget missing from them is a widget nobody finds.

## Commits

Small, one-component commits, in Persian or English — whichever the change
is about, but keep the code and the docs in the same language as the file
you touched. Update [`CHANGELOG.md`](CHANGELOG.md) under `Unreleased`.
