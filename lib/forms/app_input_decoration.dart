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
  Color? errorBorderColor,
  TextStyle? hintStyle,
  TextStyle? labelStyle,
  double borderWidth = 1,
  double focusedBorderWidth = 2,
  double borderRadius = 12,
  EdgeInsetsGeometry? contentPadding,
  int? maxLength,
  bool showCounter = false,
}) {
  final scheme = Theme.of(context).colorScheme;

  OutlineInputBorder border(Color color, [double? width]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width ?? borderWidth),
      );

  final base = borderColor ?? scheme.outlineVariant;
  final errorColor = errorBorderColor ?? scheme.error;
  final focused = focusedBorderColor ?? scheme.primary;

  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle,
    labelStyle: labelStyle,
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
    focusedBorder: border(focused, focusedBorderWidth),
    errorBorder: border(errorColor),
    focusedErrorBorder: border(errorColor, focusedBorderWidth),
    disabledBorder: border(base.withValues(alpha: 0.4)),
  );
}
