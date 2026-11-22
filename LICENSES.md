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
- `scripts/fetch-fonts.py` downloads them from Fontshare's own CDN at setup time,
- the GitHub Pages workflow fetches them into a transient build artifact only.

If you fork this repository, do the same: fetch, do not vendor.

## Code

**three.js r187** — `assets/vendor/three/three.module.js`, `three.core.js`.
MIT License, Copyright 2010-2026 three.js authors. Unmodified build from the
`three` npm package. https://github.com/mrdoob/three.js

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
`playwright-core` (Apache-2.0) is optional, for the real-browser capture pass.
