import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:highlighter/highlighter.dart' show highlight, Node;

class CustomHighlighter extends HighlightView {
  CustomHighlighter(
    String input, {
    this.language,
    this.theme = const {},
    this.padding,
    this.textStyle,
  }) : super(
          input,
          textStyle: textStyle,
          language: language,
          padding: padding,
          theme: theme,
        );

  /// Highlight language
  ///
  /// It is recommended to give it a value for performance
  ///
  /// [All available languages](https://github.com/predatorx7/highlight/tree/master/highlight/lib/languages)
  final String? language;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/predatorx7/highlight/blob/master/flutter_highlighter/lib/themes)
  final Map<String, TextStyle> theme;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Text styles
  ///
  /// Specify text styles such as font family and font size
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      fontFamily: 'monospace',
      color: theme['root']?.color ?? Color(0xff000000),
    );
    if (textStyle != null) {
      _textStyle = _textStyle.merge(textStyle);
    }

    return Container(
      color: theme['root']?.backgroundColor ?? Color(0xffffffff),
      padding: padding,
      child: SelectableText.rich(
        TextSpan(
          style: _textStyle,
          children: _convert(highlight.parse(source, language: language).nodes!),
        ),
      ),
    );
  }

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null ? TextSpan(text: node.value) : TextSpan(text: node.value, style: theme[node.className!]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(children: tmp, style: theme[node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children!.forEach((n) {
          _traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }
}
