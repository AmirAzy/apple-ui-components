# Dynamic Island — state spec

Five states, one element, no layout thrash. This is the contract `web/components/island.js`, the CSS and
`test/dom-check.mjs` all rely on.

## Sizes

| state | width | height | radius | contents |
|---|---|---|---|---|
| `idle` | 124 | 35 | pill | status dot + mono label (`READY`) |
| `compact` | 216 | 38 | pill | 5-bar waveform + title/subtitle |
| `expanded` | 344 | 126 | 38 | cover 64², progress track, 3 transport buttons, EQ |
| `notif` | 322 | 62 | 26 | 30² icon + bold title + one grey line |
| `call` | 300 | 56 | pill | avatar 28² + name + accept/decline 26² |

Mobile (≤760 px), the states clamp instead of scaling:

```css
.island[data-state="expanded"]{--w:min(344px,calc(100vw - 24px));--h:132px;--r:34px}
.island[data-state="notif"],.island[data-state="call"]{--w:min(322px,calc(100vw - 24px))}
.island[data-state="compact"]{--w:min(216px,calc(100vw - 40px))}
```

## DOM contract

```html
<div class="island" data-island data-island-group="dock" data-state="idle">
  <div class="layer" data-for="idle">…</div>
  <div class="layer" data-for="compact">…</div>
  <div class="layer" data-for="expanded">…</div>
  <div class="layer" data-for="notif">…</div>
  <div class="layer" data-for="call">…</div>
</div>
```

- `data-state` on the wrapper is the single source of truth. CSS derives size
  from it; `island.js` only flips the attribute.
- `data-island` opts the element in to `boot()`. `data-island-group` keeps two
  instances (a docked pill, one inside a phone mock) in sync.
- Every layer exists in the DOM at all times. Visibility is:

  ```css
  .island .layer{position:absolute;inset:0;opacity:0;transform:scale(.92);
    transition:opacity 260ms ease-out,transform 260ms spring}
  .island[data-state="expanded"] .layer[data-for="expanded"]{opacity:1;transform:none}
  ```

  Cross-fading beats mounting/unmounting: no reflow, no font re-shaping, no flash.

## Animation

```css
.island{
  contain:layout paint style;
  transition:width 560ms var(--spring), height 560ms var(--spring),
             border-radius 260ms var(--ease-out);
  will-change:width,height;
}
```

560 ms spring for the size, 260 ms for the inner cross-fade, so content arrives
just after the shape settles. `contain` keeps the resize from invalidating the
rest of the page.

## Controller (12 lines of state)

```js
const states = ['idle','compact','expanded','notif','call'];
function setState(next, fromUser) {
  islands.forEach(el => el.dataset.state = next);   // dock + phone mock stay in sync
  buttons.forEach(b => b.setAttribute('aria-pressed', String(b.dataset.islandState === next)));
  if (fromUser) touched = true;
}
```

Rules that matter more than the code:

1. **One machine, many instances.** The docked pill and the one in the phone mock
   share `data-state`; a spec sheet that lies about the demo is worse than none.
2. **A scripted intro is polite.** It plays compact → expanded → idle once
   (900 / 3400 / 5600 ms) and stops permanently the moment the visitor touches
   anything (`touched` flag).
3. **Click / Enter / Space cycle** `compact → expanded → idle`. Transport buttons
   inside the docked pill are `tabindex="-1"` because the pill itself is the
   focusable control — no nested interactive elements.
4. **Scrolling hands it back.** More than 220 px of scroll returns it to `idle`
   so the pill never floats over content as an expanded panel.
5. **Reduced motion skips the intro** and disables the size transition; the pill
   still changes state instantly.

## Accessibility

- `role="button"`, `tabindex="0"`, `aria-label` describing the action, and
  `aria-pressed` on the external state buttons.
- Decorative layers (`waveform`, `EQ`, cover art) are `aria-hidden="true"`.
- Text inside the island is real text: selectable, screen-readable, translatable.
- Never trap focus, never autoplay audio, never loop the waveform when
  `prefers-reduced-motion: reduce`.
