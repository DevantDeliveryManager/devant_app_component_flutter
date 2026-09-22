import 'package:flutter/material.dart';

/// One option of an [AppRadio] group.
class AppRadioOption<T> {
  const AppRadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final bool enabled;
}

/// A radio button group that plugs into [Form].
///
/// ```dart
/// AppRadio<String>(
///   label: 'Gender',
///   options: const [
///     AppRadioOption(value: 'm', label: 'Male'),
///     AppRadioOption(value: 'f', label: 'Female'),
///   ],
///   onChanged: (v) => setState(() => gender = v),
/// )
/// ```
class AppRadio<T> extends FormField<T> {
  AppRadio({
    super.key,
    required List<AppRadioOption<T>> options,
    T? value,
    ValueChanged<T?>? onChanged,
    String? label,
    String? errorText,
    Axis direction = Axis.vertical,
    Color? activeColor,
    bool dense = false,
    EdgeInsetsGeometry contentPadding = EdgeInsets.zero,
    super.validator,
    super.autovalidateMode,
    super.enabled,
  }) : super(
         initialValue: value,
         builder: (state) {
           final context = state.context;
           final theme = Theme.of(context);
           final enabled = state.widget.enabled;
           final error = state.errorText ?? errorText;

           void change(T? v) {
             state.didChange(v);
             onChanged?.call(v);
           }

           Widget tile(AppRadioOption<T> o) {
             final tile = RadioListTile<T>(
               value: o.value,
               title: Text(o.label),
               subtitle: o.subtitle != null ? Text(o.subtitle!) : null,
               activeColor: activeColor,
               dense: dense,
               contentPadding: contentPadding,
             );
             final active = enabled && o.enabled;
             final wrapped = IgnorePointer(
               ignoring: !active,
               child: Opacity(opacity: active ? 1 : 0.5, child: tile),
             );
             // Horizontal groups need bounded width for each tile.
             return direction == Axis.horizontal
                 ? Flexible(child: wrapped)
                 : wrapped;
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               if (label != null)
                 Padding(
                   padding: const EdgeInsets.only(bottom: 4),
                   child: Text(label, style: theme.textTheme.titleSmall),
                 ),
               RadioGroup<T>(
                 groupValue: state.value,
                 onChanged: change,
                 child: direction == Axis.vertical
                     ? Column(children: [for (final o in options) tile(o)])
                     : Row(children: [for (final o in options) tile(o)]),
               ),
               if (error != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 4, left: 4),
                   child: Text(
                     error,
                     style: theme.textTheme.bodySmall
                         ?.copyWith(color: theme.colorScheme.error),
                   ),
                 ),
             ],
           );
         },
       );
}
