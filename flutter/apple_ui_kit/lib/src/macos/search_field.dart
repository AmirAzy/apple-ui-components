import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/metrics.dart';
import '../tokens/type.dart';

/// The macOS search field: rounded rectangle, magnifier, grey placeholder.
class MacSearchField extends StatelessWidget {
  const MacSearchField({
    super.key,
    this.controller,
    this.placeholder = 'Search',
    this.onChanged,
    this.brightness = Brightness.light,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final Brightness brightness;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors.controlBackground,
        borderRadius: BorderRadius.circular(AppleMetrics.controlRadius),
        border: Border.all(color: colors.separator, width: 0.5),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.search, size: 13, color: colors.tertiaryLabel),
          const SizedBox(width: 5),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              autofocus: autofocus,
              cursorHeight: 14,
              cursorColor: colors.accent,
              style: AppleType.macBody.copyWith(color: colors.label),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: AppleType.macBody.copyWith(color: colors.tertiaryLabel),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
