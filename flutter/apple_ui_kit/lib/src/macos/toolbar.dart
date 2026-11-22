import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// A standalone macOS toolbar strip, for windows that build their own chrome.
class MacToolbar extends StatelessWidget {
  const MacToolbar({
    super.key,
    this.title = '',
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.brightness = Brightness.light,
    this.showSeparator = true,
  });

  final String title;
  final List<Widget> leading;
  final List<Widget> trailing;
  final Brightness brightness;
  final bool showSeparator;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    return Container(
      height: AppleMetrics.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.windowBackground,
        border: showSeparator
            ? Border(bottom: BorderSide(color: colors.separator, width: 0.5))
            : null,
      ),
      child: Row(
        children: <Widget>[
          ...leading,
          if (leading.isNotEmpty) const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppleType.macTitle.copyWith(color: colors.label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }
}
