import 'package:flutter/material.dart';

import '../../../../extensions/context_extension.dart';

/// A themed horizontal divider using [ColorScheme.outlineVariant].

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  /// 2-pt visually prominent divider — use between major content sections.
  const AppDivider.thick({
    super.key,
    this.height = 2,
    this.thickness = 2,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.theme.colorScheme.outlineVariant,
    );
  }
}

/// A themed vertical divider using [ColorScheme.outlineVariant].

class AppVerticalDivider extends StatelessWidget {
  const AppVerticalDivider({
    super.key,
    this.width = 1,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  });

  final double width;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? context.theme.colorScheme.outlineVariant,
    );
  }
}
