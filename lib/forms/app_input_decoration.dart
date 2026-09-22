import 'package:flutter/material.dart';

/// Internal helper shared by the form widgets so they all look consistent.
/// Not exported from the package.
InputDecoration buildAppInputDecoration(
  BuildContext context, {
  String? label,
  String? hint,
  String? helper,
  String? error,
  Widget? prefix,
  Widget? suffix,
  bool filled = true,
  Color? fillColor,
  Color? borderColor,
  Color? focusedBorderColor,
  double borderRadius = 12,
  EdgeInsetsGeometry? contentPadding,
  int? maxLength,
  bool showCounter = false,
}) {
  final scheme = Theme.of(context).colorScheme;

  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width),
      );

  final base = borderColor ?? scheme.outlineVariant;
  final focused = focusedBorderColor ?? scheme.primary;

  return InputDecoration(
    labelText: label,
    hintText: hint,
    helperText: helper,
    errorText: error,
    prefixIcon: prefix,
    suffixIcon: suffix,
    filled: filled,
    fillColor: fillColor ?? scheme.surfaceContainerHighest.withValues(alpha: 0.3),
    contentPadding: contentPadding ??
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    counterText: showCounter ? null : '',
    enabledBorder: border(base),
    border: border(base),
    focusedBorder: border(focused, 2),
    errorBorder: border(scheme.error),
    focusedErrorBorder: border(scheme.error, 2),
    disabledBorder: border(base.withValues(alpha: 0.4)),
  );
}
