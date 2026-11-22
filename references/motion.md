# Motion — the 60fps rules

Condensed from 60fps.design and enforced throughout the components.

## Tokens

| token | value | where |
|---|---|---|
| `--t-fast` | 180 ms | hover, toggles, thumb slides |
| `--t-base` | 260 ms | cross-fades, colour changes |
| `--t-slow` | 420 ms | arrivals, reveals |
| `--t-slower` | 560 ms | island size, sheet-like surfaces |
| `--spring` | `cubic-bezier(.34, 1.42, .64, 1)` | anything that arrives |
| `--ease-out` | `cubic-bezier(.22, .61, .36, 1)` | anything that leaves |
| stagger | 45 ms, cap 8 items | lists, cards |

Springs overshoot: they are for *arrivals* (a card, a state). For dismissals and
colour use ease-out, or the element looks like it bounces off the screen edge.

## What may animate

Only `transform` and `opacity`. They run on the compositor; everything else
(`width`, `top`, `background-position`, `box-shadow`, `filter`) can force layout
or paint per frame.

The three deliberate exceptions in this kit, each contained:

| exception | why it is safe |
|---|---|
| island `width/height` | one element, `contain: layout paint style`, nothing else depends on its size |
| `.bar-fill` **transform** scaleX | it is a transform, not a width — progress moves on the compositor |
| `border-radius` morph on the blob | paint-only on a 74 px element, no layout |

## Reveal on scroll

```js
const io = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } });
}, { rootMargin: '0px 0px -8% 0px', threshold: 0.12 });
```

```css
[data-reveal]{opacity:0;transform:translate3d(0,18px,0);
  transition:opacity 420ms var(--ease-out),transform 420ms var(--spring);
  transition-delay:calc(var(--d,0) * 45ms)}
[data-reveal].in{opacity:1;transform:none}
```

- The delay comes from `--d` set inline (`style="--d:2"`), so the stagger is
  visible in the markup, not hidden in JS.
- `unobserve` after the first hit: the animation is an entrance, not a loop.
- No `IntersectionObserver` (or reduced motion) → everything is simply visible.

## Pause the expensive things

```js
if (!visible || document.hidden) return;   // the 3D loop
```

- `IntersectionObserver` on the canvas, `document.hidden` for background tabs.
- Marquees pause on hover; a CSS `animation-play-state: paused` under
  `[data-motion="off"]` stops everything for users who ask for quiet.
- The page keeps a visible fps readout (bottom-left) during development — if it
  cannot hold 55+, something left the compositor.

## Reduced motion

`prefers-reduced-motion: reduce` collapses every duration to ~0, forces
`[data-reveal]` visible, skips the island intro and freezes the 3D scene on a
still frame. The `motion: on/off` pill does the same thing manually, so it can be
demonstrated on stage.

## Checklist for a new animated element

1. Is it `transform`/`opacity`? If not, can it be?
2. Does it need `will-change`? Only if it animates continuously — otherwise it
   costs memory for nothing.
3. Is it inside a scroller? Then it must not resize its parent.
4. Does it still make sense at 0 ms? If the layout breaks with animation off, the
   animation was hiding a layout bug.
5. Does it stop when off screen or hidden?
