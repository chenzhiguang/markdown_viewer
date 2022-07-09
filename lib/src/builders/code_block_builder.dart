import 'package:flutter/material.dart';

import '../definition.dart';
import 'builder.dart';

class CodeBlockBuilder extends MarkdownElementBuilder {
  CodeBlockBuilder({
    TextStyle? textStyle,
    this.highlightBuilder,
    required this.codeblockPadding,
    required this.codeblockDecoration,
  }) : super(textStyle: textStyle);

  final EdgeInsets codeblockPadding;
  final BoxDecoration codeblockDecoration;
  final MarkdownHighlightBuilder? highlightBuilder;

  @override
  final matchTypes = ['codeBlock'];

  @override
  bool replaceLineEndings(String type) => false;

  @override
  TextSpan buildText(text, parent) {
    return highlightBuilder == null
        ? TextSpan(
            text: text.trimRight(),
            style: parent.style,
          )
        : highlightBuilder!(text, parent.attributes['language'],
            parent.attributes['infoString']);
  }

  @override
  void after(renderer, element) {
    final child = element.children.isNotEmpty
        ? element.children.single
        : const SizedBox.shrink();

    renderer.write(DecoratedBox(
      decoration: codeblockDecoration,
      child: Scrollbar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: codeblockPadding,
          child: child,
        ),
      ),
    ));
  }
}