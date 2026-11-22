# Liquid glass — recipe and cost

The iOS 27 material, done in CSS without WebGL.

## The recipe

```css
.glass-panel{
  background: rgba(255,255,255,.07);
  border: 1px solid rgba(255,255,255,.16);
  backdrop-filter: blur(28px) saturate(1.5);
  -webkit-backdrop-filter: blur(28px) saturate(1.5);
  box-shadow: 0 24px 60px -24px rgba(0,0,0,.85),
              inset 0 1px 0 rgba(255,255,255,.35);
  border-radius: 34px;
  overflow: hidden;            /* non-negotiable */
}
.glass-panel::before{          /* the sheen */
  content:"";position:absolute;inset:0;border-radius:inherit;pointer-events:none;
  background:linear-gradient(160deg,rgba(255,255,255,.22),transparent 46%);
  opacity:.5;
}
```

Four parts, each doing a job:

| part | job |
|---|---|
| `blur(28) saturate(1.5)` | the material itself; saturation stops it going grey |
| white 7 % fill | gives the pane a body even where nothing is behind it |
| 1 px 16 % stroke + inset highlight | the lit edge that reads as "glass" |
| gradient sheen | the diagonal reflection that sells it as a surface |

## Rule: glass needs something to blur

The first version of the panel sat on a near-black page and looked like a plain
dark card — because `backdrop-filter` had almost nothing to work with. Fix: a
colour bed *behind* the pane.

```css
.glass-stage{
  padding: 6px; border-radius: calc(var(--r-sheet) + 6px); overflow: hidden;
  background:
    radial-gradient(62% 74% at 18% 12%, rgba(124,58,237,.95), transparent 62%),
    radial-gradient(58% 66% at 88% 84%, rgba(34,211,238,.8), transparent 64%),
    radial-gradient(50% 50% at 62% 42%, rgba(244,114,182,.55), transparent 70%),
    #0b0b12;
}
```

Pure black behind a blur is a grey box. Colour behind it is the whole effect.

## Cost

`backdrop-filter` is a per-frame GPU read of everything underneath:

- one or two panes per screen: fine.
- a glass card per row of a long list: death by a thousand blurs — iOS 27's own
  kit warns that glass on buttons, tab bars and search fields is heavy in
  prototypes. Use a solid fill for repeated rows.
- Do not stack glass on glass. Two blurred layers over each other look muddy and
  cost double.

`overflow: hidden` is not cosmetic: an unclipped backdrop filter samples the
whole layer behind it, so the cost scales with the page, not with the pane.

## Fallbacks

```css
@supports not (backdrop-filter: blur(1px)) {
  .glass-panel, .island { background: rgba(22,22,26,.92); }
}
```

The page keeps reading as a surface without the blur; it just loses the effect.
Everything else (borders, sheen, radius) is plain CSS and always works.

## In Flutter

The Flutter kit ships the same recipe as `IosGlass`:
`BackdropFilter(ImageFilter.blur(sigmaX: 28, sigmaY: 28))` inside a `ClipRRect`,
a vertical gradient tint, a 0.5 px hairline border, and
`AppleMetrics.glassBlur = 28`, `cardRadius = 26`, `sheetRadius = 34`.
See `references/flutter.md`.
