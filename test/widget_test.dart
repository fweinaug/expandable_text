import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'finder.dart';

const SMALL_SCREEN = Size(10, 400);
const LARGE_SCREEN = Size(1000, 400);
const TEXT = 'A long text to test the widget';

void main() {
  testWidgets('Collapsed widget shows truncated text with ellipsis', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpan((span) => span.text == TEXT), findsNothing);
    expect(findTextSpan((span) => TEXT.startsWith(span.text)), findsOneWidget);
    expect(findTextSpanByText('\u2026'), findsOneWidget);
  });

  testWidgets('Expanded widget shows full text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: true)),
    );

    expect(findTextSpan((span) => span.text == TEXT), findsOneWidget);
    expect(findTextSpanByText('\u2026'), findsNothing);
  });

  testWidgets('Non-expandable widget shows no link', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(LARGE_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('less'), findsNothing);
  });

  testWidgets('Collapsed widget shows link with expand text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByText('more'), findsOneWidget);
    expect(findTextSpanByText('less'), findsNothing);
  });

  testWidgets('Expanded widget shows link with collapse text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: true)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('less'), findsOneWidget);
  });

  testWidgets('Expanded widget hides link when collapse text is null', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: null, expanded: true)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('null'), findsNothing);
  });

  testWidgets('Ellipsis has the link color if linkEllipsis is true', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: true, linkColor: Colors.red)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByTextAndColor('\u2026', Colors.red), findsOneWidget);
  });

  testWidgets('Ellipsis has NOT the link color if linkEllipsis is false', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: false, linkColor: Colors.red)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByTextAndColor('\u2026', Colors.red), findsNothing);
  });
}
