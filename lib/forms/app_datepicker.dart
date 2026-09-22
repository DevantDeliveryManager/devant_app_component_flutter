import 'package:flutter/material.dart';

import 'app_input_decoration.dart';

/// A read-only field that opens the Material date picker. Plugs into [Form].
///
/// ```dart
/// AppDatePicker(
///   label: 'Date of birth',
///   lastDate: DateTime.now(),
///   onChanged: (d) => setState(() => dob = d),
/// )
/// ```
class AppDatePicker extends FormField<DateTime> {
  AppDatePicker({
    super.key,
    DateTime? value,
    ValueChanged<DateTime?>? onChanged,
    String? label,
    String? hint = 'Select date',
    String? helper,
    String? errorText,
    Widget? prefix = const Icon(Icons.calendar_today_outlined),
    bool clearable = true,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTime date)? dateFormatter,
    DatePickerEntryMode entryMode = DatePickerEntryMode.calendar,
    String? helpText,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    bool filled = true,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double borderRadius = 12,
    EdgeInsetsGeometry? contentPadding,
  }) : super(
         initialValue: value,
         builder: (state) {
           final context = state.context;
           final format = dateFormatter ?? _defaultFormat;
           final date = state.value;

           Future<void> pick() async {
             final now = DateTime.now();
             final first = firstDate ?? DateTime(1900);
             final last = lastDate ?? DateTime(2100);
             var initial = date ?? now;
             if (initial.isBefore(first)) initial = first;
             if (initial.isAfter(last)) initial = last;

             final picked = await showDatePicker(
               context: context,
               initialDate: initial,
               firstDate: first,
               lastDate: last,
               initialEntryMode: entryMode,
               helpText: helpText,
             );
             if (picked != null) {
               state.didChange(picked);
               onChanged?.call(picked);
             }
           }

           void clear() {
             state.didChange(null);
             onChanged?.call(null);
           }

           final decoration = buildAppInputDecoration(
             context,
             label: label,
             hint: hint,
             helper: helper,
             error: state.errorText ?? errorText,
             prefix: prefix,
             suffix: clearable && date != null && state.widget.enabled
                 ? IconButton(
                     tooltip: 'Clear',
                     icon: const Icon(Icons.close),
                     onPressed: clear,
                   )
                 : null,
             filled: filled,
             fillColor: fillColor,
             borderColor: borderColor,
             focusedBorderColor: focusedBorderColor,
             borderRadius: borderRadius,
             contentPadding: contentPadding,
           ).copyWith(
             floatingLabelBehavior:
                 hint != null ? FloatingLabelBehavior.always : null,
             enabled: state.widget.enabled,
           );

           return InkWell(
             borderRadius: BorderRadius.circular(borderRadius),
             onTap: state.widget.enabled ? pick : null,
             child: InputDecorator(
               decoration: decoration,
               isEmpty: date == null,
               child: date == null
                   ? null
                   : Text(format(date), overflow: TextOverflow.ellipsis),
             ),
           );
         },
       );

  static String _defaultFormat(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
