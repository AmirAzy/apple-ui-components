import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';
import 'glass.dart';

/// One destination of an [IosTabBar].
@immutable
class IosTabItem {
  const IosTabItem({required this.icon, required this.label, this.activeIcon});

  final IconData icon;
  final String label;
  final IconData? activeIcon;
}

/// The iOS 27 floating tab bar: a glass capsule over the content, icons and
/// small labels, one destination filled with the accent colour.
class IosTabBar extends StatelessWidget {
  const IosTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.brightness = Brightness.light,
    this.floating = true,
  });

  final List<IosTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Brightness brightness;
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);

    final Widget bar = SizedBox(
      height: AppleMetrics.iosTabBarHeight,
      child: Row(
        children: List<Widget>.generate(items.length, (int index) {
          final bool selected = index == selectedIndex;
          final Color color = selected ? colors.accent : colors.secondaryLabel;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    selected ? (items[index].activeIcon ?? items[index].icon) : items[index].icon,
                    size: 23,
                    color: color,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[index].label,
                    style: AppleType.iosTabLabel.copyWith(
                      color: color,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );

    if (!floating) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.glassTint,
          border: Border(top: BorderSide(color: colors.separator, width: 0.5)),
        ),
        child: bar,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: IosGlass(
        brightness: brightness,
        radius: AppleMetrics.iosTabBarHeight / 2,
        child: bar,
      ),
    );
  }
}
