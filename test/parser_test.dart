import 'package:expandable_text/text_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse empty text', () {
    final segments = parseText('');

    expect(segments, []);
  });

  test('Parse simple text', () {
    final segments = parseText('text without hashtags and mentions');

    expect(segments, [TextSegment('text without hashtags and mentions')]);
  });

  test('Parse hashtag', () {
    final segments = parseText('#hashtag');

    expect(segments, [
      TextSegment('#hashtag', 'hashtag', true, false, false),
    ]);
  });

  test('Parse text with a hashtag', () {
    final segments = parseText('text with a #hashtag');

    expect(segments, [
      TextSegment('text with a '),
      TextSegment('#hashtag', 'hashtag', true, false, false),
    ]);
  });

  test('Parse mention', () {
    final segments = parseText('@mention');

    expect(segments, [TextSegment('@mention', 'mention', false, true, false)]);
  });

  test('Parse text with a mention', () {
    final segments = parseText('text with a @mention');

    expect(segments, [TextSegment('text with a '), TextSegment('@mention', 'mention', false, true, false)]);
  });

  test('Parse url', () {
    final segments = parseText('https://flutter.dev');

    expect(segments, [
      TextSegment('https://flutter.dev', 'https://flutter.dev', false, false, true),
    ]);
  });

  test('Parse wrong url', () {
    final segments = parseText('wrong url test...');

    expect(segments, [
      TextSegment('wrong url test...'),
    ]);
  });

  test('Parse simple url', () {
    final segments = parseText('simple url facebook.com');

    expect(segments, [
      TextSegment('simple url '),
      TextSegment('facebook.com', 'facebook.com', false, false, true),
    ]);
  });

  test('Parse text with a url', () {
    final segments = parseText('text with url https://flutter.dev');

    expect(segments, [
      TextSegment('text with url '),
      TextSegment('https://flutter.dev', 'https://flutter.dev', false, false, true),
    ]);
  });

  test('Parse text with mentions, hashtags and links', () {
    final segments = parseText('text with a #hashtag and a @mention. https://flutter.dev #works');

    expect(segments, [
      TextSegment('text with a '),
      TextSegment('#hashtag', 'hashtag', true, false, false),
      TextSegment(' and a '),
      TextSegment('@mention', 'mention', false, true, false),
      TextSegment('. '),
      TextSegment('https://flutter.dev', 'https://flutter.dev', false, false, true),
      TextSegment(' '),
      TextSegment('#works', 'works', true, false, false),
    ]);
  });

  test('Ignore mentions and hashtags that are not a word', () {
    final segments = parseText('men@tion hash#tag');

    expect(segments, [
      TextSegment('men@tion hash#tag'),
    ]);
  });
}
