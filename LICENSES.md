# Third-party notices

## Fonts

**Vazirmatn** — `assets/fonts-licensed/vazirmatn-var.woff2`
SIL Open Font License 1.1. Full text in `assets/fonts-licensed/OFL.txt`.
Copyright 2015 The Vazirmatn Project Authors (https://github.com/rastikerdar/vazirmatn).
Committed here because the OFL permits redistribution.

**Fontshare families** — Clash Display, Satoshi, Azeret Mono, Cabinet Grotesk,
Boska, Gambetta, Zodiak, General Sans, Bespoke Sans, Melodrama, Sentient, Tanker.
ITF Free Font Licence (https://www.fontshare.com/licenses/itf-ffl): free for
commercial use, **redistribution of the font files is not permitted**. Therefore:

- no Fontshare binary is committed (`assets/fonts/` is gitignored),
- `scripts/fetch-fonts.py` downloads them from Fontshare's own CDN at setup time.

If you fork this repository, do the same: fetch, do not vendor.

## Design references

The page follows the public design language of macOS 11 Big Sur and iOS 27.
No Apple asset, font, SF Symbol or Figma layer is included; the reproduction is
an independent CSS/JS implementation.

- macOS Big Sur UI Kit by **UI8** — Figma Community, CC BY 4.0 (attribution).
  https://www.figma.com/community/file/949158727443209284/macos-big-sur-ui-kit
- iOS and iPadOS 27 by **Apple** — Figma Community, used as a design reference
  only. https://www.figma.com/community/file/1651309003795292092/ios-and-ipados-27
- Motion rules distilled from **60fps.design**.

## Test tooling (not vendored)

`test/dom-check.mjs` imports **jsdom** (MIT) at runtime; install it yourself.
Screenshots in `docs/screenshots/` are taken with **Playwright** (Apache-2.0)
driving a headless Chromium; it is a local capture tool, not a dependency of
the kit.
