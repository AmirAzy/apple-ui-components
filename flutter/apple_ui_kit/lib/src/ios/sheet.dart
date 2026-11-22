import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';
import 'glass.dart';

/// The sheet surface itself: grabber, 34 point top corners, glass, and the
/// drag-to-dismiss gesture iOS uses instead of a close button.
class IosSheet extends StatelessWidget {
  const IosSheet({
    super.key,
    required this.child,
    this.title,
    this.brightness = Brightness.light,
    this.onDismiss,
    this.showGrabber = true,
    this.contentPadding = const EdgeInsets.fromLTRB(20, 0, 20, 24),
  });

  final Widget child;
  final String? title;
  final Brightness brightness;
  final VoidCallback? onDismiss;
  final bool showGrabber;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);

    final Widget surface = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showGrabber)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: AppleMetrics.sheetGrabberWidth,
              height: AppleMetrics.sheetGrabberHeight,
              decoration: BoxDecoration(
                color: colors.tertiaryLabel,
                borderRadius: BorderRadius.circular(AppleMetrics.sheetGrabberHeight / 2),
              ),
            ),
          ),
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title!,
                    style: AppleType.iosTitle2.copyWith(color: colors.label),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onDismiss != null)
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: colors.fill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 17, color: colors.secondaryLabel),
                    ),
                  ),
              ],
            ),
          ),
        Padding(padding: contentPadding, child: child),
      ],
    );

    final Widget glass = IosGlass(
      brightness: brightness,
      radius: AppleMetrics.sheetRadius,
      child: surface,
    );

    if (onDismiss == null) {
      return glass;
    }

    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if ((details.primaryVelocity ?? 0) > 240) {
          onDismiss!();
        }
      },
      child: glass,
    );
  }
}
