import 'package:flutter/material.dart';

/// Visual style of a [AppButton].
enum AppButtonVariant { filled, outlined, text }

/// A fully customizable button with optional [subtitle], [leading],
/// [trailing] widgets and a [isLoading] state.
///
/// Colors and text styles default to the ambient [Theme].
///
/// ```dart
/// AppButton(
///   label: 'Pay now',
///   subtitle: 'Total \$25.00',
///   leading: const Icon(Icons.lock),
///   trailing: const Icon(Icons.arrow_forward),
///   isLoading: submitting,
///   onPressed: submit,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.child,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.loadingWidget,
    this.loadingLabel,
    this.variant = AppButtonVariant.filled,
    this.isExpanded = true,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius = 12,
    this.elevation,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.minHeight = 48,
    this.width,
    this.height,
    this.labelStyle,
    this.subtitleStyle,
    this.gap = 10,
    this.loaderSize = 20,
    this.loaderStrokeWidth = 2.5,
    this.alignment = MainAxisAlignment.center,
    this.textAlign = TextAlign.start,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
         label != null || child != null,
         'Provide either a label or a child.',
       );

  /// Main text. Ignored when [child] is provided.
  final String? label;

  /// Custom content replacing [label] and [subtitle].
  final Widget? child;

  /// Smaller text shown under [label].
  final String? subtitle;

  /// Widget shown before the text (e.g. an icon).
  final Widget? leading;

  /// Widget shown after the text (e.g. an arrow).
  final Widget? trailing;

  /// Called on tap. The button is disabled when null or while [isLoading].
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  /// Shows a progress indicator and blocks taps.
  final bool isLoading;

  /// Replaces the default [CircularProgressIndicator].
  final Widget? loadingWidget;

  /// Optional text shown next to the loader instead of the normal content.
  final String? loadingLabel;

  final AppButtonVariant variant;

  /// Fill the available width (true) or wrap content (false).
  final bool isExpanded;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry padding;
  final double minHeight;

  /// Fixed size overrides. Take precedence over [isExpanded] / [minHeight].
  final double? width;
  final double? height;

  final TextStyle? labelStyle;
  final TextStyle? subtitleStyle;

  /// Space between leading/text/trailing.
  final double gap;
  final double loaderSize;
  final double loaderStrokeWidth;
  final MainAxisAlignment alignment;
  final TextAlign textAlign;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isFilled = variant == AppButtonVariant.filled;

    final fg = foregroundColor ??
        (isFilled ? scheme.onPrimary : scheme.primary);
    final bg = backgroundColor ?? (isFilled ? scheme.primary : null);
    final disabledFg =
        disabledForegroundColor ?? scheme.onSurface.withValues(alpha: 0.38);
    final disabledBg = disabledBackgroundColor ??
        (isFilled ? scheme.onSurface.withValues(alpha: 0.12) : null);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: variant == AppButtonVariant.outlined
          ? BorderSide(
              color: _enabled || isLoading
                  ? (borderColor ?? fg)
                  : disabledFg.withValues(alpha: 0.3),
              width: borderWidth,
            )
          : BorderSide.none,
    );

    // While loading keep the enabled look instead of flashing disabled colors.
    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) && !isLoading) {
          return disabledBg;
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled) && !isLoading) {
          return disabledFg;
        }
        return fg;
      }),
      elevation: WidgetStatePropertyAll(isFilled ? (elevation ?? 0) : 0),
      shape: WidgetStatePropertyAll(shape),
      padding: WidgetStatePropertyAll(padding),
      minimumSize: WidgetStatePropertyAll(Size(0, minHeight)),
      tapTargetSize: MaterialTapTargetSize.padded,
    );

    // Passing null callbacks disables the Material button; loading must
    // block taps but keep the enabled appearance, so use no-op handlers.
    final VoidCallback? tap =
        isLoading ? () {} : (_enabled ? onPressed : null);
    final VoidCallback? longPress =
        isLoading ? null : (_enabled ? onLongPress : null);

    final content = _buildContent(context, theme);

    Widget button = switch (variant) {
      AppButtonVariant.filled => ElevatedButton(
          onPressed: tap,
          onLongPress: longPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          child: content,
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: tap,
          onLongPress: longPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: tap,
          onLongPress: longPress,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          child: content,
        ),
    };

    if (tooltip != null) button = Tooltip(message: tooltip!, child: button);

    button = Semantics(
      button: true,
      enabled: _enabled,
      label: isLoading ? (loadingLabel ?? label) : null,
      child: button,
    );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }
    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    final textColor = DefaultTextStyle.of(context).style.color;

    if (isLoading) {
      final loader = loadingWidget ??
          SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: loaderStrokeWidth,
              color: foregroundColor ??
                  (variant == AppButtonVariant.filled
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary),
            ),
          );
      return Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: [
          loader,
          if (loadingLabel != null) ...[
            SizedBox(width: gap),
            Flexible(
              child: Text(
                loadingLabel!,
                style: labelStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      );
    }

    final textBlock = child ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: switch (textAlign) {
            TextAlign.center => CrossAxisAlignment.center,
            TextAlign.end || TextAlign.right => CrossAxisAlignment.end,
            _ => CrossAxisAlignment.start,
          },
          children: [
            Text(
              label!,
              textAlign: textAlign,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w600)
                  .merge(labelStyle),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                textAlign: textAlign,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: textColor?.withValues(alpha: 0.8))
                    .merge(subtitleStyle),
              ),
          ],
        );

    return Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        if (leading != null) ...[leading!, SizedBox(width: gap)],
        Flexible(child: textBlock),
        if (trailing != null) ...[SizedBox(width: gap), trailing!],
      ],
    );
  }
}
