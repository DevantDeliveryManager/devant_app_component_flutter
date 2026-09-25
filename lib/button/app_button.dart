import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_platform.dart';
import '../enums/button_varient.dart';

/// A themed button supporting all [ButtonVariant]s and [ButtonSize]s.
///
/// Renders Material or Cupertino based on [platform] / [AppPlatformScope].
/// Colors default to the ambient [ThemeData.colorScheme]; every dimension,
/// color, radius and animation value can be overridden via parameters, so the
/// widget has no dependency on any app-specific tokens or screen-scaling
/// package. Pass already-scaled values (e.g. `16.w`) if your app scales sizes.
///
/// Usage:
/// ```dart
/// AppButton(
///   label: 'Save',
///   onPressed: _save,
///   variant: ButtonVariant.primary,
///   height: ButtonSize.large,
///   isLoading: state.isLoading,
///   borderRadius: BorderRadius.circular(12),
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Creates a button.
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.color,
    this.textColor,
    this.borderColor,
    this.height = ButtonSize.medium,
    this.width,
    this.isLoading = false,
    this.isFullWidth = false,
    this.prefixIcon,
    this.suffixIcon,
    this.platform,
    this.heightValue,
    this.widthValue,
    this.horizontalPadding,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderWidth = 1.5,
    this.iconSpacing = 8,
    this.loaderSize = 20,
    this.loaderStrokeWidth = 2,
    this.disabledOpacity = 0.6,
    this.disabledTextOpacity = 0.5,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOut,
    this.successColor,
    this.onSuccessColor,
    this.semanticLabel,
  });

  /// Text shown inside the button.
  final String label;

  /// Called when tapped. A null value (or [isLoading]) disables the button.
  final VoidCallback? onPressed;

  /// Visual style of the button.
  final ButtonVariant variant;

  /// Background color override for filled variants. Defaults come from the
  /// theme's color scheme.
  final Color? color;

  /// Label/icon color override.
  final Color? textColor;

  /// Outlines the button regardless of [variant] — lets a filled button carry
  /// a hairline border (social sign-in rows, cards on tinted surfaces).
  final Color? borderColor;

  /// Preset size controlling height, padding and font size.
  final ButtonSize height;

  /// Preset width. Ignored when [widthValue] or [isFullWidth] is set.
  final ButtonSize? width;

  /// Shows a loader in place of the content and disables the button.
  final bool isLoading;

  /// Expands the button to the available width.
  final bool isFullWidth;

  /// Widget shown before the label.
  final Widget? prefixIcon;

  /// Widget shown after the label.
  final Widget? suffixIcon;

  /// Overrides Material/Cupertino rendering for this button.
  final AppPlatformStyle? platform;

  /// Explicit height in logical pixels; overrides the [height] preset.
  final double? heightValue;

  /// Explicit width in logical pixels; overrides the [width] preset.
  final double? widthValue;

  /// Explicit horizontal padding; overrides the [height] preset padding.
  final double? horizontalPadding;

  /// Explicit label font size; overrides the [height] preset font size.
  final double? fontSize;

  /// Label font weight.
  final FontWeight fontWeight;

  /// Corner radius of the button.
  final BorderRadius borderRadius;

  /// Width of the border for [ButtonVariant.outline] or when [borderColor]
  /// is set.
  final double borderWidth;

  /// Gap between the label and the prefix/suffix icons.
  final double iconSpacing;

  /// Width and height of the loading indicator.
  final double loaderSize;

  /// Stroke width of the Material loading indicator.
  final double loaderStrokeWidth;

  /// Opacity of the whole button while disabled or loading.
  final double disabledOpacity;

  /// Extra opacity applied to the label while disabled.
  final double disabledTextOpacity;

  /// Duration of the loading/disabled transitions.
  final Duration animationDuration;

  /// Curve of the loading content switch.
  final Curve animationCurve;

  /// Background of [ButtonVariant.success]. Defaults to the theme's
  /// `tertiary` color.
  final Color? successColor;

  /// Foreground of [ButtonVariant.success]. Defaults to the theme's
  /// `onTertiary` color.
  final Color? onSuccessColor;

  /// Accessibility label. Defaults to [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final useCupertino = context.resolveCupertinoUi(platform);
    final cs = Theme.of(context).colorScheme;
    final isDisabled = onPressed == null || isLoading;

    final double buttonHeight = heightValue ??
        switch (height) {
          ButtonSize.small => 36,
          ButtonSize.medium => 44,
          ButtonSize.large => 56,
        };

    final double? buttonWidth = widthValue ??
        switch (width) {
          ButtonSize.small => 100,
          ButtonSize.medium => 150,
          ButtonSize.large => 200,
          null => null,
        };

    final double hPadding = horizontalPadding ??
        switch (height) {
          ButtonSize.small => 12,
          ButtonSize.medium => 20,
          ButtonSize.large => 28,
        };

    final double resolvedFontSize = fontSize ??
        switch (height) {
          ButtonSize.small => 12,
          ButtonSize.medium => 14,
          ButtonSize.large => 16,
        };

    final (bg, fg, border) = switch (variant) {
      ButtonVariant.primary => (
          color ?? cs.primary,
          textColor ?? cs.onPrimary,
          null,
        ),
      ButtonVariant.secondary => (
          color ?? cs.secondaryContainer,
          textColor ?? cs.onSecondaryContainer,
          null,
        ),
      ButtonVariant.outline => (
          Colors.transparent,
          textColor ?? cs.primary,
          BorderSide(color: cs.outline, width: borderWidth),
        ),
      ButtonVariant.ghost => (
          Colors.transparent,
          textColor ?? cs.primary,
          null,
        ),
      ButtonVariant.danger => (
          color ?? cs.error,
          textColor ?? cs.onError,
          null,
        ),
      ButtonVariant.success => (
          color ?? successColor ?? cs.tertiary,
          textColor ?? onSuccessColor ?? cs.onTertiary,
          null,
        ),
    };

    final resolvedBorder = borderColor != null
        ? BorderSide(color: borderColor!, width: borderWidth)
        : border;

    final child = AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: animationCurve,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loader'),
              width: loaderSize,
              height: loaderSize,
              child: useCupertino
                  ? CupertinoActivityIndicator(color: fg)
                  : CircularProgressIndicator(
                      strokeWidth: loaderStrokeWidth,
                      color: fg,
                    ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: iconSpacing),
                ],
                // Flexible so a long label ellipsizes instead of overflowing
                // the button's fixed height.
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: resolvedFontSize,
                      fontWeight: fontWeight,
                      color: isDisabled
                          ? fg.withValues(alpha: disabledTextOpacity)
                          : fg,
                    ),
                  ),
                ),
                if (suffixIcon != null) ...[
                  SizedBox(width: iconSpacing),
                  suffixIcon!,
                ],
              ],
            ),
    );

    final sized = SizedBox(
      width: isFullWidth ? double.infinity : buttonWidth,
      height: buttonHeight,
      child: useCupertino
          ? CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              color: variant == ButtonVariant.outline ||
                      variant == ButtonVariant.ghost
                  ? null
                  : bg,
              borderRadius: borderRadius,
              onPressed: isDisabled ? null : onPressed,
              child: DefaultTextStyle.merge(
                style: TextStyle(color: fg),
                child: child,
              ),
            )
          : TextButton(
              onPressed: isDisabled ? null : onPressed,
              style: TextButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: fg,
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: resolvedBorder ?? BorderSide.none,
                ),
              ),
              child: child,
            ),
    );

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: animationDuration,
        opacity: isDisabled ? disabledOpacity : 1.0,
        child: sized,
      ),
    );
  }
}
