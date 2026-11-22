import 'package:apple_ui_kit/apple_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {Size size = const Size(900, 900)}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(width: size.width, height: size.height, child: child),
      ),
    ),
  );
}

void main() {
  group('macOS Big Sur', () {
    testWidgets('window draws title, sidebar and traffic lights', (WidgetTester tester) async {
      await tester.pumpWidget(host(
        const MacWindow(
          title: 'Documents',
          sidebar: MacSidebar(
            sections: <MacSidebarSection>[
              MacSidebarSection(
                title: 'Favourites',
                items: <MacSidebarItem>[
                  MacSidebarItem(label: 'Recents', icon: Icons.schedule, selected: true),
                  MacSidebarItem(label: 'Downloads', icon: Icons.download),
                ],
              ),
            ],
          ),
          child: SizedBox.expand(),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Documents'), findsOneWidget);
      expect(find.text('Recents'), findsOneWidget);
      expect(find.text('FAVOURITES'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('traffic lights report their index', (WidgetTester tester) async {
      final List<int> taps = <int>[];
      await tester.pumpWidget(host(
        MacWindow(
          title: 'Window',
          onTrafficLightTap: taps.add,
          child: const SizedBox.expand(),
        ),
      ));
      await tester.pumpAndSettle();

      final Finder closeDot = find.byWidgetPredicate(
        (Widget w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration! as BoxDecoration).color == AppleColorSet.closeButton,
      );
      expect(closeDot, findsOneWidget);
      await tester.tap(closeDot);
      expect(taps, <int>[0]);
    });

    testWidgets('switch toggles through its callback', (WidgetTester tester) async {
      bool value = false;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MacSwitch(
              value: value,
              onChanged: (bool v) => setState(() => value = v),
            );
          },
        ),
        size: const Size(200, 100),
      ));
      await tester.tap(find.byType(MacSwitch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });

    testWidgets('segmented control changes selection', (WidgetTester tester) async {
      int selected = 0;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MacSegmentedControl(
              segments: const <String>['Day', 'Week', 'Month'],
              selectedIndex: selected,
              onChanged: (int i) => setState(() => selected = i),
            );
          },
        ),
        size: const Size(300, 100),
      ));
      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();
      expect(selected, 2);
    });

    testWidgets('slider reports a larger value after a drag', (WidgetTester tester) async {
      double value = 0.2;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return MacSlider(
              value: value,
              onChanged: (double v) => setState(() => value = v),
            );
          },
        ),
        size: const Size(240, 60),
      ));
      await tester.drag(find.byType(MacSlider), const Offset(80, 0));
      await tester.pumpAndSettle();
      expect(value, greaterThan(0.2));
    });

    testWidgets('list row and search field build in both appearances',
        (WidgetTester tester) async {
      for (final Brightness brightness in Brightness.values) {
        await tester.pumpWidget(host(
          Column(
            children: <Widget>[
              MacSearchField(brightness: brightness),
              MacListRow(
                title: 'Row',
                subtitle: 'Subtitle',
                brightness: brightness,
                showDisclosure: true,
                trailing: MacSwitch(
                  value: brightness == Brightness.dark,
                  onChanged: (_) {},
                  brightness: brightness,
                ),
              ),
            ],
          ),
          size: const Size(400, 200),
        ));
        await tester.pumpAndSettle();
        expect(find.text('Row'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('iOS 27', () {
    testWidgets('nav bar shows a large title and subtitle', (WidgetTester tester) async {
      await tester.pumpWidget(host(const IosNavBar(title: 'Library', subtitle: '24 items')));
      await tester.pumpAndSettle();
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('24 items'), findsOneWidget);
    });

    testWidgets('tab bar changes destination', (WidgetTester tester) async {
      int tab = 0;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return IosTabBar(
              items: const <IosTabItem>[
                IosTabItem(icon: Icons.home_outlined, label: 'Home'),
                IosTabItem(icon: Icons.search, label: 'Search'),
              ],
              selectedIndex: tab,
              onChanged: (int i) => setState(() => tab = i),
            );
          },
        ),
        size: const Size(390, 150),
      ));
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(tab, 1);
    });

    testWidgets('switch toggles', (WidgetTester tester) async {
      bool value = true;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return IosSwitch(
              value: value,
              onChanged: (bool v) => setState(() => value = v),
            );
          },
        ),
        size: const Size(200, 100),
      ));
      await tester.tap(find.byType(IosSwitch));
      await tester.pumpAndSettle();
      expect(value, isFalse);
    });

    testWidgets('segmented control changes selection', (WidgetTester tester) async {
      int selected = 1;
      await tester.pumpWidget(host(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return IosSegmentedControl(
              segments: const <String>['All', 'Recent', 'Shared'],
              selectedIndex: selected,
              onChanged: (int i) => setState(() => selected = i),
            );
          },
        ),
        size: const Size(320, 80),
      ));
      await tester.tap(find.text('Shared'));
      await tester.pumpAndSettle();
      expect(selected, 2);
    });

    testWidgets('glass section renders rows', (WidgetTester tester) async {
      await tester.pumpWidget(host(
        IosListSection(
          header: 'Playback',
          footer: 'Footnote',
          children: <Widget>[
            IosListTile(title: 'Spatial audio', leadingIcon: Icons.graphic_eq, trailing: IosSwitch(value: true, onChanged: (_) {})),
            IosListTile(title: 'Quality', showChevron: true, showSeparator: false, onTap: () {}),
          ],
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('PLAYBACK'), findsOneWidget);
      expect(find.text('Spatial audio'), findsOneWidget);
      expect(find.text('Footnote'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sheet dismisses on a downward flick', (WidgetTester tester) async {
      bool dismissed = false;
      await tester.pumpWidget(host(
        Align(
          alignment: Alignment.bottomCenter,
          child: IosSheet(
            title: 'Now playing',
            onDismiss: () => dismissed = true,
            child: const Text('content'),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.fling(find.text('Now playing'), const Offset(0, 320), 1200);
      await tester.pumpAndSettle();
      expect(dismissed, isTrue);
    });

    testWidgets('button reports presses and ignores disabled taps', (WidgetTester tester) async {
      int presses = 0;
      await tester.pumpWidget(host(
        Column(
          children: <Widget>[
            IosButton(label: 'Continue', onPressed: () => presses++),
            const SizedBox(height: 12),
            const IosButton(label: 'Disabled'),
          ],
        ),
        size: const Size(320, 200),
      ));
      await tester.tap(find.text('Continue'));
      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(presses, 1);
    });

    testWidgets('search field and glass build in both appearances',
        (WidgetTester tester) async {
      for (final Brightness brightness in Brightness.values) {
        await tester.pumpWidget(host(
          IosGlass(
            brightness: brightness,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                IosSearchField(brightness: brightness),
                const SizedBox(height: 8),
                Text('inside glass', style: AppleType.iosBody),
              ],
            ),
          ),
          size: const Size(390, 220),
        ));
        await tester.pumpAndSettle();
        expect(find.text('inside glass'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
