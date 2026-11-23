# Apple UI Components

کیت کامپوننت برای اپ‌هایی که قراره حس iOS و macOS بدن — روی وب و فلاتر. بدون وابستگی، بدون مرحله‌ی بیلد.

منطقش ساده‌ست: یه بار طراحی می‌کنی، دو جا جواب می‌گیری. وب با HTML و CSS و دو تا ماژول جاوااسکریپت کار می‌کنه، فلاتر با یه پکیج آماده. هر دو طرف از یه مقیاس توکن استفاده می‌کنن — همون رنگ‌ها، همون شعاع‌ها، همون زمان‌های حرکت — پس نمونه‌ی وب و بیلد نیتیو آروم‌آروم از هم دور نمی‌شن.

![Dynamic Island در حالت بازشده](docs/screenshots/island-expanded.png)
![پنل شیشه‌ای Liquid Glass](docs/screenshots/glass.png)

---

## توی جعبه چیه؟

### وب — `web/components/`

| کامپوننت | کلاس / API | توضیح |
|---|---|---|
| Dynamic Island با ۵ حالت | `.island` + `island.js` | idle ،compact ،expanded ،notif ،call — فقط وب |
| Liquid Glass | `.glass-stage` / `.glass-panel` | بلور ۲۸، تینت، خط مویی |
| سوییچ iOS | `.sw` | ‏۵۱×۳۱، با `bootControls()` |
| Segmented Control | `.seg` | شستی سفید که زیر انتخاب سر می‌خورد |
| ردیف‌های تنظیمات | `.glass-row` | ردیف ۵۲ پیکسلی داخل پنل شیشه‌ای |
| دکمه‌ها | `.btn` — filled / tinted / plain / destructive | جدید در v1.1 |
| جست‌وجو | `.search` | فیلد ۳۶ پیکسلی با دکمه‌ی پاک‌کردن |
| اسلایدر | `input.slider` | شستی ۲۸ پیکسلی، پرشوندگی با `--fill` |
| تب‌بار شناور | `.tabbar` | کپسول شیشه‌ای ۵۶ پیکسلی + بج |
| بج و توست | `.badge` / `.toast` | بج عددی و اعلان پایین صفحه |
| نوار ناوبری iOS | `.iosnav` | تایتل بزرگ ۳۴ |
| پنجره‌ی macOS | `.macwin` | نوار عنوان ۳۸، چراغ‌های ۱۲، سایدبار ۱۵۰ |
| ابزارهای حرکت | `[data-reveal]` و کمک‌کننده‌ها | فقط `transform` و `opacity` |

### فلاتر — `flutter/apple_ui_kit/`

۲۱ تا اکسپورت داره، از جمله `IosGlass` و `IosSwitch` و `IosSheet` و `IosNavBar` و `IosTabBar` و `MacWindow` و `MacSidebar` و `MacSlider` و بقیه — با یه صفحه‌ی نمونه و ۱۴ تا تست ویجتی. جزئیات کامل توی [`flutter/apple_ui_kit/README.md`](flutter/apple_ui_kit/README.md) هست.

![دکمه‌ها، جست‌وجو، اسلایدر و تب‌بار](docs/screenshots/controls.png)
![سوییچ و سگمنتد iOS](docs/screenshots/ios-controls.png)
![پنجره‌ی macOS](docs/screenshots/macos-window.png)

---

## شروع سریع — وب

سه تا فایل CSS رو لینک کن، دو تا تابع رو صدا بزن، تمومه:

```html
<link rel="stylesheet" href="web/components/fonts.css">
<link rel="stylesheet" href="web/components/tokens.css">
<link rel="stylesheet" href="web/components/components.css">

<div class="island" data-island data-state="idle" role="button" tabindex="0" aria-label="Now playing">
  <span class="layer" data-for="idle"><i class="dot"></i></span>
  <span class="layer" data-for="expanded">…</span>
</div>

<script type="module">
  import { boot } from './web/components/island.js';
  import { bootControls } from './web/components/controls.js';

  boot();          // همه‌ی جزیره‌ها را راه می‌اندازد
  bootControls();  // سوییچ، سگمنتد، جست‌وجو، اسلایدر و توست را
</script>
```

