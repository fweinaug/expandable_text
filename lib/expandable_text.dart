library expandable_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    @required this.expandText,
    @required this.collapseText,
    this.expanded = false,
    this.linkColor,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.semanticsLabel,
    this.ellipsisInsideLink = true,
  }) : assert(text != null),
       assert(expandText != null),
       assert(collapseText != null),
       assert(expanded != null),
       assert(maxLines != null && maxLines > 0),
       super(key: key);

  final String text;
  final String expandText;
  final String collapseText;
  final bool expanded;
  final Color linkColor;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final bool ellipsisInsideLink;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  String ellipsisText(bool insideLink) => insideLink ? '\u2026' : '';

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign = widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor = widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final locale = Localizations.localeOf(context, nullOk: true);
    final ellipsisInsideLink = widget.ellipsisInsideLink;

    final linkText = _expanded ? ' ${widget.collapseText}' : ellipsisText(ellipsisInsideLink) + ' ${widget.expandText}';
    final linkColor = widget.linkColor ?? Theme.of(context).accentColor;

    final link = TextSpan(
      text: linkText,
      style: effectiveTextStyle.copyWith(
        color: linkColor,
      ),
      recognizer: _tapGestureRecognizer,
    );

    final ellipsis = TextSpan(
      text: ellipsisText(!ellipsisInsideLink),
      style: effectiveTextStyle,
    );

    final text = TextSpan(
      text: widget.text,
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        textPainter.text = ellipsis;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final ellipsisSize = textPainter.size;

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        final position = textPainter.getPositionForOffset(Offset(
          textSize.width - ellipsisSize.width - linkSize.width,
          textSize.height,
        ));
        final endOffset = textPainter.getOffsetBefore(position.offset);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: effectiveTextStyle,
            text: _expanded
                ? widget.text
                : widget.text.substring(0, endOffset) + ellipsisText(!ellipsisInsideLink),
            children: <TextSpan>[
              link,
            ],
          );
        } else {
          textSpan = text;
        }

        return RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          overflow: TextOverflow.clip,
        );
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }
}
