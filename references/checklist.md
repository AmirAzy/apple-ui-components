# Pre-ship checklist

Eighteen checks. Nine of them exist because this kit shipped with the bug once.

## Structure

1. **Every `id` is unique.** A widget `id="island"` next to a section
   `id="island"` breaks anchor scrolling and `scrollIntoView` quietly — the pill
   is fixed, so it "scrolls" nowhere. `npm test` asserts this.
2. **Every in-page anchor has a target.** No `href="#foo"` without `id="foo"`.
3. **The island is not inside a scrolling container.** It is fixed; a transformed
   ancestor would make it scroll with the content.
4. **One `h1`.** Sections use `h2`, cards use `h3`.

## Layout

5. **No horizontal overflow at 390 / 768 / 1440 px.**
   `document.documentElement.scrollWidth - clientWidth === 0`.
6. **Fixed chrome has a scrim.** Scrolling content must not read through the
   translucent nav.
7. **The island clears the nav.** `islandDock.top >= nav.bottom` — 74 vs 58 px
   in this build; assert it, do not eyeball it.
8. **Sizes clamp, not scale.** Expanded states use
   `min(344px, calc(100vw - 24px))`; never let a phone clip the island.
9. **Borders are part of the box.** `width: total + 4` with a 0.5 px border
   overflows by exactly 1 px. Let the container measure itself.

## Motion

10. **Only `transform` / `opacity` animate.** The three allowed exceptions are
    documented in `motion.md`.
11. **The fps readout holds 55+** while scrolling the whole page.
12. **`prefers-reduced-motion: reduce`** leaves nothing invisible: reveals show,
    the island still changes state instantly, the 3D scene freezes on a frame.
13. **The scripted intro stops** the moment a human touches the island.
14. **Off-screen work stops**: the WebGL loop returns early when the canvas is
    out of view or the tab is hidden.

## Content and type

15. **Persian renders in an Arabic-script face**, not a Latin fallback. Check a
    device without Vazirmatn installed — the stack must still land on a system
    Arabic font.
16. **Latin names inside Persian sentences do not break mid-word** (`.en` /
    `.ui` / `.mono` with `unicode-bidi: isolate`).
17. **No external asset URLs.** Fonts self-hosted, no CDN, favicon a data URI. `grep -E 'https?://|@import' web/components/*.css web/*.html` must be empty.
18. **Licences are respected.** Fontshare files are fetched, never committed
    (`assets/fonts/` is gitignored); Vazirmatn ships with `OFL.txt`; SF Pro is
    never bundled — only named in `fontFamilyFallback`.

## How to run the automated part

```bash
npm install                 # jsdom
npm test                    # web components

cd flutter/apple_ui_kit
flutter analyze && flutter test   # 14 widget tests
```

The browser pass (overflow at 390 / 768 / 1440 px, font loading, 404s) is a
Playwright script in the workspace history; the numbers it produced are quoted in
`references/web.md`.

## Manual pass (5 minutes)

- Click the island: compact → expanded → idle.
- Press Tab to the island, then Enter and Space.
- Toggle `motion: off`, scroll the whole page, confirm nothing animates.
- Scroll to the 3D section, then scroll away and watch the fps readout recover.
- Rotate to landscape on a phone; the expanded island must still fit.
