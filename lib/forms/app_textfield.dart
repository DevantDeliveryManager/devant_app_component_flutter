import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_input_decoration.dart';

/// What a field collects. Drives keyboard, formatting and masking so callers
/// never wire those up by hand.
enum AppFieldType { text, email, phone, password, multiline }

/// The single text field for every form: optional label above, themed input
/// below. Plugs into [Form] (validator, autovalidateMode).
///
/// Pick a [type] and the field configures itself:
/// - [AppFieldType.email]     email keyboard
/// - [AppFieldType.phone]     phone keyboard and digits only
/// - [AppFieldType.password]  obscured, with a visibility toggle
/// - [AppFieldType.multiline] several lines
///
/// Every color, size and text style defaults to the ambient [Theme] and can be
/// overridden, so the same widget fits any app's design.
///
/// ```dart
/// AppTextField(
///   type: AppFieldType.email,
///   label: 'Email',
///   hint: 'you@example.com',
///   controller: email,
///   fillColor: brand.fieldFill,
///   borderColor: brand.fieldBorder,
///   labelColor: brand.muted,
///   borderRadius: 10,
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Creates a form field.
  const AppTextField({
    super.key,
    this.type = AppFieldType.text,
    this.label,
    this.labelRow,
    this.hint,
    this.helper,
    this.errorText,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLength,
    this.showCounter = false,
    this.minLines,
    this.maxLines,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.focusedBorderWidth = 2,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.labelColor,
    this.labelFontSize,
    this.labelFontWeight = FontWeight.w600,
    this.labelSpacing = 8,
    this.showPasswordLabel = 'Show password',
    this.hidePasswordLabel = 'Hide password',
    this.passwordIconColor,
  });

  /// What the field collects; sets keyboard, formatters and masking.
  final AppFieldType type;

  /// Plain label above the field. Omit for a bare input.
  final String? label;

  /// Replaces [label] when the row needs more than text.
  final Widget? labelRow;

  /// Placeholder text.
  final String? hint;

  /// Helper text below the field.
  final String? helper;

  /// Externally supplied error. Validator errors take precedence.
  final String? errorText;

  /// Controls the text. When set, [initialValue] is ignored.
  final TextEditingController? controller;

  /// Focus node for the input.
  final FocusNode? focusNode;

  /// Initial text when no [controller] is given.
  final String? initialValue;

  /// Form validator.
  final FormFieldValidator<String>? validator;

  /// When to run [validator].
  final AutovalidateMode? autovalidateMode;

  /// Called on every text change.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits from the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is tapped.
  final VoidCallback? onTap;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Overrides the keyboard implied by [type].
  final TextInputType? keyboardType;

  /// Added to the formatters implied by [type].
  final List<TextInputFormatter>? inputFormatters;

  /// Leading widget inside the input (e.g. an icon or a country-code picker).
  final Widget? prefix;

  /// Trailing widget. Replaced by the visibility toggle for password fields.
  final Widget? suffix;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether the text can be selected but not edited.
  final bool readOnly;

  /// Focuses the field when first built.
  final bool autofocus;

  /// Maximum number of characters.
  final int? maxLength;

  /// Shows the "0/50" counter when [maxLength] is set.
  final bool showCounter;

  /// Minimum visible lines. Defaults to 3 for [AppFieldType.multiline].
  final int? minLines;

  /// Maximum visible lines. Defaults to 6 for multiline, otherwise 1.
  final int? maxLines;

  /// Whether the input has a background fill.
  final bool filled;

  /// Fill color. Defaults to a tint of the theme's surface.
  final Color? fillColor;

  /// Resting border color. Defaults to the theme's `outlineVariant`.
  final Color? borderColor;

  /// Focused border color. Defaults to the theme's `primary`.
  final Color? focusedBorderColor;

  /// Error border color. Defaults to the theme's `error`.
  final Color? errorBorderColor;

  /// Corner radius of the input.
  final double borderRadius;

  /// Resting border thickness.
  final double borderWidth;

  /// Focused / focused-error border thickness.
  final double focusedBorderWidth;

  /// Padding inside the input.
  final EdgeInsetsGeometry? contentPadding;

  /// Style of the entered text.
  final TextStyle? textStyle;

  /// Style of the placeholder.
  final TextStyle? hintStyle;

  /// Full style of the label above the field. Wins over [labelColor],
  /// [labelFontSize] and [labelFontWeight].
  final TextStyle? labelStyle;

  /// Label color. Defaults to the theme's `onSurfaceVariant`.
  final Color? labelColor;

  /// Label font size. Defaults to the theme's `labelLarge` size.
  final double? labelFontSize;

  /// Label font weight.
  final FontWeight labelFontWeight;

  /// Gap between the label and the input.
  final double labelSpacing;

  /// Tooltip of the visibility toggle while the password is hidden.
  final String showPasswordLabel;

  /// Tooltip of the visibility toggle while the password is visible.
  final String hidePasswordLabel;

  /// Color of the visibility toggle icon.
  final Color? passwordIconColor;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.type == AppFieldType.password;

  bool get _isPassword => widget.type == AppFieldType.password;
  bool get _isMultiline => widget.type == AppFieldType.multiline;

  TextInputType? get _keyboard =>
      widget.keyboardType ??
      switch (widget.type) {
        AppFieldType.email => TextInputType.emailAddress,
        AppFieldType.phone => TextInputType.phone,
        AppFieldType.multiline => TextInputType.multiline,
        AppFieldType.text || AppFieldType.password => null,
      };

  List<TextInputFormatter>? get _formatters {
    final implied = [
      if (widget.type == AppFieldType.phone)
        FilteringTextInputFormatter.digitsOnly,
      ...?widget.inputFormatters,
    ];
    return implied.isEmpty ? null : implied;
  }

  Widget? _buildLabel(BuildContext context) {
    if (widget.labelRow != null) return widget.labelRow;
    final text = widget.label;
    if (text == null) return null;

    final base = Theme.of(context).textTheme.labelLarge;
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.labelStyle ??
          base?.copyWith(
            color: widget.labelColor ??
                Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: widget.labelFontSize,
            fontWeight: widget.labelFontWeight,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = _buildLabel(context);

    Widget? suffix = widget.suffix;
    if (_isPassword) {
      suffix = IconButton(
        tooltip: _obscured ? widget.showPasswordLabel : widget.hidePasswordLabel,
        color: widget.passwordIconColor,
        icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    final input = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.controller == null ? widget.initialValue : null,
      obscureText: _obscured,
      keyboardType: _keyboard,
      textInputAction: widget.textInputAction,
      inputFormatters: _formatters,
      minLines: widget.minLines ?? (_isMultiline ? 3 : null),
      maxLines: _isPassword ? 1 : widget.maxLines ?? (_isMultiline ? 6 : 1),
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
        hint: widget.hint,
        helper: widget.helper,
        error: widget.errorText,
        prefix: widget.prefix,
        suffix: suffix,
        filled: widget.filled,
        fillColor: widget.fillColor,
        borderColor: widget.borderColor,
        focusedBorderColor: widget.focusedBorderColor,
        errorBorderColor: widget.errorBorderColor,
        hintStyle: widget.hintStyle,
        borderRadius: widget.borderRadius,
        borderWidth: widget.borderWidth,
        focusedBorderWidth: widget.focusedBorderWidth,
        contentPadding: widget.contentPadding,
        showCounter: widget.showCounter,
      ),
    );

    if (header == null) return input;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header,
        SizedBox(height: widget.labelSpacing),
        input,
      ],
    );
  }
}
