import 'package:flutter/material.dart';

List<Widget> mergeRichText(
  List<Widget> children, {
  required Widget Function(TextSpan span, TextAlign? textAlign) richTextBuilder,
}) {
  if (children.isEmpty) {
    return children;
  }

  final result = <Widget>[];
  var inlineStack = <Widget>[];

  void popInlineWidgets() {
    if (inlineStack.isEmpty) {
      return;
    }

    if (inlineStack.length == 1) {
      result.add(inlineStack.single);
    } else {
      result.add(Wrap(
        children: inlineStack,
      ));
    }

    inlineStack = <Widget>[];
  }

  for (final child in children) {
    if (child is RichText || child is SelectableText) {
      if (inlineStack.isEmpty ||
          (inlineStack.last is! RichText &&
              inlineStack.last is! SelectableText) ||
          _hasFontFeatures(child) ||
          _hasFontFeatures(inlineStack.last)) {
        inlineStack.add(child);
        continue;
      }

      final previous = inlineStack.removeLast();
      final previousTextSpan = previous is SelectableText
          ? previous.textSpan!
          : (previous as RichText).text as TextSpan;
      final children = previousTextSpan.children != null
          ? List<TextSpan>.from(previousTextSpan.children!)
          : [previousTextSpan];

      TextAlign? textAlign;
      if (child is RichText) {
        children.add(child.text as TextSpan);
        textAlign = child.textAlign;
      } else if (child is SelectableText && child.textSpan != null) {
        children.add(child.textSpan!);
        textAlign = child.textAlign;
      }

      final mergedSpan = _mergeSimilarTextSpans(children);
      inlineStack.add(richTextBuilder(mergedSpan, textAlign));
    } else if (child is Text || child is DefaultTextStyle) {
      inlineStack.add(child);
    } else {
      popInlineWidgets();
      result.add(child);
    }
  }

  popInlineWidgets();

  return result;
}

bool _hasFontFeatures(Widget widget) {
  if (widget is! RichText && widget is! SelectableText) {
    return false;
  }

  final textSpan = widget is SelectableText
      ? widget.textSpan!
      : (widget as RichText).text as TextSpan;

  final children = textSpan.children != null
      ? List<TextSpan>.from(textSpan.children!)
      : [textSpan];

  return children.any(
    (element) => element.style?.fontFeatures?.isNotEmpty ?? false,
  );
}

/// Combine text spans with equivalent properties into a single span.
TextSpan _mergeSimilarTextSpans(List<TextSpan>? textSpans) {
  if (textSpans == null || textSpans.length < 2) {
    return TextSpan(children: textSpans);
  }

  final mergedSpans = <TextSpan>[textSpans.first];

  for (var index = 1; index < textSpans.length; index++) {
    final nextChild = textSpans[index];
    if (nextChild.recognizer == mergedSpans.last.recognizer &&
        nextChild.semanticsLabel == mergedSpans.last.semanticsLabel &&
        nextChild.style == mergedSpans.last.style) {
      final previous = mergedSpans.removeLast();
      mergedSpans.add(TextSpan(
        text: previous.toPlainText() + nextChild.toPlainText(),
        recognizer: previous.recognizer,
        semanticsLabel: previous.semanticsLabel,
        style: previous.style,
      ));
    } else {
      mergedSpans.add(nextChild);
    }
  }

  // When the mergered spans compress into a single TextSpan return just that
  // TextSpan, otherwise bundle the set of TextSpans under a single parent.
  return mergedSpans.length == 1
      ? mergedSpans.first
      : TextSpan(children: mergedSpans);
}

/// A fake widget in order to return a list of widget from
/// [MarkdownElementBuilder.buildWidget] when it is an inline element.
class InlineWraper extends Widget {
  const InlineWraper(this.children, {Key? key}) : super(key: key);
  final List<Widget> children;

  @override
  InlineWraperElement createElement() =>
      InlineWraperElement(const SizedBox.shrink());
}

class InlineWraperElement extends Element {
  InlineWraperElement(super.widget);

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {}
}
