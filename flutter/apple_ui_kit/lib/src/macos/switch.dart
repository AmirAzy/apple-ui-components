import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';

/// macOS 11 switch: 38 by 22, accent when on, no ripple.
class MacSwitch extends StatelessWidget {
  const MacSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Brightness brightness;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    final bool enabled = onChanged != null;
    const double inset = 2;
    const double thumb = AppleMetrics.macSwitchHeight - inset * 2;

    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: AnimatedContainer(
            duration: AppleMetrics.fast,
            curve: Curves.easeOutCubic,
            width: AppleMetrics.macSwitchWidth,
            height: AppleMetrics.macSwitchHeight,
            padding: const EdgeInsets.all(inset),
            decoration: BoxDecoration(
              color: value ? colors.accent : colors.fill,
              borderRadius: BorderRadius.circular(AppleMetrics.macSwitchHeight / 2),
              border: Border.all(
                color: value ? const Color(0x1A000000) : colors.separator,
                width: 0.5,
              ),
            ),
            child: AnimatedAlign(
              duration: AppleMetrics.fast,
              curve: Curves.easeOutCubic,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: thumb,
                height: thumb,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
