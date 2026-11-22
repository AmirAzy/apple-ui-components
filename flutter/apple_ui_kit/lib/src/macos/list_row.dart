import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// A 28 point macOS list row: optional leading icon, optional subtitle,
/// trailing widget, hover and selection states.
class MacListRow extends StatefulWidget {
  const MacListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.onTap,
    this.brightness = Brightness.light,
    this.showDisclosure = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final VoidCallback? onTap;
  final Brightness brightness;
  final bool showDisclosure;

  @override
  State<MacListRow> createState() => _MacListRowState();
}

class _MacListRowState extends State<MacListRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(widget.brightness);
    final bool twoLines = widget.subtitle != null;
    final Color background = widget.selected
        ? colors.accent.withValues(alpha: 0.88)
        : _hovered
            ? colors.fill
            : const Color(0x00000000);
    final Color foreground =
        widget.selected ? const Color(0xFFFFFFFF) : colors.label;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppleMetrics.fast,
          constraints: const BoxConstraints(minHeight: AppleMetrics.listRowHeight),
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: twoLines ? 5 : 0,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppleMetrics.smallControlRadius),
          ),
          child: Row(
            children: <Widget>[
              if (widget.leading != null) ...<Widget>[
                IconTheme(
                  data: IconThemeData(size: 15, color: foreground),
                  child: widget.leading!,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: AppleType.macSidebarRow.copyWith(color: foreground),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (twoLines)
                      Text(
                        widget.subtitle!,
                        style: AppleType.macSmall.copyWith(
                          color: widget.selected
                              ? const Color(0xB3FFFFFF)
                              : colors.secondaryLabel,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
              if (widget.showDisclosure)
                Icon(
                  Icons.chevron_right,
                  size: 15,
                  color: widget.selected
                      ? const Color(0xB3FFFFFF)
                      : colors.tertiaryLabel,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
