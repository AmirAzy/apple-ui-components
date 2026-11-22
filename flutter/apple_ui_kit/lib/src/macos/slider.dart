import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';

/// macOS slider: a 4 point track, a small round thumb, drag anywhere.
class MacSlider extends StatelessWidget {
  const MacSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.min = 0,
    this.max = 1,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final Brightness brightness;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    final double fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double trackHeight = 4;
        const double thumbSize = 18;
        final double usable = constraints.maxWidth - thumbSize;

        void update(Offset local) {
          final double x = (local.dx - thumbSize / 2).clamp(0.0, usable);
          onChanged(min + (x / usable) * (max - min));
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (DragUpdateDetails d) => update(d.localPosition),
          onTapDown: (TapDownDetails d) => update(d.localPosition),
          child: SizedBox(
            height: thumbSize,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color: colors.fill,
                    borderRadius: BorderRadius.circular(trackHeight / 2),
                    border: Border.all(color: colors.separator, width: 0.5),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: usable * (1 - fraction)),
                  child: Container(
                    height: trackHeight,
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(trackHeight / 2),
                    ),
                  ),
                ),
                Positioned(
                  left: usable * fraction,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: colors.controlBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.separator, width: 0.5),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
