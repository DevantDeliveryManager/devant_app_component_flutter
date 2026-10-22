/// Font families declared under `flutter: fonts:` in `pubspec.yaml`.
library;

import 'package:flutter/material.dart';

abstract final class AppFonts {
  AppFonts._();

  /// Quicksand — weights 300, 400, 500, 600, 700.
  // static const String quicksand = 'Quicksand';

  static const String inter = 'Inter';

  /// Playfair — weights 300, 400 (+ italic), 500, 600, 700.
  static const String playfair9pt = 'Playfair9pt';
  static const String playfair144pt = 'Playfair144pt';

  /// The font the whole app uses unless a widget picks another.
  static const String defaultFamily = inter;
}

/// Switches a [TextStyle] to another font family, keeping everything else.
///
/// ```dart
/// Text('Hello', style: context.textTheme.bodyLarge?.inter)
/// ```
extension AppFontStyle on TextStyle {
  TextStyle get playfair9pt => copyWith(fontFamily: AppFonts.playfair9pt);
  TextStyle get playfair144pt => copyWith(fontFamily: AppFonts.playfair144pt);
  TextStyle get inter => copyWith(fontFamily: AppFonts.inter);


  /// Any other family, e.g. `style.withFont(AppFonts.inter)`.
  TextStyle withFont(String family) => copyWith(fontFamily: family);
}

/// Applies a font family to a whole subtree, so every [Text] under it,
/// including ones with theme styles, uses it.
///
/// ```dart
/// AppFontScope(family: AppFonts.inter, child: MyForm())
/// ```
class AppFontScope extends StatelessWidget {
  const AppFontScope({super.key, required this.family, required this.child});

  final String family;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme.apply(fontFamily: family),
        primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: family),
      ),
      child: DefaultTextStyle.merge(
        style: TextStyle(fontFamily: family),
        child: child,
      ),
    );
  }
}
