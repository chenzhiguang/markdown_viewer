abstract class Widget {
  const Widget();
}

abstract class MultiChildRenderObjectWidget extends Widget {
  const MultiChildRenderObjectWidget({
    this.children = const <Widget>[],
  });
  final List<Widget> children;
}

abstract class SingleChildRenderObjectWidget extends Widget {
  const SingleChildRenderObjectWidget({this.child});
  final Widget? child;
}

class Column extends MultiChildRenderObjectWidget {
  Column({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    List<Widget> children = const <Widget>[],
  }) : super(children: children);

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
}

class Wrap extends MultiChildRenderObjectWidget {
  const Wrap({
    List<Widget> children = const <Widget>[],
  }) : super(children: children);
}

class RichText extends MultiChildRenderObjectWidget {
  const RichText({
    required this.text,
    this.textAlign,
  });
  final InlineSpan text;
  final TextAlign? textAlign;
}

class SelectableText extends Widget {
  const SelectableText.rich(
    this.textSpan, {
    this.textAlign,
    this.onTap,
  });

  final TextSpan? textSpan;
  final TextAlign? textAlign;
  final GestureTapCallback? onTap;
}

class Text extends Widget {
  const Text(this.data);

  final String? data;
}

class Padding extends SingleChildRenderObjectWidget {
  const Padding({
    required this.padding,
    Widget? child,
  }) : super(child: child);

  final EdgeInsetsGeometry padding;
}

typedef GestureTapCallback = void Function();

class TapGestureRecognizer extends GestureRecognizer {
  TapGestureRecognizer();
  GestureTapCallback? onTap;
}

abstract class EdgeInsetsGeometry {
  const EdgeInsetsGeometry();
}

class EdgeInsets extends EdgeInsetsGeometry {
  const EdgeInsets.all(double value)
      : left = value,
        right = value,
        top = value,
        bottom = value;

  final double left;
  final double top;
  final double right;
  final double bottom;
}

abstract class Decoration {
  const Decoration();
}

class Color {
  const Color(this.value);
  final int value;

  @override
  String toString() => 'Color(0x${value.toRadixString(16).padLeft(8, '0')})';
}

class BoxDecoration extends Decoration {
  const BoxDecoration({
    this.color,
    this.border,
  });

  final Color? color;
  final BoxBorder? border;
}

abstract class BoxBorder {
  const BoxBorder();
  BorderSide get top;
  BorderSide get bottom;
}

class Border extends BoxBorder {
  const Border({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
  });

  @override
  final BorderSide top;

  @override
  final BorderSide bottom;

  final BorderSide right;

  final BorderSide left;
}

class BorderSide {
  const BorderSide({
    this.color = const Color(0xFF000000),
    this.width = 1.0,
    this.style = BorderStyle.solid,
  });

  final Color color;
  final double width;
  final BorderStyle style;

  static const BorderSide none = BorderSide(
    width: 0.0,
    style: BorderStyle.none,
  );
}

class SizedBox extends SingleChildRenderObjectWidget {
  const SizedBox({this.width, this.height, Widget? child})
      : super(child: child);
  const SizedBox.shrink()
      : width = 0.0,
        height = 0.0;

  final double? width;

  final double? height;
}

class Expanded extends Widget {
  const Expanded({
    required this.child,
  });

  final Widget child;
}

class Container extends Widget {
  const Container({
    this.child,
    this.decoration,
    this.border,
  });

  final BoxDecoration? decoration;
  final Widget? child;
  final BoxBorder? border;
}

class DecoratedBox extends SingleChildRenderObjectWidget {
  DecoratedBox({
    required this.decoration,
    Widget? child,
  }) : super(child: child);
  final Decoration decoration;
}

class InlineSpan {
  InlineSpan({
    this.style,
  });

  final TextStyle? style;
}

class TextSpan extends InlineSpan {
  TextSpan({
    this.text,
    this.semanticsLabel,
    TextStyle? style,
    this.recognizer,
    this.children,
  }) : super(style: style);

  String toPlainText() {
    if (children != null) {
      return children!.map((e) => (e as TextSpan).toPlainText()).join();
    } else {
      return text!;
    }
  }

  final String? text;
  final String? semanticsLabel;
  final GestureRecognizer? recognizer;
  final List<InlineSpan>? children;
}

class GestureRecognizer {}

class TextStyle {
  const TextStyle({
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.backgroundColor,
  });
  TextStyle copyWith({
    String? fontFamily,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
  }) {
    return TextStyle(
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
    );
  }

  TextStyle merge(TextStyle? other) => copyWith(
        fontFamily: other?.fontFamily,
        fontSize: other?.fontSize,
        fontStyle: other?.fontStyle,
        fontWeight: other?.fontWeight,
        color: other?.color,
        backgroundColor: other?.backgroundColor,
      );

  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? fontSize;
  final Color? color;
  final Color? backgroundColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is TextStyle &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.fontStyle == fontStyle &&
        other.fontFamily == fontFamily;
  }

  @override
  int get hashCode => Object.hash(
        color,
        backgroundColor,
        fontSize,
        fontWeight,
        fontStyle,
        fontFamily,
      );
}

class BlockWidget implements Widget {}

class TextWidget implements Widget {}

class TextTheme {
  const TextTheme({
    this.bodyText2,
    this.headline5,
    this.headline6,
    this.subtitle1,
    this.bodyText1,
  });
  final TextStyle? bodyText2;
  final TextStyle? headline5;
  final TextStyle? headline6;
  final TextStyle? subtitle1;
  final TextStyle? bodyText1;
}

class CardTheme {
  const CardTheme({
    this.color,
  });
  final Color? color;
}

class ThemeData {
  ThemeData({
    this.textTheme = const TextTheme(),
  });

  final TextTheme textTheme;
}

enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly
}

enum CrossAxisAlignment { start, end, center, stretch, baseline }

enum TextAlign { left, right, center, justify, start, end }

enum FontStyle { normal, italic }

enum FontWeight { w400, w500, w600, w700 }

enum BorderStyle { none, solid }
