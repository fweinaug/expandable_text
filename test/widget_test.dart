import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'finder.dart';

const SMALL_SCREEN = Size(300, 400);
const LARGE_SCREEN = Size(1000, 400);
const TEXT = 'A long text to test the widget';
const PREFIX = 'Prefix text';

void main() {
  testWidgets('Collapsed widget shows truncated text with ellipsis', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpan((span) => span.text == TEXT), findsNothing);
    expect(findTextSpanByText('\u2026'), findsOneWidget);
  });

  testWidgets('Expanded widget shows full text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: true)),
    );

    expect(findTextSpan((span) => span.text == TEXT), findsOneWidget);
    expect(findTextSpanByText('\u2026'), findsNothing);
  });

  testWidgets('Non-expandable widget shows no link', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(LARGE_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('less'), findsNothing);
  });

  testWidgets('Collapsed widget shows link with expand text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByText('more'), findsOneWidget);
    expect(findTextSpanByText('less'), findsNothing);
  });

  testWidgets('Expanded widget shows link with collapse text', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: true)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('less'), findsOneWidget);
  });

  testWidgets('Expanded widget hides link when collapse text is null', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: null, expanded: true)),
    );

    expect(findTextSpanByText('\u2026'), findsNothing);
    expect(findTextSpanByText('more'), findsNothing);
    expect(findTextSpanByText('null'), findsNothing);
  });

  testWidgets('Ellipsis has the link color if linkEllipsis is true', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: true, linkColor: Colors.red)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByTextAndColor('\u2026', Colors.red), findsOneWidget);
  });

  testWidgets('Ellipsis has NOT the link color if linkEllipsis is false', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: false, linkColor: Colors.red)),
    );

    expect(findTextSpanByText('\u2026'), findsOneWidget);
    expect(findTextSpanByTextAndColor('\u2026', Colors.red), findsNothing);
  });

  testWidgets('Link has the link style applied', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: false, linkStyle: TextStyle(color: Colors.red))),
    );

    expect(findTextSpanByTextAndColor('more', Colors.red), findsOneWidget);
  });

  testWidgets('Link has always the link color applied', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, linkEllipsis: false, linkColor: Colors.red, linkStyle: TextStyle(color: Colors.blue))),
    );

    expect(findTextSpanByTextAndColor('more', Colors.red), findsOneWidget);
  });

  testWidgets('Prefix is visible when the widget is collapsed', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, prefixText: PREFIX, expanded: false, expandText: 'more')),
    );

    expect(findTextSpanByText(PREFIX), findsOneWidget);
  });

  testWidgets('Prefix is visible when the widget is expanded', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, prefixText: PREFIX, expanded: true, expandText: 'more')),
    );

    expect(findTextSpanByText(PREFIX), findsOneWidget);
  });

  testWidgets('Prefix has the prefix style applied', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(
          home: ExpandableText(TEXT, prefixText: PREFIX, prefixStyle: TextStyle(color: Colors.red), expandText: 'more')),
    );

    expect(findTextSpanByTextAndColor(PREFIX, Colors.red), findsOneWidget);
  });

  testWidgets('Collapsed text is NOT expandable by tap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', expandOnTextTap: false, collapseOnTextTap: true, expanded: false)),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith(TEXT), findsNothing);
  });

  testWidgets('Collapsed text is expandable by tap if expandOnTextTap is true', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', expandOnTextTap: true, collapseOnTextTap: false, expanded: false)),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith(TEXT), findsOneWidget);
  });

  testWidgets('Expanded text is NOT collapsable by tap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', expandOnTextTap: true, collapseOnTextTap: false, expanded: true)),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith(TEXT), findsNothing);
  });

  testWidgets('Expanded text is collapsable by tap if collapseOnTextTap is true', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', expandOnTextTap: false, collapseOnTextTap: true, expanded: true)),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith(TEXT), findsOneWidget);
  });

  testWidgets('Hashtag in the text is tappable if enabled', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('Text with a #hashtag', expandText: 'more', expanded: true, onHashtagTap: (_) => {})),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith('#hashtag'), findsOneWidget);
  });

  testWidgets('Mention in the text is tappable if enabled', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('Text with a @mention', expandText: 'more', expanded: true, onMentionTap: (_) => {})),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith('@mention'), findsOneWidget);
  });

  testWidgets('Link in the text is tappable if enabled', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('Text with a link https://flutter.dev', expandText: 'more', expanded: true, onUrlTap: (_) => {})),
    );

    expect(findTextSpanWithTapGestureRecognizerAndStartingWith('https://flutter.dev'), findsOneWidget);
  });

  testWidgets('Tap on link expands the widget', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false)),
    );

    expect(findTextSpanByText('more'), findsOneWidget);

    await tester.tap(findTextSpanByText('more'));
    await tester.pumpAndSettle();

    expect(findTextSpanByText('less'), findsOneWidget);
  });

  testWidgets('Tap on link calls onExpandedChanged', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    var expanded = false;

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, onExpandedChanged: (value) => expanded = value)),
    );

    await tester.tap(findTextSpanByText('more'));

    expect(expanded, true);
  });

  testWidgets('Tap on hashtag calls onHashtagTap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(LARGE_SCREEN);

    var called = false;
    var hashtag = '';

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('#test', expandText: 'more', collapseText: 'less', expanded: false, onHashtagTap: (value) {
        called = true;
        hashtag = value;
      })),
    );

    await tester.tap(findTextSpanByText('#test'));

    expect(called, true);
    expect(hashtag, 'test');
  });

  testWidgets('Tap on mention calls onMentionTap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(LARGE_SCREEN);

    var called = false;
    var mention = '';

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('@test', expandText: 'more', collapseText: 'less', expanded: false, onMentionTap: (value) {
        called = true;
        mention = value;
      })),
    );

    await tester.tap(findTextSpanByText('@test'));

    expect(called, true);
    expect(mention, 'test');
  });

  testWidgets('Tap on url calls onUrlTap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(LARGE_SCREEN);

    var called = false;
    var url = '';

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText('https://flutter.dev', expandText: 'more', collapseText: 'less', expanded: false, onUrlTap: (value) {
        called = true;
        url = value;
      })),
    );

    await tester.tap(findTextSpanByText('https://flutter.dev'));

    expect(called, true);
    expect(url, 'https://flutter.dev');
  });

  testWidgets('Tap on link calls onLinkTap', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    await binding.setSurfaceSize(SMALL_SCREEN);

    var called = false;

    await tester.pumpWidget(
      MaterialApp(home: ExpandableText(TEXT, expandText: 'more', collapseText: 'less', expanded: false, onLinkTap: () => called = true)),
    );

    await tester.tap(findTextSpanByText('more'));

    expect(called, true);
  });
}
