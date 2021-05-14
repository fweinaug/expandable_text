import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findTextSpan(bool Function(TextSpan) predicate) {
  return find.byWidgetPredicate((widget) => _isRichTextWithTextSpan(widget, predicate));
}

Finder findTextSpanByText(String text) {
  return find.byWidgetPredicate((widget) => _isRichTextWithTextSpan(widget, (span) => _hasText(span, text)));
}

Finder findTextSpanByTextAndColor(String text, Color color) {
  return find.byWidgetPredicate((widget) => _isRichTextWithTextSpan(widget, (span) => _hasText(span, text) && _hasColor(span, color)));
}

Finder findTextSpanWithTapGestureRecognizerAndStartingWith(String text) {
  return find.byWidgetPredicate((widget) => _isRichTextWithTextSpan(widget, (span) => _startsWithText(span, text) && span.recognizer is TapGestureRecognizer));
}

bool _startsWithText(TextSpan span, String text) => span.text != null && span.text!.isNotEmpty && text.startsWith(span.text!);
bool _hasText(TextSpan span, String text) => span.toPlainText().trim() == text;
bool _hasColor(TextSpan span, Color color) => span.style?.color == color;

bool _isRichTextWithTextSpan(Widget widget, bool Function(TextSpan) predicate) {
  bool containsTextSpan(InlineSpan span, bool Function(TextSpan) predicate) {
    if (span is TextSpan) {
      if (predicate(span)) {
        return true;
      } else if (span.children != null && span.children!.length > 0) {
        for (InlineSpan child in span.children!) {
          if (containsTextSpan(child, predicate)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  return widget is RichText && containsTextSpan(widget.text, predicate);
}
