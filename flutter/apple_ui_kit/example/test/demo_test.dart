import 'package:apple_ui_kit_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the demo screen renders both design languages', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1500, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DemoApp());
    await tester.pumpAndSettle();

    // macOS side
    expect(find.text('Documents'), findsWidgets);
    expect(find.text('Quarterly review.pdf'), findsOneWidget);
    expect(find.text('Autosave'), findsOneWidget);

    // iOS side
    expect(find.text('Library'), findsWidgets);
    expect(find.text('Spatial audio'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
