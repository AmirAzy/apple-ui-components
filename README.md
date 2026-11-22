# Apple UI Components

سلام 👋 این یه کیتِ کامپوننته برای ساختنِ اپ‌هایی که می‌خوان شبیه iOS و macOS دیده بشن — هم روی وب، هم روی فلاتر.

فکرِ اصلیش ساده‌ست: یه بار طراحی می‌کنی، دو جا جواب می‌گیری. وب با HTML/CSS و دو تا فایل جاوااسکریپت، فلاتر با یه پکیجِ آماده. هیچ وابستگی و بیلد استپی هم در کار نیست — فایل‌ها رو بریز تو پروژه و شروع کن.

---

## چی داخلشه؟

| کامپوننت | وب | فلاتر |
|---|---|---|
| اون جزیره‌ی بالای صفحه (Dynamic Island) با ۵ حالت | `.island` + `island.js` | — (فعلاً فقط وب) |
| شیشه‌ی مات و بلور (liquid glass) | `.glass-stage` / `.glass-panel` | `IosGlass` |
| کلیدِ روشن/خاموشِ iOS | `.sw` | `IosSwitch` |
| کنترلِ چندتایی (Segmented) | `.seg` | `IosSegmentedControl` |
| ردیف‌های تنظیمات | `.glass-row` | `IosListSection` / `IosListTile` |
| پنجره‌ی macOS | `.macwin` | `MacWindow` / `MacSidebar` / `MacListRow` |
| شیت، نوار بالا، تب‌بار، دکمه، اسلایدر، جست‌وجو | — | `IosSheet` · `IosNavBar` · `IosTabBar` · `IosButton` · `MacSlider` · `*SearchField` |

سمتِ فلاتر در کل **۲۱ تا ویجت** داره، با یه صفحه‌ی نمونه و ۱۴ تست که همه‌شون سبزن.

## سریع شروع کنیم — وب

سه تا فایل CSS رو لینک کن و دو تا تابع رو صدا بزن. همین:

```html
<link rel="stylesheet" href="web/components/fonts.css">
<link rel="stylesheet" href="web/components/tokens.css">
<link rel="stylesheet" href="web/components/components.css">

<div class="island" data-island data-state="idle" role="button" tabindex="0" aria-label="در حال پخش">
  <span class="layer" data-for="idle"><i class="dot"></i></span>
  <span class="layer" data-for="expanded">…</span>
</div>

<script type="module">
  import { boot } from './web/components/island.js';
  import { bootControls } from './web/components/controls.js';

  boot();          // همه‌ی جزیره‌ها رو راه می‌ندازه
  bootControls();  // همه‌ی کلیدها و کنترل‌ها رو
</script>
```

**یه نکته‌ی مهم:** حتماً روی یه سرورِ محلی بازش کن، نه با دابل‌کلیک روی فایل. چون ماژول‌های جاوااسکریپت با `file://` بالا نمیان. کافیه:

```bash
python3 -m http.server 8000
# بعد برو روی http://localhost:8000/web/showcase.html
```

### جزیره رو چطور کنترل کنم؟

```js
const island = new DynamicIsland(el);

island.set('expanded');  // idle | compact | expanded | notif | call
island.cycle();          // یه دور می‌چرخه: compact → expanded → idle
island.on('change', (state) => console.log(state));  // هر وقت عوض شد خبر می‌ده
island.destroy();        // وقتی از صفحه برداشتیش، این رو هم صدا بزن
```

اگه دو تا جزیره داشتی و خواستی هم‌زمان حرکت کنن، به هر دو یه `data-island-group` یکسان بده.

## و فلاتر

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
        trailing: IosSwitch(
          value: spatial,
          onChanged: (bool v) => setState(() => spatial = v),
        ),
      ),
    ],
  ),
)
```

قیافه‌ی ویجت‌ها با `flutter analyze` و `flutter test` چک می‌شه — هر دو تا الان تمیز رد می‌شن.

---

## می‌خوای رنگ و اندازه‌ها رو عوض کنی؟

همه‌چیز توی یه فایلِ کوچیکه: `web/components/tokens.css`. یه سری متغیر ساده، مثل `--ios-card-r` یا `--glass-blur`. همون عددها توی فلاتر هم هستن، با اسم‌های `AppleMetrics.cardRadius` و `AppleMetrics.glassBlur`.

قاعده‌ش اینه: عددی رو که عوض کردی، تو همون کامیت طرفِ دیگه‌ش رو هم عوض کن. وگرنه وب و فلاتر کم‌کم از هم دور می‌شن و تا وقتی دو تا اسکرین‌شات رو کنارِ هم نذاری متوجه نمی‌شی.

## چهار تا قانون که این کیت روش ایستاده

1. **حرکت فقط با `transform` و `opacity`.** سرعت‌ها ۱۸۰ / ۲۶۰ / ۴۲۰ / ۵۶۰ میلی‌ثانیه‌ست. تنها استثنا اندازه‌ی خودِ جزیره‌ست، که با `contain` مهار شده تا بقیه‌ی صفحه تکون نخوره.
2. **شیشه برای اینکه شیشه دیده بشه، باید پشتش چیزی باشه.** پنلِ مات روی پس‌زمینه‌ی تیره، شبیه یه کارتِ خاکستری می‌شه؛ اول یه لایه رنگ بذار پشتش، بعد بلور رو کلیپ کن.
3. **هیچ کامپوننتی نمی‌دونه توی چه عرضی نشسته.** برای همین جزیره روی `--island-max` کلیمپ می‌شه، نه روی `100vw` تنها. همین یه چیز، بیشترِ اسکرولِ افقیِ ناخواسته روی موبایل رو حل می‌کنه.
4. **متنِ فارسی هیچ‌وقت با فونتِ لاتین نوشته نمی‌شه.** فونتِ رابط (`--ui`) فقط لاتینه؛ فارسی می‌ره روی `--fa`، یعنی Vazirmatn.

## امتحانش کن

```bash
npm install && npm test                                      # وب
cd flutter/apple_ui_kit && flutter analyze && flutter test   # فلاتر
```

آخرین باری که چک کردم: تست‌های وب سبز، ۱۴ تستِ فلاتر سبز، و توی کروم روی ۱۴۴۰ و ۳۹۰ پیکسل هیچ اسکرولِ افقی، هیچ خطای کنسول و هیچ فایلِ گم‌شده‌ای نبود.

دموی همه‌ی کامپوننت‌ها: `web/showcase.html` — کنارِ هر کامپوننت، مارک‌آپ و کدِ استفاده‌ش نوشته شده.

## اجازه‌ها (لایسنس)

- کد: MIT، راحت استفاده کن
- فونت Vazirmatn: OFL 1.1، داخل ریپو هست
- فونت‌های Fontshare: استفاده‌شون آزاده ولی **نمی‌شه بازتوزیع کرد**؛ برای همین توی ریپو نیستن و با `python3 scripts/fetch-fonts.py` خودت دانلودشون می‌کنی
- فونت SF Pro: اصلاً باندل نمی‌شه، فقط اسمش به‌عنوان fallback ذکر شده

هیچ فونت یا آیکون یا تصویری از خودِ اپل توی این ریپو نیست؛ فقط زبانِ طراحی‌ش الگو گرفته شده.

بیشتر بخوای: پوشه‌ی [`references/`](references) — هر سند یه موضوع: جزیره، شیشه، حرکت، توکن‌ها، وب، فلاتر و یه چک‌لیستِ ۱۸ موردی برای قبل از انتشار.
