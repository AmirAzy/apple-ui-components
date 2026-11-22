import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// Big Sur push button variants.
enum MacButtonStyle {
  /// White fill, hairline border: the default action in a window.
  standard,

  /// Accent fill: the one action the window is about.
  primary,

  /// Red text, no fill: destructive actions.
  destructive,
}

/// A macOS push button, 22 to 28 points tall depending on [large].
class MacButton extends StatefulWidget {
  const MacButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style = MacButtonStyle.standard,
    this.icon,
    this.brightness = Brightness.light,
    this.large = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final MacButtonStyle style;
  final IconData? icon;
  final Brightness brightness;
  final bool large;
  final bool expand;

  @override
  State<MacButton> createState() => _MacButtonState();
}

class _MacButtonState extends State<MacButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(widget.brightness);
    final bool enabled = widget.onPressed != null;

    late final Color background;
    late final Color foreground;
    switch (widget.style) {
      case MacButtonStyle.standard:
        background = _pressed
            ? colors.controlBackground.withValues(alpha: 0.72)
            : colors.controlBackground;
        foreground = colors.label;
      case MacButtonStyle.primary:
        background = colors.accent.withValues(alpha: _pressed ? 0.78 : 1);
        foreground = const Color(0xFFFFFFFF);
      case MacButtonStyle.destructive:
        background = _pressed
            ? colors.controlBackground.withValues(alpha: 0.72)
            : colors.controlBackground;
        foreground = const Color(0xFFFF453A);
    }

    final Widget content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (widget.icon != null) ...<Widget>[
          Icon(widget.icon, size: 13, color: foreground),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: AppleType.macBody.copyWith(
              color: foreground,
              fontWeight:
                  widget.style == MacButtonStyle.primary ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          duration: AppleMetrics.fast,
          opacity: enabled ? 1 : 0.45,
          child: Container(
            height: widget.large ? 28 : 22,
            padding: EdgeInsets.symmetric(horizontal: widget.large ? 14 : 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppleMetrics.controlRadius),
              border: Border.all(
                color: widget.style == MacButtonStyle.primary
                    ? const Color(0x14000000)
                    : colors.separator,
                width: 0.5,
              ),
              boxShadow: widget.style == MacButtonStyle.primary
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colors.accent.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
