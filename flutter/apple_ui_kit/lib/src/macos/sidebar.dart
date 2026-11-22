import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// One row of a macOS sidebar.
@immutable
class MacSidebarItem {
  const MacSidebarItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.badge,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final String? badge;
}

/// A titled group of sidebar rows.
@immutable
class MacSidebarSection {
  const MacSidebarSection({required this.title, required this.items});

  final String title;
  final List<MacSidebarItem> items;
}

/// Big Sur source list: translucent column, 28 point rows, accent selection.
class MacSidebar extends StatelessWidget {
  const MacSidebar({
    super.key,
    required this.sections,
    this.brightness = Brightness.light,
    this.width = 216,
    this.header,
    this.footer,
    this.onSelect,
  });

  final List<MacSidebarSection> sections;
  final Brightness brightness;
  final double width;
  final Widget? header;
  final Widget? footer;
  final void Function(int section, int index)? onSelect;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    return SizedBox(
      width: width,
      child: ColoredBox(
        color: colors.sidebarBackground,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          children: <Widget>[
            if (header != null) ...<Widget>[header!, const SizedBox(height: 8)],
            for (int s = 0; s < sections.length; s++) ...<Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
                child: Text(
                  sections[s].title.toUpperCase(),
                  style: AppleType.macSidebarSection.copyWith(
                    color: colors.tertiaryLabel,
                  ),
                ),
              ),
              for (int i = 0; i < sections[s].items.length; i++)
                _MacSidebarRow(
                  item: sections[s].items[i],
                  colors: colors,
                  onTap: onSelect == null ? null : () => onSelect!(s, i),
                ),
            ],
            if (footer != null) ...<Widget>[const SizedBox(height: 12), footer!],
          ],
        ),
      ),
    );
  }
}

class _MacSidebarRow extends StatefulWidget {
  const _MacSidebarRow({
    required this.item,
    required this.colors,
    this.onTap,
  });

  final MacSidebarItem item;
  final AppleColorSet colors;
  final VoidCallback? onTap;

  @override
  State<_MacSidebarRow> createState() => _MacSidebarRowState();
}

class _MacSidebarRowState extends State<_MacSidebarRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool selected = widget.item.selected;
    final Color background = selected
        ? widget.colors.accent.withValues(alpha: 0.88)
        : _hovered
            ? widget.colors.fill
            : const Color(0x00000000);
    final Color foreground =
        selected ? const Color(0xFFFFFFFF) : widget.colors.label;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppleMetrics.fast,
          height: AppleMetrics.sidebarRowHeight,
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppleMetrics.smallControlRadius),
          ),
          child: Row(
            children: <Widget>[
              Icon(widget.item.icon, size: 15, color: foreground),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: AppleType.macSidebarRow.copyWith(color: foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.badge != null)
                Text(
                  widget.item.badge!,
                  style: AppleType.macSmall.copyWith(
                    color: selected
                        ? const Color(0xB3FFFFFF)
                        : widget.colors.secondaryLabel,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
