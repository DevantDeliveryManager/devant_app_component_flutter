import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';

import '../../extensions/context_extension.dart';


/// Named logo sizes, each resolving to a mobile/tablet pair so the mark
/// stays proportional on both form factors.
enum AppLogoSize {
  /// App bars, compact headers.
  small,

  /// Cards, dialogs, inline branding.
  medium,

  /// Splash and onboarding hero branding.
  large,
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = AppLogoSize.medium,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    required this.logoUrl,
  });

  /// Named size, used when [height] is not supplied.
  final AppLogoSize size;

  /// Explicit height in logical pixels; overrides [size].
  final double? height;

  final BoxFit fit;

  /// Tints the mark — for single-colour contexts such as a dark app bar.
  final Color? color;

  /// logo url
  final String logoUrl;

  double _resolveHeight(BuildContext context) {
    if (height != null) return height!;

    return switch (size) {
      AppLogoSize.small => context.adaptive<double>(mobile: 32, tablet: 40),
      AppLogoSize.medium => context.adaptive<double>(mobile: 56, tablet: 72),
      AppLogoSize.large => context.adaptive<double>(mobile: 96, tablet: 148),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      logoUrl,
      height: _resolveHeight(context),
      fit: fit,
      color: color,
      // The artwork is decorative here; the wordmark is not read as content.
      excludeFromSemantics: true,
      // Keeps layouts intact if the asset hasn't been added yet.
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: _resolveHeight(context),
      ),
    );
  }
}
