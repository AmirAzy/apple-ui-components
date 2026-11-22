import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/type.dart';
import 'glass.dart';

/// The iOS 27 search field: a glass capsule with a magnifier and a mic.
class IosSearchField extends StatelessWidget {
  const IosSearchField({
    super.key,
    this.controller,
    this.placeholder = 'Search',
    this.onChanged,
    this.brightness = Brightness.light,
    this.height = 42,
  });

  final TextEditingController? controller;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final Brightness brightness;
  final double height;

  @override
  Widget build(BuildContext context) {
    final AppleColorSet colors = AppleColorSet.of(brightness);
    return SizedBox(
      height: height,
      child: IosGlass(
        brightness: brightness,
        radius: height / 2,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: <Widget>[
            Icon(Icons.search, size: 18, color: colors.secondaryLabel),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                cursorColor: colors.accent,
                cursorHeight: 17,
                style: AppleType.iosBody.copyWith(color: colors.label),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: placeholder,
                  hintStyle: AppleType.iosBody.copyWith(color: colors.secondaryLabel),
                ),
              ),
            ),
            Icon(Icons.mic_none, size: 18, color: colors.secondaryLabel),
          ],
        ),
      ),
    );
  }
}
