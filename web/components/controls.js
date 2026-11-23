/**
 * Behaviour for the DOM controls: the iOS switch and segmented control,
 * plus the search field, slider and toast added in v1.1.
 *
 * The styles live in components.css; this file is the small amount of JS
 * that makes them interactive, so a page that links the CSS gets working
 * controls instead of dead markup.
 *
 *   import { bootControls } from './controls.js';
 *   bootControls();                       // every .sw, .seg, .search, .slider on the page
 *
 * Switch contract:  <div class="sw" role="switch" aria-checked="false" tabindex="0">
 * Segmented:        <div class="seg" role="tablist"><span class="thumb"></span>
 *                     <button role="tab" aria-selected="true">All</button>…</div>
 * Search:           <div class="search"><input><button class="s-clear">✕</button></div>
 * Slider:           <input type="range" class="slider" min="0" max="100" value="50">
 * Toast:            <div class="toast" data-toast>…</div> + [data-toast-show]
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
  if (!scope) return { switches: [], segmented: [], searches: [], sliders: [], toasts: [] };
  return {
    switches: [...scope.querySelectorAll('.sw')].map((el) => bootSwitch(el)),
    segmented: [...scope.querySelectorAll('.seg')].map((el) => bootSegmented(el)).filter(Boolean),
    searches: [...scope.querySelectorAll('.search')].map((el) => bootSearch(el)).filter(Boolean),
    sliders: [...scope.querySelectorAll('input.slider[type="range"]')].map((el) => bootSlider(el)),
    toasts: bootToast(scope),
  };
}

/**
 * Search field: shows the clear button while there is text, clears on click.
 * Markup: <div class="search"><span class="s-ico">⌕</span><input …>
 *           <button class="s-clear" aria-label="Clear search">✕</button></div>
 */
export function bootSearch(el, { onChange } = {}) {
  const input = el.querySelector('input');
  const clear = el.querySelector('.s-clear');
  if (!input) return null;
  const sync = () => {
    el.classList.toggle('has-value', input.value.length > 0);
    if (onChange) onChange(input.value);
  };
  input.addEventListener('input', sync);
  if (clear) {
    clear.addEventListener('click', () => {
      input.value = '';
      sync();
      input.focus();
    });
  }
  sync();
  return {
    get value() { return input.value; },
    set value(v) { input.value = v; sync(); },
    clear: () => { input.value = ''; sync(); },
  };
}

/**
 * Slider: keeps the --fill gradient in step with the value.
 * Markup: <input type="range" class="slider" min="0" max="100" value="50">
 */
export function bootSlider(el, { onChange } = {}) {
  const sync = () => {
    const min = Number(el.min || 0);
    const max = Number(el.max || 100);
    const pct = max > min ? ((Number(el.value) - min) / (max - min)) * 100 : 0;
    el.style.setProperty('--fill', `${pct.toFixed(1)}%`);
    if (onChange) onChange(Number(el.value));
  };
  el.addEventListener('input', sync);
  sync();
  return {
    get value() { return Number(el.value); },
    set value(v) { el.value = String(v); sync(); },
  };
}

/**
 * Toast: one toast element per page, shown by [data-toast-show] buttons.
 * Markup: <div class="toast" data-toast role="status"><span class="t-ico">✦</span><span data-toast-text></span></div>
 *         <button data-toast-show data-toast-message="Saved">Save</button>
 * Returns a show(message) function so pages can also trigger it by hand.
 */
export function bootToast(root = null) {
  const scope = root || (typeof document !== 'undefined' ? document : null);
  if (!scope) return () => {};
  const el = scope.querySelector ? scope.querySelector('.toast[data-toast]') : null;
  if (!el) return () => {};
  const textEl = el.querySelector('[data-toast-text]');
  let timer = null;
  const show = (message, duration = 2600) => {
    if (textEl && message) textEl.textContent = message;
    el.classList.add('show');
    clearTimeout(timer);
    timer = setTimeout(() => el.classList.remove('show'), duration);
  };
  for (const button of scope.querySelectorAll('[data-toast-show]')) {
    button.addEventListener('click', () => show(button.dataset.toastMessage || 'Done'));
  }
  return show;
}
