import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// An iOS 27 navigation bar. With [largeTitle] it shows the 34 point title and
/// a soft glass edge behind the bar; without it, the 17 point inline title
/// every pushed screen gets.
class IosNavBar extends StatelessWidget {
  const IosNavBar({
    super.key,
    required this.title,
    this.largeTitle = true,
    this.brightness = Brightness.light,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.subtitle,
  });

  final String title;
  final bool largeTitle;
  final Brightness brightness;
  final List<Widget> leading;
  final List<Widget> trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);

    final Widget row = SizedBox(
      height: AppleMetrics.iosNavBarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            ...leading,
            Expanded(
              child: largeTitle
                  ? const SizedBox.shrink()
                  : Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppleType.iosHeadline.copyWith(color: colors.label),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            ...trailing,
          ],
        ),
      ),
    );

    if (!largeTitle) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.separator, width: 0.5)),
        ),
        child: row,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: AppleType.iosLargeTitle.copyWith(color: colors.label),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: AppleType.iosFootnote.copyWith(color: colors.secondaryLabel),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
