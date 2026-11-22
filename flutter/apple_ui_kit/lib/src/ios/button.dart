import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// iOS 27 button emphasis.
enum IosButtonStyle {
  /// Accent fill, white label: the primary action.
  filled,

  /// 15 percent accent fill, accent label: secondary actions.
  tinted,

  /// No fill, accent label: the quiet action.
  plain,
}

/// A capsule iOS button, 50 points tall, with the press-down that makes it
/// feel like a physical control.
class IosButton extends StatefulWidget {
  const IosButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = IosButtonStyle.filled,
    this.icon,
    this.brightness = Brightness.light,
    this.expand = true,
    this.height = 50,
  });

  final String label;
  final VoidCallback? onPressed;
  final IosButtonStyle style;
  final IconData? icon;
  final Brightness brightness;
  final bool expand;
  final double height;

  @override
  State<IosButton> createState() => _IosButtonState();
}

class _IosButtonState extends State<IosButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(widget.brightness);
    final bool enabled = widget.onPressed != null;

    late final Color background;
    late final Color foreground;
    switch (widget.style) {
      case IosButtonStyle.filled:
        background = colors.accent;
        foreground = const Color(0xFFFFFFFF);
      case IosButtonStyle.tinted:
        background = colors.accent.withValues(alpha: 0.15);
        foreground = colors.accent;
      case IosButtonStyle.plain:
        background = const Color(0x00000000);
        foreground = colors.accent;
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          duration: AppleMetrics.fast,
          scale: _pressed ? 0.97 : 1,
          child: AnimatedOpacity(
            duration: AppleMetrics.fast,
            opacity: enabled ? (_pressed ? 0.85 : 1) : 0.45,
            child: Container(
              height: widget.height,
              width: widget.expand ? double.infinity : null,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
              child: Row(
                mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.icon != null) ...<Widget>[
                    Icon(widget.icon, size: 18, color: foreground),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: AppleType.iosHeadline.copyWith(color: foreground),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
