library expandable_text;

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key? key,
    required this.expandText,
    this.collapseText,
    this.expanded = false,
    this.onExpandedChanged,
    this.linkColor,
    this.linkEllipsis = true,
    this.linkStyle,
    this.prefixText,
    this.prefixStyle,
    this.onPrefixTap,
    this.expandOnTextTap = false,
    this.collapseOnTextTap = false,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.semanticsLabel,
  })  : assert(maxLines > 0),
        super(key: key);

  final String text;
  final String expandText;
  final String? collapseText;
  final bool expanded;
  final ValueChanged<bool>? onExpandedChanged;
  final Color? linkColor;
  final bool linkEllipsis;
  final TextStyle? linkStyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final VoidCallback? onPrefixTap;
  final bool expandOnTextTap;
  final bool collapseOnTextTap;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final int maxLines;
  final String? semanticsLabel;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  late TapGestureRecognizer _linkTapGestureRecognizer;
  late TapGestureRecognizer _prefixTapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
    _prefixTapGestureRecognizer = TapGestureRecognizer()..onTap = _prefixTapped;
  }

  @override
  void dispose() {
    _linkTapGestureRecognizer.dispose();
    _prefixTapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    final toggledExpanded = !_expanded;

    setState(() => _expanded = toggledExpanded);

    widget.onExpandedChanged?.call(toggledExpanded);
  }

  void _prefixTapped() {
    widget.onPrefixTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final linkText =
        (_expanded ? widget.collapseText : widget.expandText) ?? '';
    final linkColor = widget.linkColor ??
        widget.linkStyle?.color ??
        Theme.of(context).accentColor;
    final linkTextStyle =
        effectiveTextStyle!.merge(widget.linkStyle).copyWith(color: linkColor);

    final prefixText =
        widget.prefixText != null && widget.prefixText!.isNotEmpty
            ? '${widget.prefixText} '
            : '';

    final link = TextSpan(
      children: [
        if (!_expanded)
          TextSpan(
            text: '\u2026 ',
            style: widget.linkEllipsis ? linkTextStyle : effectiveTextStyle,
            recognizer: widget.linkEllipsis ? _linkTapGestureRecognizer : null,
          ),
        if (linkText.length > 0)
          TextSpan(
            style: effectiveTextStyle,
            children: <TextSpan>[
              if (_expanded)
                TextSpan(
                  text: ' ',
                ),
              TextSpan(
                text: linkText,
                style: linkTextStyle,
                recognizer: _linkTapGestureRecognizer,
              ),
            ],
          ),
      ],
    );

    final prefix = TextSpan(
      text: prefixText,
      style: effectiveTextStyle.merge(widget.prefixStyle),
      recognizer: _prefixTapGestureRecognizer,
    );

    final text = TextSpan(
      children: <TextSpan>[
        prefix,
        TextSpan(
          text: widget.text,
          style: effectiveTextStyle,
        ),
      ],
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final textAlign =
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
        final textDirection =
            widget.textDirection ?? Directionality.of(context);
        final textScaleFactor =
            widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
        final locale = Localizations.maybeLocaleOf(context);

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
          final endOffset =
              (textPainter.getOffsetBefore(position.offset) ?? 0) -
                  prefixText.length;

          textSpan = TextSpan(
            style: effectiveTextStyle,
            children: <TextSpan>[
              prefix,
              TextSpan(
                text: _expanded
                    ? widget.text
                    : widget.text.substring(0, max(endOffset, 0)),
                recognizer: (_expanded
                        ? widget.collapseOnTextTap
                        : widget.expandOnTextTap)
                    ? _linkTapGestureRecognizer
                    : null,
              ),
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
