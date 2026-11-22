import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// A Big Sur window: rounded shell, soft shadow, traffic lights, optional
/// sidebar and toolbar.
///
/// The chrome is drawn, not faked with a screenshot: the three lights are
/// widgets, the toolbar is a row, and the sidebar is whatever you pass in.
class MacWindow extends StatelessWidget {
  const MacWindow({
    super.key,
    required this.child,
    this.title = '',
    this.brightness = Brightness.light,
    this.sidebar,
    this.toolbarLeading = const <Widget>[],
    this.toolbarTrailing = const <Widget>[],
    this.width,
    this.height,
    this.showTrafficLights = true,
    this.onTrafficLightTap,
  });

  final Widget child;
  final String title;
  final Brightness brightness;
  final Widget? sidebar;
  final List<Widget> toolbarLeading;
  final List<Widget> toolbarTrailing;
  final double? width;
  final double? height;
  final bool showTrafficLights;
  final ValueChanged<int>? onTrafficLightTap;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    final Widget body = sidebar == null
        ? child
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              sidebar!,
              _VerticalDivider(colors: colors),
              Expanded(child: child),
            ],
          );

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.windowBackground,
          borderRadius: BorderRadius.circular(AppleMetrics.windowRadius),
          border: Border.all(color: colors.separator, width: 0.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadow,
              blurRadius: 42,
              offset: const Offset(0, 18),
              spreadRadius: -6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppleMetrics.windowRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _TitleBar(
                title: title,
                colors: colors,
                showTrafficLights: showTrafficLights,
                leading: toolbarLeading,
                trailing: toolbarTrailing,
                onTrafficLightTap: onTrafficLightTap,
              ),
              _VerticalDivider(colors: colors, horizontal: true),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({
    required this.title,
    required this.colors,
    required this.showTrafficLights,
    required this.leading,
    required this.trailing,
    this.onTrafficLightTap,
  });

  final String title;
  final AppleColorSet colors;
  final bool showTrafficLights;
  final List<Widget> leading;
  final List<Widget> trailing;
  final ValueChanged<int>? onTrafficLightTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppleMetrics.toolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: <Widget>[
            if (showTrafficLights)
              _TrafficLights(onTap: onTrafficLightTap)
            else
              const SizedBox.shrink(),
            const SizedBox(width: 14),
            ...leading,
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: AppleType.macTitle.copyWith(color: colors.label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            ...trailing,
          ],
        ),
      ),
    );
  }
}

class _TrafficLights extends StatelessWidget {
  const _TrafficLights({this.onTap});

  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    const List<Color> swatches = <Color>[
      AppleColorSet.closeButton,
      AppleColorSet.minimiseButton,
      AppleColorSet.zoomButton,
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(swatches.length, (int index) {
        return Padding(
          padding: EdgeInsets.only(
            right: index == swatches.length - 1 ? 0 : AppleMetrics.trafficLightGap,
          ),
          child: GestureDetector(
            onTap: onTap == null ? null : () => onTap!(index),
            child: Container(
              width: AppleMetrics.trafficLightSize,
              height: AppleMetrics.trafficLightSize,
              decoration: BoxDecoration(
                color: swatches[index],
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x1F000000), width: 0.5),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider({required this.colors, this.horizontal = false});

  final AppleColorSet colors;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: horizontal ? null : 0.5,
      height: horizontal ? 0.5 : null,
      child: ColoredBox(color: colors.separator),
    );
  }
}
