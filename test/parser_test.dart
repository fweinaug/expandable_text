import 'package:expandable_text/text_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse empty text', () {
    final segments = parseText('');

    expect(segments, []);
  });

  test('Parse simple text', () {
    final segments = parseText('text without hashtags and mentions');

    expect(segments, [
      TextSegment('text without hashtags and mentions')
    ]);
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

    expect(segments, [
      TextSegment('@mention', 'mention', false, true, false)
    ]);
  });

  test('Parse text with a mention', () {
    final segments = parseText('text with a @mention');

    expect(segments, [
      TextSegment('text with a '),
      TextSegment('@mention', 'mention', false, true, false)
    ]);
  });

  test('Parse urls', () {
    final segments = parseText('https://flutter.dev flutter.dev http://flutter.dev/docs/get-started flutter.dev/docs/get-started en.wikipedia.org/wiki/Flutter_(software) amazon.co.uk amazon.co.uk/s?k=flutter');

    expect(segments, [
      TextSegment('https://flutter.dev', 'https://flutter.dev', false, false, true),
      TextSegment(' '),
      TextSegment('flutter.dev', 'flutter.dev', false, false, true),
      TextSegment(' '),
      TextSegment('http://flutter.dev/docs/get-started', 'http://flutter.dev/docs/get-started', false, false, true),
      TextSegment(' '),
      TextSegment('flutter.dev/docs/get-started', 'flutter.dev/docs/get-started', false, false, true),
      TextSegment(' '),
      TextSegment('en.wikipedia.org/wiki/Flutter_(software)', 'en.wikipedia.org/wiki/Flutter_(software)', false, false, true),
      TextSegment(' '),
      TextSegment('amazon.co.uk', 'amazon.co.uk', false, false, true),
      TextSegment(' '),
      TextSegment('amazon.co.uk/s?k=flutter', 'amazon.co.uk/s?k=flutter', false, false, true),
    ]);
  });

  test('Parse text with a url', () {
    final segments = parseText('text with url... https://flutter.dev');

    expect(segments, [
      TextSegment('text with url... '),
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

  test('Parse mentions and hashtags that start on a new line', () {
    final segments = parseText('@men\n@tion\n#hash\n#tag');

    expect(segments, [
      TextSegment('@men', 'men', false, true, false),
      TextSegment('\n'),
      TextSegment('@tion', 'tion', false, true, false),
      TextSegment('\n'),
      TextSegment('#hash', 'hash', true, false, false),
      TextSegment('\n'),
      TextSegment('#tag', 'tag', true, false, false),
    ]);
  });
}
