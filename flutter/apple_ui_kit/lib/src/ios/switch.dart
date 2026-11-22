import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';

/// The iOS 27 switch: 51 by 31, green by default, white 27 point thumb.
class IosSwitch extends StatelessWidget {
  const IosSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.activeColor = const Color(0xFF34C759),
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Brightness brightness;
  final Color activeColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    const double pad = (AppleMetrics.iosSwitchHeight - AppleMetrics.iosSwitchThumb) / 2;
    final bool enabled = onChanged != null;

    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: AnimatedContainer(
            duration: AppleMetrics.normal,
            curve: Curves.easeOutCubic,
            width: AppleMetrics.iosSwitchWidth,
            height: AppleMetrics.iosSwitchHeight,
            padding: const EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: value ? activeColor : AppleColorSet.of(brightness).fill,
              borderRadius: BorderRadius.circular(AppleMetrics.iosSwitchHeight / 2),
            ),
            child: AnimatedAlign(
              duration: AppleMetrics.normal,
              curve: Curves.easeOutCubic,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: AppleMetrics.iosSwitchThumb,
                height: AppleMetrics.iosSwitchThumb,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
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
