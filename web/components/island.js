/**
 * Dynamic Island — the controller.
 *
 * Markup contract (see references/island-spec.md):
 *
 *   <div class="island" data-island data-state="idle">
 *     <div class="layer" data-for="idle">…</div>
 *     <div class="layer" data-for="compact">…</div>
 *     <div class="layer" data-for="expanded">…</div>
 *     <div class="layer" data-for="notif">…</div>
 *     <div class="layer" data-for="call">…</div>
 *   </div>
 *
 * Use it:
 *
 *   import { boot, DynamicIsland } from './island.js';
 *   boot();                                    // every [data-island] on the page
 *   const one = new DynamicIsland(el);         // or one by hand
 *   one.set('expanded');                       // programmatic
 *   one.on('change', ({ state }) => {});
 *
 * Islands with the same `data-island-group` share a state, so a docked pill and
 * the one inside a phone mock never disagree. State buttons are any element with
 * `[data-island-state="<state>"]`; they get `aria-pressed` for free.
 *
 * The controller only flips attributes. All motion lives in island.css, which is
 * what keeps a resize off the main thread's critical path: one element changes
 * size, five layers cross-fade with opacity and transform.
 */

export const ISLAND_STATES = ['idle', 'compact', 'expanded', 'notif', 'call'];

/** @type {Map<string, Set<DynamicIsland>>} */
const groups = new Map();

export class DynamicIsland {
  /**
   * @param {HTMLElement} el
   * @param {{initial?: string, group?: string, intro?: boolean, cycleOn?: 'click'|'none'}} [options]
   */
  constructor(el, options = {}) {
    this.el = el;
    this.group = options.group || el.dataset.islandGroup || 'default';
    this.cycleOn = options.cycleOn || 'click';
    this._listeners = new Set();
    this._touched = false;
    this._timers = [];
    this._state = 'idle';

    if (!groups.has(this.group)) groups.set(this.group, new Set());
    groups.get(this.group).add(this);

    this._state = ISLAND_STATES.includes(options.initial) ? options.initial : (el.dataset.state || 'idle');
    this.el.dataset.state = this._state;
    this.el.setAttribute('role', this.el.getAttribute('role') || 'button');
    this.el.setAttribute('tabindex', this.el.getAttribute('tabindex') || '0');

    this._onClick = (event) => {
      if (event.target.closest('.controls')) return; // transport buttons stay buttons
      this.cycle();
    };
    this._onKey = (event) => {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        this.cycle();
      }
    };

    if (this.cycleOn === 'click') {
      this.el.addEventListener('click', this._onClick);
      this.el.addEventListener('keydown', this._onKey);
    }

    this._syncStateButtons();
    if (options.intro) this.playIntro();
  }

  get state() {
    return this._state;
  }

  /** @param {string} state @param {{user?: boolean}} [meta] */
  set(state, meta = {}) {
    if (!ISLAND_STATES.includes(state) || state === this._state) {
      if (meta.user) this._touched = true;
      return this;
    }
    if (meta.user) {
      this._touched = true;
      this._cancelIntro();
    }
    this._state = state;
    this.el.dataset.state = state;
    for (const sibling of groups.get(this.group) || []) {
      sibling._state = state;
      sibling.el.dataset.state = state;
      sibling._syncStateButtons();
    }
    this._syncStateButtons();
    for (const listener of this._listeners) listener({ state, fromUser: Boolean(meta.user) });
    return this;
  }

  /** idle → compact → expanded → idle (the order a human expects). */
  cycle(order = ['compact', 'expanded', 'idle']) {
    const index = order.indexOf(this._state);
    this.set(order[index === -1 ? 0 : (index + 1) % order.length], { user: true });
    return this;
  }

  /** A one-shot demo: plays once, dies the moment someone touches it. */
  playIntro(timeline = [['compact', 900], ['expanded', 3400], ['idle', 5600]]) {
    // `window` is optional so the module can be unit-tested outside a browser.
    const reduce = typeof window !== 'undefined' &&
      window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (reduce) return this;
    for (const [state, delay] of timeline) {
      this._timers.push(setTimeout(() => {
        if (!this._touched) this.set(state);
      }, delay));
    }
    return this;
  }

  /** @param {(payload: {state: string, fromUser: boolean}) => void} listener */
  on(event, listener) {
    if (event === 'change') this._listeners.add(listener);
    return this;
  }

  destroy() {
    this._cancelIntro();
    this.el.removeEventListener('click', this._onClick);
    this.el.removeEventListener('keydown', this._onKey);
    this._listeners.clear();
    groups.get(this.group)?.delete(this);
  }

  _cancelIntro() {
    for (const id of this._timers) clearTimeout(id);
    this._timers = [];
  }

  _syncStateButtons() {
    // ownerDocument, not the global: keeps the component usable inside an
    // iframe, a shadow root, or a test runner.
    const buttons = this.el.ownerDocument.querySelectorAll('[data-island-state]');
    for (const button of buttons) {
      button.setAttribute('aria-pressed', String(button.dataset.islandState === this._state));
    }
  }
}

/**
 * Upgrade every `<div class="island" data-island>` on the page.
 *
 * @param {ParentNode} [root]
 * @param {{intro?: boolean}} [options]
 * @returns {DynamicIsland[]}
 */
export function boot(root = null, options = {}) {
  const scope = root || (typeof document !== 'undefined' ? document : null);
  if (!scope) return [];
  const instances = [];
  for (const el of scope.querySelectorAll('.island[data-island]')) {
    instances.push(new DynamicIsland(el, {
      group: el.dataset.islandGroup,
      initial: el.dataset.state,
      intro: options.intro ?? el.dataset.islandIntro === 'true',
      cycleOn: el.dataset.islandCycle === 'none' ? 'none' : 'click',
    }));
  }

  const doc = scope.querySelectorAll ? scope : (scope.ownerDocument || scope);

  // state buttons drive the whole group, and scrolling hands the pill back to idle
  for (const button of doc.querySelectorAll('[data-island-state]')) {
    button.addEventListener('click', () => {
      const state = button.dataset.islandState;
      for (const instance of instances) instance.set(state, { user: true });
    });
  }

  if (typeof window === 'undefined') return instances;

  let lastY = window.scrollY;
  window.addEventListener('scroll', () => {
    const y = window.scrollY;
    if (Math.abs(y - lastY) > 220) {
      for (const instance of instances) if (!instance._touched) instance.set('idle');
    }
    lastY = y;
  }, { passive: true });

  return instances;
}
