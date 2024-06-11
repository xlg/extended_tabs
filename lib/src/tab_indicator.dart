import 'package:flutter/material.dart';

class ColorTabIndicator extends Decoration {
  const ColorTabIndicator(this.color);

  /// The color and weight of the horizontal line drawn below the selected tab.
  final Color color;

  @override
  _ColorPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ColorPainter(this, onChanged);
  }
}

class _ColorPainter extends BoxPainter {
  _ColorPainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final ColorTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final Paint paint = Paint();
    paint.color = decoration.color;
    canvas.drawRect(rect, paint);
  }
}

/// Used with [TabBar.indicator] to draw a horizontal line below the
/// selected tab.
///
/// The selected tab underline is inset from the tab's boundary by [insets].
/// The [borderSide] defines the line's color and weight.
///
/// The [TabBar.indicatorSize] property can be used to define the indicator's
/// bounds in terms of its (centered) widget with [TabBarIndicatorSize.label],
/// or the entire tab with [TabBarIndicatorSize.tab].
class ExtendedUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments must not be null.
  const ExtendedUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.indicatorRadius = 0.0,
    this.insets = EdgeInsets.zero,
    this.scrollDirection = Axis.horizontal,
    this.strokeCap = StrokeCap.square,
    this.size,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  final double indicatorRadius;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Styles to use for line endings.
  final StrokeCap strokeCap;

  /// if Axis.horizontal , it's width.
  /// otherwise is height.
  /// if null, it's base on Tab
  final double? size;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is ExtendedUnderlineTabIndicator) {
      return ExtendedUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        indicatorRadius: a.indicatorRadius,
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
        scrollDirection: a.scrollDirection,
        size: a.size,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is ExtendedUnderlineTabIndicator) {
      return ExtendedUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        indicatorRadius: b.indicatorRadius,
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
        scrollDirection: b.scrollDirection,
        size: b.size,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _UnderlinePainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  Rect _indicatorRectFor(
      Rect rect, TextDirection textDirection, Axis scrollDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return scrollDirection == Axis.horizontal
        ? Rect.fromLTWH(
            indicator.left + (size != null ? (indicator.width - size!) / 2 : 0),
            indicator.bottom - borderSide.width,
            size ?? indicator.width,
            borderSide.width,
          )
        : Rect.fromLTWH(
            textDirection == TextDirection.rtl
                ? indicator.left
                : indicator.right - borderSide.width,
            indicator.top + (size != null ? (indicator.height - size!) / 2 : 0),
            borderSide.width,
            size ?? indicator.height,
          );
  }

  ///绘制圆角矩形的Paint
  Paint _indicatorCirclePaint(){
    return Paint()
        ..style = PaintingStyle.fill
      ..color = borderSide.color;
    ;
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()
      ..addRect(_indicatorRectFor(rect, textDirection, scrollDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final ExtendedUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection, decoration.scrollDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = decoration.strokeCap;

    RRect? rrect;
    if (decoration.indicatorRadius > 0) {
      // 起点和终点
      final startPoint = indicator.topLeft;
      final endPoint = indicator.topRight;

      // 计算线的长度和角度
      final lineLength = (endPoint - startPoint).distance;
      final angle = (endPoint - startPoint).direction;

      // 定义矩形的宽度（即线的宽度）和高度（即线的厚度）
      final lineWidth = lineLength;
      final double lineThickness = decoration.borderSide.width; // 线的厚度
      final radius = Radius.circular(lineThickness / 2);

      // 创建一个带圆角的矩形
      final nrect = Rect.fromLTWH(
        startPoint.dx,
        startPoint.dy - lineThickness / 2,
        lineWidth,
        lineThickness,
      );
       rrect = RRect.fromRectAndRadius(nrect, radius);
    }

    // final rrect = RRect.fromLTRBR(startPoint.dx, startPoint.dy, endPoint.dx, endPoint.dy+5, Radius.circular(5));
    switch (decoration.scrollDirection) {
      case Axis.horizontal:
        if (decoration.indicatorRadius > 0 && rrect != null) {
          canvas.drawRRect(
              rrect,
              decoration._indicatorCirclePaint());
        } else {
          canvas.drawLine(indicator.bottomLeft, indicator.bottomRight,paint);
        }

        break;
      case Axis.vertical:
        canvas.drawLine(indicator.topRight, indicator.bottomRight, paint);
        break;
      default:
    }
  }
}
