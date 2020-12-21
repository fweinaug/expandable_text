library expandable_text;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:knock_knock/core/notifiers/HomeFeedNotifier.dart';
import 'package:knock_knock/screens/posts_screens/trending.dart';
import 'package:provider/provider.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    @required this.expandText,
    @required this.collapseText,
    this.expanded = false,
    this.linkColor,
    this.linkEllipsis = true,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.semanticsLabel,
    this.onExpandedChange,
  }) : assert(text != null),
       assert(expandText != null),
       assert(collapseText != null),
       assert(expanded != null),
       assert(linkEllipsis != null),
       assert(maxLines != null && maxLines > 0),
       super(key: key);

  final String text;
  final String expandText;
  final String collapseText;
  final bool expanded;
  final Color linkColor;
  final bool linkEllipsis;
  final TextStyle style;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;


  final ValueChanged<bool> onExpandedChange;

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
    setState(() {
      _expanded = !_expanded;
    });
    // Provider.of<HomeFeedNotifier>(context, listen: false).togleExpanded(_expanded);
    widget.onExpandedChange(_expanded);
  }

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

    final linkText = _expanded ? ' ${widget.collapseText}' : widget.expandText;
    final linkColor = widget.linkColor ?? Theme.of(context).accentColor;
    final linkTextStyle = effectiveTextStyle.copyWith(color: linkColor);

    final link = TextSpan(
      children: [
        if (!_expanded) TextSpan(
          text: '\u2026 ',
          style: widget.linkEllipsis ? linkTextStyle : effectiveTextStyle,
          recognizer: widget.linkEllipsis ? _tapGestureRecognizer : null,
        ),
        TextSpan(
          text: linkText,
          style: linkTextStyle,
          recognizer: _tapGestureRecognizer,
        ),
      ],
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

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          final position = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          final endOffset = textPainter.getOffsetBefore(position.offset);

          textSpan = TextSpan(
            style: effectiveTextStyle,
            text: _expanded
                ? widget.text
                : widget.text.substring(0, endOffset),
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

