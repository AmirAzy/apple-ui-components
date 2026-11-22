/**
 * Behaviour for the DOM controls: the iOS switch and the segmented control.
 *
 * The styles live in components.css; this file is the 40-odd lines that make
 * them interactive, so a page that links the CSS gets working controls instead
 * of dead markup.
 *
 *   import { bootControls } from './controls.js';
 *   bootControls();                       // every .sw and .seg on the page
 *
 * Switch contract:  <div class="sw" role="switch" aria-checked="false" tabindex="0">
 * Segmented:        <div class="seg" role="tablist"><span class="thumb"></span>
 *                     <button role="tab" aria-selected="true">All</button>…</div>
 *
 * Both are keyboard reachable: Enter and Space work, because a div is not a
 * button and pretending otherwise is how accessibility rots.
 */

export function bootSwitch(el, { onChange } = {}) {
  const set = (value) => {
    el.setAttribute('aria-checked', String(value));
    if (onChange) onChange(value);
  };
  const toggle = () => set(el.getAttribute('aria-checked') !== 'true');

  el.setAttribute('role', el.getAttribute('role') || 'switch');
  el.setAttribute('tabindex', el.getAttribute('tabindex') || '0');
  if (!el.hasAttribute('aria-checked')) el.setAttribute('aria-checked', 'false');

  el.addEventListener('click', toggle);
  el.addEventListener('keydown', (event) => {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      toggle();
    }
  });

  return { get value() { return el.getAttribute('aria-checked') === 'true'; }, set, toggle };
}

export function bootSegmented(el, { onChange } = {}) {
  const thumb = el.querySelector('.thumb');
  const tabs = [...el.querySelectorAll('[role="tab"], button')];
  if (!thumb || tabs.length === 0) return null;

  // The thumb is placed from measured geometry, not from a guessed 1/n width:
  // labels have different lengths and a wrong thumb is instantly visible.
  const place = (active) => {
    const target = active.getBoundingClientRect();
    const track = el.getBoundingClientRect();
    thumb.style.width = `${target.width}px`;
    thumb.style.transform = `translateX(${(target.left - track.left - 3).toFixed(1)}px)`;
  };

  const select = (tab, { notify = true } = {}) => {
    for (const other of tabs) other.setAttribute('aria-selected', String(other === tab));
    place(tab);
    if (notify && onChange) onChange(tabs.indexOf(tab), tab.textContent.trim());
  };

  for (const tab of tabs) {
    tab.addEventListener('click', () => select(tab));
    tab.addEventListener('keydown', (event) => {
      const index = tabs.indexOf(tab);
      const next = event.key === 'ArrowRight' ? index + 1 : event.key === 'ArrowLeft' ? index - 1 : null;
      if (next === null) return;
      event.preventDefault();
      const target = tabs[(next + tabs.length) % tabs.length];
      target.focus();
      select(target);
    });
  }

  const initial = tabs.find((t) => t.getAttribute('aria-selected') === 'true') || tabs[0];
  if (typeof requestAnimationFrame === 'function') {
    requestAnimationFrame(() => place(initial));
  }
  if (typeof window !== 'undefined') {
    window.addEventListener('resize', () => {
      const active = tabs.find((t) => t.getAttribute('aria-selected') === 'true');
      if (active) place(active);
    });
  }

  return {
    get value() {
      const active = tabs.find((t) => t.getAttribute('aria-selected') === 'true');
      return active ? tabs.indexOf(active) : 0;
    },
    select: (index) => select(tabs[index]),
  };
}

/** Upgrade every switch and segmented control inside `root`. */
export function bootControls(root = null) {
  const scope = root || (typeof document !== 'undefined' ? document : null);
  if (!scope) return { switches: [], segmented: [] };
  return {
    switches: [...scope.querySelectorAll('.sw')].map((el) => bootSwitch(el)),
    segmented: [...scope.querySelectorAll('.seg')].map((el) => bootSegmented(el)).filter(Boolean),
  };
}
