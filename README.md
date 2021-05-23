![Build](https://github.com/fweinaug/expandable_text/workflows/Build/badge.svg)
[![pub package](https://img.shields.io/pub/v/expandable_text.svg)](https://pub.dev/packages/expandable_text)
[![license](https://img.shields.io/badge/license-MIT-green)](https://github.com/fweinaug/expandable_text/blob/master/LICENSE)

This Flutter package includes the widget `ExpandableText` which you can use to initially only show a
defined number of lines of a probably long text. The widget appends a configurable text link which
let's the user expand the full text, or collapse it again.

![Example with maxLines=1](https://user-images.githubusercontent.com/17765766/118534275-531f7c00-b749-11eb-90e9-e6eb36808eec.gif)

## Getting started

Add this to your package's pubspec.yaml file:

```
dependencies:
  expandable_text: 2.1.0+1
```

Next, import the package into your dart code:

```dart
import 'package:expandable_text/expandable_text.dart';
```

### Usage

Example which shows an expandable text if `longText` exceeds one line:

```dart
Widget build(BuildContext context) {
    return ExpandableText(
        longText,
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 1,
        linkColor: Colors.blue,
    );
}
```

## Features

- Link to expand the collapsed text (`expandText`)
- Expand and collapse animation (`animation`, `animationDuration`, `animationCurve`)
- Optional link to collapse the expanded text (`collapseText`)
- Configure the style of the link (`linkStyle` / `linkColor`)
- Control whether the ellipsis is part of the link (`linkEllipsis`)
- Optional prefix text with style and tap callback (`prefixText`, `prefixStyle`, `onPrefixTap`)
- Text with tappable and styled links (`onUrlTap`, `urlStyle`)
- Text with tappable and styled @mentions (`onMentionTap`, `mentionStyle`)
- Text with tappable and styled #hashtags (`onHashtagTap`, `hashtagStyle`)
- Configure the number of visible lines of the collapsed text (`maxLines`)
- Control the default expanded state (`expanded`)
- Callback for expanded changed event (`onExpandedChanged`)
- Tap on the text to expand or collapse the text (`expandOnTextTap`, `collapseOnTextTap`)

## Bugs and feature requests

Have a bug or a feature request? Please first search for existing and closed issues.
If your problem or idea is not addressed yet, [please open a new issue](https://github.com/fweinaug/expandable_text/issues/new).

## Copyright & License

Code copyright 2020–2021 Florian Weinaug.
Code released under the [MIT license](https://github.com/fweinaug/expandable_text/blob/master/LICENSE).
