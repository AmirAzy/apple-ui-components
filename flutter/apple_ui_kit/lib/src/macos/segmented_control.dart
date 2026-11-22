import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// Big Sur segmented control: a grey track with a white sliding thumb.
///
/// Widths are measured, not assumed. Inside a `Row` (a toolbar, say) the
/// incoming width is unbounded, so each segment gets its label width plus
/// padding; given a bounded width the segments split it evenly. The track is a
/// fixed-width [SizedBox] inside a [Container] with no width of its own, so the
/// 0.5 border and the 2 point inset can never clip a segment by a pixel.
class MacSegmentedControl extends StatelessWidget {
  const MacSegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.height = 24,
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

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 2 points of padding on each side plus the 0.5 hairline border.
        final double inner = constraints.maxWidth.isFinite
            ? constraints.maxWidth - 5
            : double.infinity;

        final List<double> widths;
        if (inner.isFinite) {
          widths = List<double>.filled(count, inner / count);
        } else {
          final TextStyle style =
              AppleType.macBody.copyWith(fontWeight: FontWeight.w600);
          widths = <double>[
            for (final String segment in segments)
              (TextPainter(
                text: TextSpan(text: segment, style: style),
                textDirection: TextDirection.ltr,
                maxLines: 1,
              )..layout())
                  .width +
                  24,
          ];
        }

        final double total =
            widths.fold<double>(0, (double a, double b) => a + b);
        double thumbLeft = 0;
        for (int i = 0; i < selected; i++) {
          thumbLeft += widths[i];
        }

        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            height: height,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: colors.fill,
              // ignore: prefer_const_constructors
              borderRadius: BorderRadius.circular(AppleMetrics.controlRadius),
              border: Border.all(color: colors.separator, width: 0.5),
            ),
            child: SizedBox(
              width: total,
              child: Stack(
                children: <Widget>[
                  AnimatedPositioned(
                    duration: AppleMetrics.fast,
                    curve: Curves.easeOutCubic,
                    left: thumbLeft,
                    top: 0,
                    bottom: 0,
                    width: widths[selected],
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.controlBackground,
                        borderRadius: BorderRadius.circular(
                          AppleMetrics.smallControlRadius,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: 4,
                            offset: const Offset(0, 1),
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
                              style: AppleType.macBody.copyWith(
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
        );
      },
    );
  }
}
