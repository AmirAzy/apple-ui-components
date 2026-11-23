# Changelog

All notable changes to this kit. Format follows Keep a Changelog; versions
follow SemVer.

## [Unreleased]

### Changed

- **Screenshots:** retaken at higher detail from the live showcase — full
  sections with headings, live states and code snippets, at 2× resolution
  (island expanded, liquid glass, buttons/search/slider/tab bar, macOS
  window). Added a fifth shot, `ios-controls.png`, showing the switch and
  segmented control live; README and `docs/components.md` link to it.

## [1.1.0] — 2026-11-23

### Added

- **New web components:** iOS buttons (`.btn`: filled / tinted / plain /
  destructive, `.btn-sm` / `.btn-lg`), macOS push button (`.macbtn`),
  search field (`.search` with clear button), slider (`input.slider`),
  floating tab bar (`.tabbar` with badges), badge (`.badge`), toast
  (`.toast` + `[data-toast-show]`), large-title iOS nav bar (`.iosnav`).
- **`controls.js`:** `bootSearch()`, `bootSlider()`, `bootToast()`; all wired
  by `bootControls()`, which now returns `searches`, `sliders` and `toasts`.
- **Showcase:** new "Buttons, search, slider, tab bar" section in
  `web/showcase.html`; branding unified from "Aurora UI" to "Apple UI".
- **Docs:** `docs/components.md` component catalogue, `CONTRIBUTING.md`,
  real screenshots in `docs/screenshots/` taken from the actual components.
- **Token:** `--glass-blur` (28 px) is now a real variable in `tokens.css`
  and drives the glass panel and tab bar, instead of a hardcoded `28px`.

### Fixed

- `references/tokens.md` listed CSS variables that never existed
  (`--ios-card-r`, `--mac-win-r`, `--ease-spring`, …) and described the
  wrong font stacks and colour names. It now lists only variables that
  exist in `tokens.css`, and documents the two known drifts (web vs Flutter
  durations, `--r-ctrl` vs `controlRadius`).
- `LICENSES.md` mentioned a three.js vendor bundle and a GitHub Pages
  workflow that are not in the repo. Both claims removed.
- `flutter/apple_ui_kit/README.md` described a `demo-web/` build output and
  a `figma2flutter` tool that are not in the repo. Both sections corrected.
- `references/web.md` file map and line counts updated; the note about a
  missing `boot.js` clarified.
- Main `README.md` rewritten: correct component table, real token names,
  screenshots, structure map, contributing and changelog links.

### Tests

- `test/dom-check.mjs` now covers the new components: button styles,
  search clear, slider fill, tab bar items and badge, nav-bar title, toast.

## [1.0.0] — 2026-11-22

- Initial public version: five-state Dynamic Island, liquid glass, iOS 27
  switch and segmented control, macOS Big Sur window, motion utilities,
  one token scale shared with the Flutter package (21 exports, 14 tests).
