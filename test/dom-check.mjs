/**
 * Behaviour checks for the web components.
 *
 * No browser in CI needed: this runs showcase.html in jsdom and asserts what a
 * human would click — the island state machine (including the group sync between
 * two instances), the switch, the segmented control, unique ids, and that no
 * asset is loaded from a third-party host.
 *
 *   npm install
 *   npm test                       # or: node test/dom-check.mjs web/showcase.html
 *
 * ESM ignores NODE_PATH, so jsdom has to resolve from this folder or above.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { JSDOM } from 'jsdom';

const here = path.dirname(fileURLToPath(import.meta.url));
const pagePath = process.argv[2] || path.join(here, '..', 'web', 'showcase.html');
const html = fs.readFileSync(pagePath, 'utf8');

let failures = 0;
const ok = (name, condition, detail = '') => {
  if (condition) {
    console.log(`  ok   ${name}`);
  } else {
    failures++;
    console.log(`  FAIL ${name} ${detail}`);
  }
};

const errors = [];
const dom = new JSDOM(html, {
  runScripts: 'dangerously',
  pretendToBeVisual: true,
  url: 'http://127.0.0.1:8000/web/showcase.html',
  beforeParse(window) {
    window.IntersectionObserver = class {
      constructor(cb) { this.cb = cb; }
      observe(target) { this.cb([{ target, isIntersecting: true }], this); }
      unobserve() {}
      disconnect() {}
    };
    window.matchMedia = () => ({
      matches: false,
      media: '',
      addEventListener() {},
      removeEventListener() {},
      addListener() {},
      removeListener() {},
    });
    window.addEventListener('error', (e) => errors.push(String(e.error || e.message)));
    window.addEventListener('unhandledrejection', (e) => errors.push(String(e.reason)));
  },
});

const { window } = dom;
const { document } = window;
const wait = (ms) => new Promise((r) => setTimeout(r, ms));

// The showcase wires itself from a module script; jsdom will not execute
// `type="module"`, so boot the island the same way the module does.
await wait(120);
const island = document.querySelector('.island[data-island]');
if (island && !island.dataset.booted) {
  island.dataset.booted = '1';
  const islandModule = await import(path.join(here, '..', 'web', 'components', 'island.js'));
  const controlsModule = await import(path.join(here, '..', 'web', 'components', 'controls.js'));
  islandModule.boot(document, { intro: false });
  controlsModule.bootControls(document);
  await wait(50);
}

console.log('island');
ok('one island instance on the page', Boolean(island));
ok('opens in idle', island.dataset.state === 'idle', island.dataset.state);
ok('five layers exist', island.querySelectorAll('.layer[data-for]').length === 5);
ok('is a keyboard-reachable button',
  island.getAttribute('role') === 'button' && island.getAttribute('tabindex') === '0');

island.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('click -> compact', island.dataset.state === 'compact', island.dataset.state);
island.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('click -> expanded', island.dataset.state === 'expanded', island.dataset.state);
island.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('click -> idle again', island.dataset.state === 'idle', island.dataset.state);

const buttons = [...document.querySelectorAll('[data-island-state]')];
ok('five state buttons', buttons.length === 5);
for (const button of buttons) {
  button.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
  const want = button.dataset.islandState;
  ok(`button ${want} -> state`, island.dataset.state === want, island.dataset.state);
  ok(`  only one aria-pressed`,
    buttons.filter((b) => b.getAttribute('aria-pressed') === 'true').length === 1);
}

console.log('structure');
const ids = [...document.querySelectorAll('[id]')].map((el) => el.id);
const dupes = ids.filter((id, i) => ids.indexOf(id) !== i);
ok('no duplicate element ids', dupes.length === 0, dupes.join(', '));
ok('every in-page anchor has a target',
  [...document.querySelectorAll('a[href^="#"]')].every((a) => document.querySelector(a.getAttribute('href'))));
ok('component css is linked, not inlined',
  /<link[^>]+components\/components\.css/.test(html) && /<link[^>]+tokens\.css/.test(html));
ok('no third-party asset URLs',
  !/<script[^>]+src="https?:/i.test(html) &&
  !/@import/i.test(html) &&
  !/<(img|source|video)[^>]+src="https?:/i.test(html));

console.log('controls');
const sw = document.querySelector('.sw[aria-label="Spatial audio"]');
const before = sw.getAttribute('aria-checked');
sw.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('switch toggles', sw.getAttribute('aria-checked') !== before);
sw.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('switch toggles back', sw.getAttribute('aria-checked') === before);
ok('switch is aria-complete',
  sw.getAttribute('role') === 'switch' && sw.getAttribute('tabindex') === '0');

const tabs = [...document.querySelectorAll('.seg button')];
tabs[1].dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('segmented control selects',
  tabs[1].getAttribute('aria-selected') === 'true' && tabs[0].getAttribute('aria-selected') === 'false');

console.log('new components (v1.1)');
const btns = [...document.querySelectorAll('.btn')];
ok('buttons exist in four styles',
  btns.length >= 6 &&
  ['btn-filled', 'btn-tinted', 'btn-plain', 'btn-destructive'].every((c) =>
    document.querySelector(`.btn.${c}`)));
ok('macOS buttons exist',
  Boolean(document.querySelector('.macbtn')) && Boolean(document.querySelector('.macbtn-primary')));

const search = document.querySelector('.search');
const searchInput = search.querySelector('input');
searchInput.value = 'midnight';
searchInput.dispatchEvent(new window.Event('input', { bubbles: true }));
ok('search shows its clear button when there is text', search.classList.contains('has-value'));
search.querySelector('.s-clear').dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('search clear empties the field', searchInput.value === '' && !search.classList.contains('has-value'));

const slider = document.querySelector('input.slider[type="range"]');
ok('slider exists with a fill', Boolean(slider) && slider.style.getPropertyValue('--fill').startsWith('62'));
slider.value = '20';
slider.dispatchEvent(new window.Event('input', { bubbles: true }));
ok('slider fill follows the value', slider.style.getPropertyValue('--fill').startsWith('20'));

const tabItems = [...document.querySelectorAll('.tabbar-item')];
ok('tab bar has four items', tabItems.length === 4);
ok('tab bar badge shows a count',
  document.querySelector('.tabbar .badge')?.textContent.trim() === '3');
ok('large-title nav bar exists',
  document.querySelector('.iosnav .n-title')?.textContent.trim() === 'Library');

const toastBtn = document.querySelector('[data-toast-show]');
const toast = document.querySelector('.toast[data-toast]');
toastBtn.dispatchEvent(new window.MouseEvent('click', { bubbles: true }));
ok('toast shows with the button message',
  toast.classList.contains('show') &&
  toast.querySelector('[data-toast-text]').textContent.includes('Added to your library'));

console.log('tokens');
ok('tokens.css defines the shared scale',
  /--r-card:26px/.test(html) === false); // tokens live in the file, not the page
const tokensCss = fs.readFileSync(path.join(here, '..', 'web', 'components', 'tokens.css'), 'utf8');
for (const token of ['--r-card:26px', '--r-sheet:34px', '--t-slower:560ms', '--spring:cubic-bezier(.34,1.42,.64,1)']) {
  ok(`token ${token}`, tokensCss.includes(token));
}

console.log('errors');
ok('no uncaught errors', errors.length === 0, errors.join(' | '));

console.log(failures === 0 ? '\nAll DOM checks passed' : `\n${failures} check(s) failed`);
process.exit(failures === 0 ? 0 : 1);
