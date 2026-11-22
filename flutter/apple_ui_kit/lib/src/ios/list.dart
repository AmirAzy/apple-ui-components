import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';
import 'glass.dart';

/// One row inside an [IosListSection].
class IosListTile extends StatelessWidget {
  const IosListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leadingColor,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.showSeparator = true,
    this.brightness = Brightness.light,
  });

  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showSeparator;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(minHeight: AppleMetrics.iosRowHeight),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: <Widget>[
                if (leadingIcon != null) ...<Widget>[
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      color: leadingColor ?? colors.accent,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(leadingIcon, size: 17, color: const Color(0xFFFFFFFF)),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        title,
                        style: AppleType.iosBody.copyWith(color: colors.label),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            subtitle!,
                            style: AppleType.iosFootnote.copyWith(color: colors.secondaryLabel),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...<Widget>[const SizedBox(width: 8), trailing!],
                if (showChevron)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(Icons.chevron_right, size: 18, color: colors.tertiaryLabel),
                  ),
              ],
            ),
          ),
          if (showSeparator)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(height: 0.5, child: ColoredBox(color: colors.separator)),
            ),
        ],
      ),
    );
  }
}

/// An inset grouped list: a small upper-case header, a glass card of rows, and
/// an optional footnote. This is the shape almost every iOS settings screen has.
class IosListSection extends StatelessWidget {
  const IosListSection({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.brightness = Brightness.light,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppleMetrics.iosGroupInset,
      vertical: 10,
    ),
  });

  final List<Widget> children;
  final String? header;
  final String? footer;
  final Brightness brightness;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 7),
              child: Text(
                header!.toUpperCase(),
                style: AppleType.iosFootnote.copyWith(color: colors.secondaryLabel),
              ),
            ),
          IosGlass(
            brightness: brightness,
            radius: AppleMetrics.cardRadius,
            child: Column(children: children),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 0),
              child: Text(
                footer!,
                style: AppleType.iosFootnote.copyWith(color: colors.secondaryLabel),
              ),
            ),
        ],
      ),
    );
  }
}