یه نکته که خیلی‌ها گیر می‌کنن: صفحه رو روی یه سرور محلی باز کن، نه با دابل‌کلیک روی فایل. ماژول‌های جاوااسکریپت با `file://` بالا نمی‌آن:

```bash
python3 -m http.server 8000
# بعد برو روی http://localhost:8000/web/showcase.html
```

دموی همه‌ی کامپوننت‌ها توی `web/showcase.html` هست — کنار هر کامپوننت، مارک‌آپ و کد استفاده‌ش هم نوشته شده. کاتالوگ کامل با اسکرین‌شات توی [`docs/components.md`](docs/components.md) هست.

### جزیره رو چطوری کنترل کنم؟

```js
const island = new DynamicIsland(el);

island.set('expanded');  // idle | compact | expanded | notif | call
island.cycle();          // یک دور می‌چرخد: compact → expanded → idle
island.on('change', (state) => console.log(state));  // هر وقت عوض شد خبر می‌دهد
island.destroy();        // وقتی از صفحه برداشتی‌اش، این را هم صدا بزن
```

اگه دو تا جزیره داشتی و خواستی هم‌زمان تکون بخورن، به هر دوشون یه `data-island-group` یکسان بده.

### چند تا مثال کوتاه

```html
<!-- دکمه‌ها -->
<button class="btn btn-filled">Play</button>
<button class="btn btn-tinted">Add to Library</button>
<button class="btn btn-destructive">Delete</button>

<!-- جست‌وجو -->
<div class="search">
  <span class="s-ico">⌕</span>
  <input type="search" placeholder="Search…">
  <button class="s-clear" aria-label="Clear search">✕</button>
</div>

<!-- اسلایدر -->
<input type="range" class="slider" min="0" max="100" value="62">

<!-- توست: یک المان در صفحه، هر دکمه‌ای با data-toast-show آن را نشان می‌دهد -->
<div class="toast" data-toast role="status">
  <span class="t-ico">✦</span><span data-toast-text></span>
</div>
<button data-toast-show data-toast-message="Added to your library ✦">Save</button>
```

---

## شروع سریع — فلاتر

```yaml
dependencies:
  apple_ui_kit:
    path: ../flutter/apple_ui_kit
```

```dart
IosGlass(
  child: IosListSection(
    header: 'Playback',
    children: <Widget>[
      IosListTile(
        title: 'Spatial audio',
        trailing: IosSwitch(
          value: spatial,
          onChanged: (bool v) => setState(() => spatial = v),
        ),
      ),
    ],
  ),
)
```

---

## می‌خوای رنگ و اندازه‌ها رو عوض کنی؟

همه‌ش توی یه فایل کوچیکه: `web/components/tokens.css`. چند تا متغیر ساده، مثل `--r-card` یا `--r-sheet`. همون عددها توی فلاتر هم هستن، با اسم‌های `AppleMetrics.cardRadius` و `AppleMetrics.sheetRadius`.

فقط یه قانون داره: هر عددی رو عوض کردی، همون کامیت طرف دیگه‌ش رو هم عوض کن. وگرنه وب و فلاتر کم‌کم از هم دور می‌شن و تا وقتی دو تا اسکرین‌شات رو کنار هم نذاری متوجه نمی‌شی. جدول تطابق توکن‌ها توی [`references/tokens.md`](references/tokens.md) هست.

---

## پنج تا قانونی که این کیت روش وایساده

