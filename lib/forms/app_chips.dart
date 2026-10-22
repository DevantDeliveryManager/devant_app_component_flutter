import 'package:flutter/material.dart';

/// A group of selectable chips (single or multi select) that plugs into [Form].
///
/// ```dart
/// AppChips<String>(
///   label: 'Interests',
///   items: const ['Music', 'Sports', 'Travel'],
///   multiSelect: true,
///   onChanged: (selected) => setState(() => interests = selected),
/// )
/// ```
class AppChips<T> extends FormField<List<T>> {
  AppChips({
    super.key,
    required List<T> items,
    List<T> value = const [],
    ValueChanged<List<T>>? onChanged,
    String Function(T item)? itemLabel,
    Widget Function(T item)? itemAvatar,
    String? label,
    String? errorText,
    bool multiSelect = false,
    bool allowDeselect = true,
    int? maxSelection,
    double spacing = 8,
    double runSpacing = 8,
    Color? selectedColor,
    Color? backgroundColor,
    Color? selectedLabelColor,
    Color? unselectedLabelColor,
    Color? borderColor,
    double borderRadius = 20,
    bool showCheckmark = true,

    /// Whether the chips are busy. While true they are faded and cannot be
    /// changed.
    bool isLoading = false,
    super.validator,
    super.autovalidateMode,
    super.enabled,
  }) : super(
         initialValue: value,
         builder: (state) {
           final context = state.context;
           final theme = Theme.of(context);
           final scheme = theme.colorScheme;
           final enabled = state.widget.enabled;
           final selected = state.value ?? const [];
           final error = state.errorText ?? errorText;

           void toggle(T item, bool on) {
             List<T> next;
             if (multiSelect) {
               if (on) {
                 if (maxSelection != null && selected.length >= maxSelection) {
                   return;
                 }
                 next = [...selected, item];
               } else {
                 next = selected.where((e) => e != item).toList();
               }
             } else {
               if (!on && !allowDeselect) return;
               next = on ? [item] : <T>[];
             }
             state.didChange(next);
             onChanged?.call(next);
           }

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               if (label != null)
                 Padding(
                   padding: const EdgeInsets.only(bottom: 8),
                   child: Text(label, style: theme.textTheme.titleSmall),
                 ),
               Opacity(
                 opacity: isLoading ? 0.5 : 1,
                 child: Wrap(
                   spacing: spacing,
                   runSpacing: runSpacing,
                   children: [
                     for (final item in items)
                       FilterChip(
                         label: Text(itemLabel?.call(item) ?? item.toString()),
                         avatar: itemAvatar?.call(item),
                         selected: selected.contains(item),
                         showCheckmark: showCheckmark,
                         onSelected: enabled && !isLoading
                             ? (on) => toggle(item, on)
                             : null,
                         selectedColor: selectedColor,
                         backgroundColor: backgroundColor,
                         labelStyle: switch (selected.contains(item)) {
                           true when selectedLabelColor != null => TextStyle(
                             color: selectedLabelColor,
                           ),
                           false when unselectedLabelColor != null => TextStyle(
                             color: unselectedLabelColor,
                           ),
                           _ => null,
                         },
                         side: borderColor != null
                             ? BorderSide(color: borderColor)
                             : null,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(borderRadius),
                         ),
                       ),
                   ],
                 ),
               ),
               if (error != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 6, left: 4),
                   child: Text(
                     error,
                     style: theme.textTheme.bodySmall?.copyWith(
                       color: scheme.error,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}
