import 'package:flutter/material.dart';

import 'app_input_decoration.dart';

/// A customizable dropdown that plugs into [Form].
///
/// [value] is used as the initial selection; later selections are held by the
/// field itself and reported through [onChanged].
///
/// ```dart
/// AppDropdown<String>(
///   label: 'Country',
///   items: const ['India', 'USA', 'UK'],
///   onChanged: (v) => setState(() => country = v),
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.itemLabel,
    this.itemBuilder,
    this.label,
    this.hint,
    this.helper,
    this.errorText,
    this.prefix,
    this.validator,
    this.autovalidateMode,
    this.enabled = true,
    this.filled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 12,
    this.contentPadding,
    this.dropdownColor,
    this.menuMaxHeight,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;

  /// Text for each item. Defaults to `toString()`.
  final String Function(T item)? itemLabel;

  /// Fully custom item widget. Takes precedence over [itemLabel].
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final String? label;
  final String? hint;
  final String? helper;
  final String? errorText;
  final Widget? prefix;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;
  final bool filled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? dropdownColor;
  final double? menuMaxHeight;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      items: [
        for (final item in items)
          DropdownMenuItem<T>(
            value: item,
            child: itemBuilder != null
                ? itemBuilder!(context, item)
                : Text(
                    itemLabel?.call(item) ?? item.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
      ],
      onChanged: enabled ? (onChanged ?? (_) {}) : null,
      validator: validator,
      autovalidateMode: autovalidateMode,
      borderRadius: BorderRadius.circular(borderRadius),
      dropdownColor: dropdownColor,
      menuMaxHeight: menuMaxHeight,
      decoration: buildAppInputDecoration(
        context,
        label: label,
        hint: hint,
        helper: helper,
        error: errorText,
        prefix: prefix,
        filled: filled,
        fillColor: fillColor,
        borderColor: borderColor,
        focusedBorderColor: focusedBorderColor,
        borderRadius: borderRadius,
        contentPadding: contentPadding,
      ),
    );
  }
}