1. **حرکت فقط با `transform` و `opacity`.** سرعت‌ها ۱۸۰ / ۲۶۰ / ۴۲۰ / ۵۶۰ میلی‌ثانیه‌ست. فقط اندازه‌ی خود جزیره استثناست که با `contain` مهار شده تا بقیه‌ی صفحه تکون نخوره.
2. **شیشه وقتی شیشه‌ست که پشتش چیزی باشه.** پنل مات روی پس‌زمینه‌ی تیره فقط یه کارت خاکستریه؛ اول یه لایه رنگ بذار پشتش، بعد بلور رو کلیپ کن.
3. **هیچ کامپوننتی نمی‌دونه تو چه عرضی نشسته.** برای همین جزیره روی `--island-max` کلیمپ می‌شه، نه روی `100vw` تنها. همین یه چیز بیشتر اسکرول‌های افقی ناخواسته روی موبایل رو حل می‌کنه.
4. **متن فارسی هیچ‌وقت با فونت لاتین نوشته نمی‌شه.** فونت رابط (`--ui`) فقط لاتینه؛ فارسی می‌ره روی `--fa`، یعنی Vazirmatn.
5. **یه مقیاس توکن، دو پلتفرم.** تغییر `--r-card` بدون تغییر `AppleMetrics.cardRadius` یه تغییر ناتمامه.

---

## ساختار ریپو

```
web/
  components/        # tokens.css, components.css, fonts.css, island.js, controls.js
  showcase.html      # دموی همه‌ی کامپوننت‌ها
flutter/apple_ui_kit/
  lib/               # ۲۱ اکسپورت: ios/ ،macos/ ،tokens/
  example/           # اپ نمایشی
  test/              # ۱۴ تست ویجتی
docs/
  components.md      # کاتالوگ کامپوننت‌ها با اسکرین‌شات
  screenshots/       # اسکرین‌شات‌های واقعی از کامپوننت‌های وب
references/          # island-spec ،glass ،motion ،tokens ،web ،flutter ،checklist
assets/fonts-licensed/  # فونت Vazirmatn (OFL 1.1)
scripts/fetch-fonts.py  # دانلود فونت‌های Fontshare (قابل بازتوزیع نیستند)
test/dom-check.mjs   # تست‌های DOM وب با jsdom
```

---

## امتحانش کن

```bash
npm install && npm test                                      # وب
cd flutter/apple_ui_kit && flutter analyze && flutter test   # فلاتر
```

آخرین بار که چک کردم: تست‌های وب سبز بودن، ۱۴ تست فلاتر سبز، و توی کروم روی ۱۴۴۰ و ۳۹۰ پیکسل نه اسکرول افقی بود، نه خطای کنسول، نه فایل گم‌شده. چک‌لیست ۱۸ موردی قبل از انتشار توی [`references/checklist.md`](references/checklist.md) هست.

---

## اگه خواستی چیزی بهش اضافه کنی

اگه کامپوننتی اضافه می‌کنی یا توکنی رو عوض می‌کنی، اول [`CONTRIBUTING.md`](CONTRIBUTING.md) رو بخون: اول تست، بعد کامیت؛ وب و فلاتر همیشه با هم.

تغییرات هر نسخه توی [`CHANGELOG.md`](CHANGELOG.md) هست.

---

## لایسنس

- کد: MIT، راحت استفاده کن
- فونت Vazirmatn: OFL 1.1، داخل ریپو هست
- فونت‌های Fontshare: استفاده‌شون آزاده ولی **نمی‌شه بازتوزیع کرد**؛ برای همین توی ریپو نیستن و با `python3 scripts/fetch-fonts.py` خودت دانلودشون می‌کنی
- فونت SF Pro: اصلاً باندل نمی‌شه، فقط اسمش به‌عنوان fallback ذکر شده

هیچ فونت، آیکون یا تصویری از خود اپل توی این ریپو نیست؛ فقط از زبان طراحیش الگو گرفته شده. جزئیات کامل توی [`LICENSES.md`](LICENSES.md).

اگه بیشتر خواستی: پوشه‌ی [`references/`](references) — هر سند یه موضوع: جزیره، شیشه، حرکت، توکن‌ها، وب، فلاتر و یه چک‌لیست ۱۸ موردی برای قبل از انتشار.
