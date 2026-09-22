import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_input_decoration.dart';

/// A customizable text field that plugs into [Form] (validator, autovalidate).
///
/// Supports label, hint, helper, prefix/suffix, a built-in password
/// visibility toggle, character counter and multi-line input.
///
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   prefix: const Icon(Icons.email_outlined),
///   keyboardType: TextInputType.emailAddress,
///   validator: (v) => (v ?? '').contains('@') ? null : 'Invalid email',
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefix,
    this.suffix,
    this.isPassword = false,
    this.showPasswordToggle = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 12,
    this.contentPadding,
    this.textStyle,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? helper;

  /// Externally supplied error. Validator errors take precedence.
  final String? errorText;
  final Widget? prefix;

  /// Trailing widget. Replaced by the visibility toggle for password fields.
  final Widget? suffix;

  /// Obscures the text and shows a visibility toggle.
  final bool isPassword;
  final bool showPasswordToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  /// Show the "0/50" counter when [maxLength] is set.
  final bool showCounter;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    Widget? suffix = widget.suffix;
    if (widget.isPassword && widget.showPasswordToggle) {
      suffix = IconButton(
        tooltip: _obscured ? 'Show password' : 'Hide password',
        icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.controller == null ? widget.initialValue : null,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      style: widget.textStyle,
      decoration: buildAppInputDecoration(
        context,
        label: widget.label,
        hint: widget.hint,
        helper: widget.helper,
        error: widget.errorText,
        prefix: widget.prefix,
        suffix: suffix,
        filled: widget.filled,
        fillColor: widget.fillColor,
        borderColor: widget.borderColor,
        focusedBorderColor: widget.focusedBorderColor,
        borderRadius: widget.borderRadius,
        contentPadding: widget.contentPadding,
        showCounter: widget.showCounter,
      ),
    );
  }
}
