import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';
import 'glass.dart';

/// iOS 27 segmented control: a glass capsule, a white thumb that slides under
/// the selection, 15 point labels.
///
/// Same sizing rule as the macOS control: measured when the width is
/// unbounded, shared evenly when it is not. The capsule hugs its content so
/// the blur, the 3 point inset and the hairline border cannot clip a label.
class IosSegmentedControl extends StatelessWidget {
  const IosSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.height = 34,
  });

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Brightness brightness;
  final double height;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    final int count = segments.length;
    final int selected = selectedIndex.clamp(0, count - 1);
    const double inset = 3;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double inner = constraints.maxWidth.isFinite
            ? constraints.maxWidth - inset * 2 - 1
            : double.infinity;

        final List<double> widths;
        if (inner.isFinite) {
          widths = List<double>.filled(count, inner / count);
        } else {
          final TextStyle style =
              AppleType.iosSubhead.copyWith(fontWeight: FontWeight.w600);
          widths = <double>[
            for (final String segment in segments)
              (TextPainter(
                text: TextSpan(text: segment, style: style),
                textDirection: TextDirection.ltr,
                maxLines: 1,
              )..layout())
                  .width +
                  28,
          ];
        }

        final double total =
            widths.fold<double>(0, (double a, double b) => a + b);
        double thumbLeft = 0;
        for (int i = 0; i < selected; i++) {
          thumbLeft += widths[i];
        }

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: height,
            child: IosGlass(
              brightness: brightness,
              radius: height / 2,
              padding: const EdgeInsets.all(inset),
              child: SizedBox(
                width: total,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: AppleMetrics.normal,
                      curve: Curves.easeOutCubic,
                      left: thumbLeft,
                      top: 0,
                      bottom: 0,
                      width: widths[selected],
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.controlBackground,
                          borderRadius: BorderRadius.circular(height / 2),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: colors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(count, (int index) {
                        final bool isSelected = index == selected;
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onChanged(index),
                          child: SizedBox(
                            width: widths[index],
                            child: Center(
                              child: Text(
                                segments[index],
                                style: AppleType.iosSubhead.copyWith(
                                  color: isSelected
                                      ? colors.label
                                      : colors.secondaryLabel,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
