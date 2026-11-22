import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';

/// The iOS 27 surface: a blurred, lightly tinted pane with a hairline stroke.
///
/// Blur is doing the design work here, so the widget must clip: an unclipped
/// [BackdropFilter] blurs the whole layer behind it and costs far more than it
/// looks like it should.
class IosGlass extends StatelessWidget {
  const IosGlass({
    super.key,
    required this.child,
    this.radius = AppleMetrics.cardRadius,
    this.brightness = Brightness.light,
    this.blur = AppleMetrics.glassBlur,
    this.tint,
    this.padding = EdgeInsets.zero,
    this.showStroke = true,
  });

  final Widget child;
  final double radius;
  final Brightness brightness;
  final double blur;
  final Color? tint;
  final EdgeInsetsGeometry padding;
  final bool showStroke;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? colors.glassTint,
            borderRadius: BorderRadius.circular(radius),
            border: showStroke
                ? Border.all(color: colors.glassStroke, width: 0.5)
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
