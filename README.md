# Apple UI Components

**کیتِ کامپوننت برای ساختِ اپلیکیشن‌های مولتی‌پلتفرم** — یک بار طراحی، دو جا اجرا: وب (HTML/CSS/ES module) و فلاتر (۲۱ ویجت).

بدون وابستگی، بدون بیلد استپ، بدون فریم‌ورک. یازده کامپوننت با **یک فایلِ توکن** که هر دو طرف از آن می‌خوانند، پس نمونه‌ی وب و بیلدِ نیتیو از هم جدا نمی‌افتند.

---

## چه چیزی داخلش هست

| کامپوننت | وب | فلاتر |
|---|---|---|
| Dynamic Island (۵ حالت) | `.island` + `island.js` | — (فعلاً وب) |
| Liquid glass | `.glass-stage` / `.glass-panel` | `IosGlass` |
| سوییچ iOS 27 | `.sw` (`role="switch"`) | `IosSwitch` |
| کنترل سگمنت | `.seg` + `.thumb` | `IosSegmentedControl` |
| لیست و ردیف تنظیمات | `.glass-row` | `IosListSection` / `IosListTile` |
| پنجره macOS 11 | `.macwin` + `.macbar` / `.macsidebar` / `.macrow` | `MacWindow` / `MacSidebar` / `MacListRow` |
| شیت، نویگیشن، تب‌بار، دکمه، اسلایدر، جست‌وجو | — | `IosSheet` / `IosNavBar` / `IosTabBar` / `IosButton` / `MacSlider` / `*SearchField` |
| ریویل روی اسکرول | `[data-reveal]` + `--d` | — |

نسخه‌ی وب: **۴ فایل** (`fonts.css` · `tokens.css` · `components.css` · `island.js` + `controls.js`).
نسخه‌ی فلاتر: پکیجِ `apple_ui_kit` با ۲۱ اکسپورت (۲۲ کلاسِ ویجت به‌همراهِ توکن‌ها)، یک صفحه‌ی `example/` و **۱۴ تست**.

---

## شروع سریع — وب

```html
<link rel="stylesheet" href="web/components/fonts.css">
<link rel="stylesheet" href="web/components/tokens.css">
<link rel="stylesheet" href="web/components/components.css">

<div class="island" data-island data-state="idle" role="button" tabindex="0"
     aria-label="در حال پخش">
  <span class="layer" data-for="idle"><i class="dot"></i></span>
  <span class="layer" data-for="expanded">…</span>
</div>

<script type="module">
  import { boot } from './web/components/island.js';
  import { bootControls } from './web/components/controls.js';
  boot();          // همه‌ی [data-island] ها را بالا می‌آورد
  bootControls();  // همه‌ی .sw و .seg ها را
</script>
```

حتماً روی HTTP سرو کن (`python3 -m http.server 8000`) — فایل‌ها ES module هستند و `file://` کار نمی‌کند.

**API:**

```js
const island = new DynamicIsland(el, { initial: 'idle', group: 'dock', intro: true });
island.set('expanded');           // idle | compact | expanded | notif | call
island.cycle();                   // compact → expanded → idle
island.playIntro();               // نمایشِ خودکارِ معرفی
island.on('change', (s) => {});   // مشترک شو
island.destroy();                 // در unmount فراموش نشود
```

دو آیلند با `data-island-group` یکسان هم‌زمان عوض می‌شوند.

## شروع سریع — فلاتر

```yaml
dependencies:
  apple_ui_kit:
    path: ../flutter/apple_ui_kit
```

```dart
IosGlass(
  child: IosListSection(
    header: 'پخش',
    children: <Widget>[
      IosListTile(
        title: 'صدای فضایی',
        trailing: IosSwitch(value: spatial, onChanged: (bool v) => setState(() => spatial = v)),
      ),
    ],
  ),
)
```

`flutter analyze` و `flutter test` بخشی از قرارداد است، نه پیشنهاد.

---

## یک منبعِ حقیقت برای توکن‌ها

| CSS | مقدار | فلاتر |
|---|---|---|
| `--t-base` | 260ms | `AppleDuration.base` |
| `--ease-spring` | `cubic-bezier(.34,1.42,.64,1)` | `AppleCurves.spring` |
| `--ios-card-r` | 26px | `AppleMetrics.cardRadius` |
| `--ios-sw-w/h` | 51 × 31 | `AppleMetrics.switchWidth/Height` |
| `--glass-blur` | 28px | `AppleMetrics.glassBlur` |
| `--mac-win-r` | 10px | `MacMetrics.windowRadius` |

جدولِ کامل: [`references/tokens.md`](references/tokens.md). قاعده ساده است: عدد را که عوض کردی، **در همان کامیت** طرفِ دیگر را هم عوض کن.

## پنج قاعده‌ای که این کیت روی آن ایستاده

1. **یک مقیاس توکن، دو پلتفرم.**
2. **حرکت فقط با `transform` و `opacity`** — ۱۸۰/۲۶۰/۴۲۰/۵۶۰ میلی‌ثانیه، اسپرینگ برای ورود، استگر ۴۵ms با سقفِ ۸ آیتم. تنها استثنا اندازه‌ی خودِ جزیره است، با `contain: layout paint style`.
3. **شیشه باید چیزی برای بلور داشتن داشته باشد** — پنل روی پس‌زمینه‌ی نزدیک به سیاه، خاکستری دیده می‌شود؛ رنگ را پشتش بگذار و بلور را کلیپ کن.
4. **هیچ کامپوننتی اندازه‌ی کانتینرِ خودش را نمی‌داند** — کلیمپ روی `--island-max` است، نه `100vw` تنها (علتِ کلاسیکِ ۲۰ پیکسل اسکرول افقی روی موبایل).
5. **متنِ فارسی هرگز با فونتِ لاتین رندر نمی‌شود** — `--ui` فقط لاتین است، فارسی می‌رود در `--fa` (وزیرمتن، OFL).

## دمو

`web/showcase.html` — همه‌ی کامپوننت‌ها با مارک‌آپ و API کنارشان:

```bash
npm run serve      # http://localhost:8000/web/showcase.html
```

## تست

```bash
npm install && npm test                                      # jsdom — آیلند، کنترل‌ها، id ها، توکن‌ها
cd flutter/apple_ui_kit && flutter analyze && flutter test   # ۱۴ تست ویجت
```

وضعیتِ فعلی: هر دو سبز. در کرومِ هدلس روی ۱۴۴۰ و ۳۹۰ پیکسل هم: `overflow-x: 0`، فونت‌ها لود، صفر خطای کنسول، صفر ۴۰۴.

## مجوزها

کد: MIT · وزیرمتن: OFL 1.1 (کامیت‌شده) · فونت‌های Fontshare: مجاز به استفاده، **غیرمجاز به بازتوزیع** — با `scripts/fetch-fonts.py` گرفته می‌شوند و در `.gitignore` هستند · SF Pro هرگز باندل نمی‌شود. جزئیات: [`LICENSES.md`](LICENSES.md).

هیچ فونت، آیکون یا تصویری از اپل در این مخزن نیست؛ فقط زبانِ طراحی ارجاع داده شده است.
