# apple_ui_kit — macOS Big Sur و iOS 27 به‌صورت ویجت فلاتر

یک پکیج فلاتر با دو خانواده‌ی ویجت:

| خانواده | منبع طراحی | پیشوند |
|---|---|---|
| مک‌او‌اس ۱۱ Big Sur | [macOS Big Sur UI Kit](https://www.figma.com/community/file/949158727443209284/macos-big-sur-ui-kit) (UI8، CC BY 4.0) | `Mac*` |
| iOS / iPadOS 27 | [iOS and iPadOS 27](https://www.figma.com/community/file/1651309003795292092/ios-and-ipados-27) (Apple) | `Ios*` |

## مهم: این یک «پورت» است، نه export لایه‌های فیگما

هر دو فایل فیگما **قابل دانلود نبودند**:

- `curl` روی آدرس‌های community → `403` (CloudFront)
- `figma.com/api/community/file/<id>` → `404`
- مسیر «Open in Figma» فایل `.fig` نمی‌دهد؛ REST API هم توکن شخصی می‌خواهد و
  فایل‌های community برای کاربر ناشناس در دسترس نیستند.

پس کاری که انجام شده این است: هر دو صفحه‌ی فیگما خوانده شد (توضیحات، لیست
کامپوننت‌ها، کامنت‌های کاربران که API واقعی کامپوننت‌ها را لو می‌دهند، تغییرات
نسخه‌ی iOS 27)، و بعد **پورت دستی ولی دقیق** بر اساس همان زبان طراحی نوشته شد:
اندازه‌های واقعی کنترل‌ها (۵۱×۳۱ سوییچ iOS، ۳۸×۲۲ سوییچ مک، ۵۶ tab bar،
۳۴ گوشه‌ی شیت، ۲۸ شعاع بلور شیشه)، رنگ‌های سیستم، و همان رفتارها (hover در
سایدبار، لغو با کشیدن شیت به پایین، اسلاید شدن thumb در segmented control).

برای اینکه ادعا با واقعیت جور باشد: هیچ لایه یا نام لایه‌ای از فایل اصلی در
کد نیست. آنچه هست، پیاده‌سازی فلاتری همان طراحی است.

> توجه: در نسخه‌ی قبلی این فایل به ابزاری به نام `figma2flutter` اشاره شده
> بود که در این ریپو وجود ندارد؛ آن جمله حذف شد تا سند با واقعیت ریپو جور
> باشد.

## نصب و استفاده

```yaml
dependencies:
  apple_ui_kit:
    path: ../flutter/apple_ui_kit
```

```dart
import 'package:apple_ui_kit/apple_ui_kit.dart';
```

```dart
MacWindow(
  title: 'Documents',
  sidebar: MacSidebar(
    sections: <MacSidebarSection>[
      MacSidebarSection(
        title: 'Favourites',
        items: <MacSidebarItem>[
          MacSidebarItem(label: 'Recents', icon: Icons.schedule, selected: true),
        ],
      ),
    ],
    onSelect: (int section, int index) {},
  ),
  toolbarTrailing: <Widget>[
    MacButton(label: 'New', icon: Icons.add, onPressed: () {}),
  ],
  child: const Padding(padding: EdgeInsets.all(16), child: MacSearchField()),
)
```

```dart
IosListSection(
  header: 'Playback',
  children: <Widget>[
    IosListTile(
      title: 'Spatial audio',
      leadingIcon: Icons.graphic_eq,
      trailing: IosSwitch(value: true, onChanged: (bool v) {}),
    ),
  ],
)
```

## کامپوننت‌های استخراج‌شده

### مک‌او‌اس (Big Sur)

| ویجت | معادل در کیت فیگما | خواص کلیدی |
|---|---|---|
| `MacWindow` | Window / App template | `title`، `sidebar`، `toolbar`، `toolbarTrailing`، `child`، `onTrafficLightTap`، `width/height` |
| `MacToolbar` | Toolbar | `leading`، `trailing`، `title`، `brightness` |
| `MacSidebar` + `MacSidebarItem` / `MacSidebarSection` | Sidebar | `sections`، `onSelect`، `badge`، `selected`، hover داخلی |
| `MacButton` | Button / Push Button | `style: standard\|primary\|destructive`، `icon`، `large`، `expand`، `onPressed` |
| `MacSegmentedControl` | Segmented Control | `segments`، `selectedIndex`، `onChanged`، `height` |
| `MacSwitch` | Switch (Toggle) | `value`، `onChanged`، `brightness` |
| `MacSlider` | Slider | `value`، `min`، `max`، `onChanged` |
| `MacSearchField` | Search Field | `controller`، `placeholder`، `onChanged`، `autofocus` |
| `MacListRow` | Table / List Row | `title`، `subtitle`، `leading`، `trailing`، `selected`، `showDisclosure` |

### iOS 27

| ویجت | معادل در کیت فیگما | خواص کلیدی |
|---|---|---|
| `IosGlass` | Material / Liquid Glass (`.soft`، `.hard` هم در همین‌جا) | `radius`، `blur`، `tint`، `showStroke`، `padding` |
| `IosNavBar` | Navigation Bar (large / inline) | `title`، `subtitle`، `largeTitle`، `leading`، `trailing` |
| `IosTabBar` + `IosTabItem` | Tab Bar (`Minimized`، `Type`) | `items`، `selectedIndex`، `onChanged`، `floating` |
| `IosListSection` / `IosListTile` | List / Inset Grouped | `header`، `footer`، `subtitle`، `leadingIcon`، `trailing`، `showChevron` |
| `IosSwitch` | Switch | `value`، `onChanged`، `activeColor` |
| `IosSegmentedControl` | Segmented Picker | `segments`، `selectedIndex`، `onChanged` |
| `IosButton` | Filled / Tinted / Plain Button | `style`، `label`، `icon`، `height`، `expand` |
| `IosSearchField` | Search Field | `controller`، `placeholder`، `onChanged` |
| `IosSheet` | Sheet - iPhone | `title`، `onDismiss`، `showGrabber`، `contentPadding` |

همه‌ی ویجت‌ها `brightness` را صریح می‌گیرند (به‌جای تکیه بر `Theme`)، پس هم
در دارک و هم در لایت مستقل از Material کار می‌کنند و رنگ‌ها از توکن می‌آید.

## توکن‌ها

`lib/src/tokens/`

- `colors.dart` — `AppleColorSet.light` / `.dark` (label، secondaryLabel،
  fill، separator، accent، glassTint، glassStroke، `closeButton` / `minimiseButton`
  / `zoomButton`). دسترسی: `AppleColorSet.of(Brightness.dark)`.
- `metrics.dart` — `AppleMetrics`: مک (شعاع پنجره ۱۰، کنترل ۶، title bar ۳۸،
  toolbar ۵۲، ردیف ۲۸، چراغ ۱۲ با فاصله‌ی ۸، سوییچ ۳۸×۲۲) و iOS 27
  (کارت ۲۶، شیت ۳۴، سوییچ ۵۱×۳۱ با thumb ۲۷، tab bar ۵۶، nav bar ۵۴،
  ردیف ۵۲، inset گروه ۱۶، blur شیشه ۲۸، گریپر ۳۶×۵). زمان‌ها ۱۶۰/۲۶۰/۳۸۰ms.
- `type.dart` — `AppleType.macBody`، `macSmall`، `macSidebarRow`،
  `iosLargeTitle`، `iosTitle2`، `iosHeadline`، `iosBody`، `iosSubhead`،
  `iosFootnote`، `iosTabLabel`.

فونت SF بسته‌بندی نشده (لایسنس)؛ `fontFamilyFallback` روی
`SF Pro Text` → `SF Pro Display` → `-apple-system` → `Segoe UI` → `Roboto`
تنظیم است، یعنی روی مک/iOS خودِ SF استفاده می‌شود و جای دیگر فونت جایگزین.

## شیشه (Liquid Glass) چطور ساخته شده

`IosGlass` = `BackdropFilter(blur 28)` + گرادیان تینت عمودی + خط مویی ۰.۵px،
داخل `ClipRRect`. سه نکته:

1. **کلیپ اجباری است** — بدون آن بلور کل لایه‌ی پشت را می‌گیرد و هزینه‌اش چند
   برابر می‌شود.
2. بلور GPU-محور است؛ روی لیست‌های بلند تعداد شیشه‌ها را کم نگه دار (همان
   هشداری که در کامنت‌های کیت iOS 27 هم هست: glass در پروتوتایپ سنگین است).
3. `tint` را می‌شود override کرد تا شیشه روی پس‌زمینه‌ی رنگی درست بنشیند.

## اجرا و بررسی

SDK استفاده‌شده: **Flutter 3.35.1 / Dart 3.9.0**

```bash
flutter pub get
flutter analyze     # No issues found!
flutter test        # 14 tests, All tests passed
```

تست‌ها: `test/components_test.dart` (۱۴ تست) شامل ساخت پنجره + چراغ‌های
ترافیک و شماره‌ی درست هر چراغ، تاگل سوییچ در هر دو خانواده، تغییر انتخاب
segmented control، کشیدن اسلایدر، ساخت هر کامپوننت در هر دو brightness، و
بستن شیت با فلیک رو به پایین. `example/test/demo_test.dart` هم کل صفحه‌ی
نمایشی را در ۱۵۰۰×۱۰۰۰ می‌سازد و هر دو خانواده را می‌بیند — همین تست دو باگ
واقعی را گرفت (پایین را ببین).

## سه چیزی که موقع ساخت واقعاً شکست و درست شد

1. **عرض بی‌نهایت.** `MacSegmentedControl` اول با `Expanded` نوشته شده بود؛
   داخل نوار عنوان، والد یک `Row` است و عرض نامحدود می‌دهد → assertion
   `RenderFlex ... unbounded`. حالا اگر عرض محدود باشد بین سگمنت‌ها تقسیم
   می‌شود و اگر نباشد با `TextPainter` اندازه‌ی هر برچسب گرفته می‌شود.
2. **حاشیه‌ی ۱ پیکسلی.** `BoxDecoration.border` خودش به padding اضافه می‌شود؛
   عرض دستی `total + 4` باعث می‌شد ۱px کم بیاید و `Row` سرریز کند. حالا
   `Container` عرضش را از محتوا می‌گیرد.
3. **`BackdropFilter` بدون کلیپ** کل لایه‌ی پشت را بلور می‌کند؛ `IosGlass`
   همیشه داخل `ClipRRect` است.

دمو برای عرض دسکتاپ چیده شده (Wrap دو ستونه)؛ روی موبایل همان صفحه را در
حالت فشرده می‌بینی، برای همین اگر ویو‌پورت باریک باشد باید خودت اسکرول کنی.

## دموی وب

دموی وبِ این پکیج همان `web/showcase.html` در ریشه‌ی ریپو است — نسخه‌ی
HTML/CSS همان کامپوننت‌ها، با همان توکن‌ها. اگر خواستی خودِ ویجت‌های فلاتر
را در مرورگر ببینی:

```bash
cd example
flutter create --platforms=web .   # اگر پوشه‌ی web/ نبود
flutter run -d chrome
```

> توجه: در نسخه‌ی قبلی این فایل گفته شده بود پوشه‌ی `demo-web/` در ریپو
> هست و بیلد آماده‌ی وب را نگه می‌دارد؛ آن پوشه در ریپو نیست و جمله حذف
> شد.

## ساختار

```
lib/apple_ui_kit.dart          # barrel، ۲۱ export
lib/src/tokens/                # colors، metrics، type
lib/src/macos/                 # window، toolbar، sidebar، button، segmented_control،
                               # switch، slider، search_field، list_row
lib/src/ios/                   # glass، nav_bar، tab_bar، list، switch،
                               # segmented_control، button، search_field، sheet
example/                       # اپ نمایشی (مک + iOS روی یک صفحه)
test/                          # ۱۴ تست ویجتی
```

## اعتبار و لایسنس

- macOS Big Sur UI Kit اثر **UI8**، لایسنس **CC BY 4.0** → استفاده آزاد با
  ذکر منبع. نام UI8 و لینک فایل را نگه دار.
- iOS and iPadOS 27 از **Apple**؛ طراحی و نام‌ها متعلق به Apple است. این کد
  یک پیاده‌سازی مستقل است و فایل، فونت یا asset‌ی از Apple در آن نیست.
- کد این پکیج (پورت فلاتر) آزاد است؛ SF Pro و SF Symbols بسته‌بندی نشده‌اند.
