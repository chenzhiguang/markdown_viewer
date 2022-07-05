import 'dart:convert';

import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Map<String, dynamic> toMap() {
    final type = runtimeType;
    final self = this;
    final Map<String, dynamic> map = {
      'type': type.toString(),
    };

    if (self is Column || self is Row || self is Wrap) {
      map.addAll({
        if ((self as MultiChildRenderObjectWidget).children.isNotEmpty)
          'children': self.children.map((e) => e.toMap()).toList(),
      });
    } else if (self is RichText) {
      final text =
          (self.text is TextSpan) ? (self.text as TextSpan).toMap() : null;

      final children = self.children.map((e) => e.toMap()).toList();
      map.addAll({
        if (children.isNotEmpty) 'children': children,
        if (text != null) 'text': text,
      });
    } else if (self is SizedBox) {
      map.addAll({
        if (self.height != null) 'height': self.height,
        if (self.width != null) 'width': self.width,
      });
    } else if (self is Scrollbar) {
      map.addAll({
        'child': self.child.toMap(),
      });
    } else if (self is SingleChildScrollView) {
      map.addAll({
        if (self.child != null) 'child': self.child?.toMap(),
      });
    } else if (self is ConstrainedBox) {
      map.addAll({
        'constraints': self.constraints.toMap(),
        if (self.child != null) 'child': self.child?.toMap(),
      });
    } else if (self is Container) {
      map.addAll({
        if (self.child != null) 'child': self.child?.toMap(),
        if (self.decoration != null) 'decoration': self.decoration!.toMap(),
      });
    } else if (self is SingleChildRenderObjectWidget) {
      map.addAll({
        if (self.child != null) 'child': self.child?.toMap(),
      });
    } else if (self is Text) {
      map.addAll({
        'data': self.data,
      });
    } else if (self is Expanded) {
      map.addAll({
        'child': self.child.toMap(),
      });
    }
    return map;
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension TextSpanExtensions on TextSpan {
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      if (text != null) 'text': text,
      if (style != null) 'style': style!.toMap(),
      if (children != null && children!.isNotEmpty)
        'children': children!.map((e) => (e as TextSpan).toMap()).toList(),
      if (recognizer != null) 'recognizer': recognizer.runtimeType.toString(),
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension DecorationExtensions on Decoration {
  Map<String, dynamic> toMap() {
    Map<String, dynamic>? borderMap;
    if (this is BoxDecoration) {
      final border = (this as BoxDecoration).border;
      if (border != null) {
        borderMap = border.toMap();
      }
    }

    return {
      'type': runtimeType.toString(),
      if (borderMap != null) 'border': borderMap,
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension BorderExtensions on BoxBorder {
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      if (top.width > 0) 'top': top.toMap(),
      if (bottom.width > 0) 'bottom': bottom.toMap(),
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension BoxConstraintsExtensions on BoxConstraints {
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      if (minWidth != double.infinity) 'minWidth': minWidth,
      if (minHeight != double.infinity) 'minHeight': minHeight,
      if (maxHeight != double.infinity) 'maxWidth': maxWidth,
      if (maxWidth != double.infinity) 'maxHeight': maxHeight,
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension BorderSideExtensions on BorderSide {
  Map<String, dynamic> toMap() {
    return {
      'type': runtimeType.toString(),
      'width': width,
      'color': color.toString(),
    };
  }

  String toPrettyString() => toMap().toPrettyString();
}

extension TextStyleExtensions on TextStyle {
  Map<String, dynamic> toMap() => {
        if (fontFamily != null) 'fontFamily': fontFamily,
        if (fontWeight != null) 'fontWeight': fontWeight.toString(),
        if (fontSize != null) 'fontSize': fontSize,
        if (fontStyle != null) 'fontStyle': fontStyle.toString(),
        if (color != null) 'color': color.toString(),
        if (backgroundColor != null)
          'backgroundColor': backgroundColor.toString(),
      };

  String toPrettyString() => toMap().toPrettyString();
}

extension WidgetsExtensions on List<Widget> {
  List<Map<String, dynamic>> toMap() => map((e) => e.toMap()).toList();

  String toPrettyString() => toMap().toPrettyString();
}

extension MapExtensions on Map {
  String toPrettyString() {
    return _toPrettyString(this);
  }
}

extension MapsExtensions on List<Map<String, dynamic>> {
  String toPrettyString() {
    return _toPrettyString(this);
  }
}

String _toPrettyString(Object object) =>
    const JsonEncoder.withIndent("  ").convert(object);
