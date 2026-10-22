import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';

import '../button/app_button.dart';
import 'app_filter_section.dart';

/// Opens an [AppFilterSheet] as a modal bottom sheet.
///
/// Completes with the applied values keyed by section id, or null when the
/// sheet is dismissed without applying. Single-select sections give `T?`,
/// multi-select give `List<T>`, sliders give `double`.
///
/// ```dart
/// final result = await showAppFilterSheet(
///   context,
///   title: 'Filters',
///   applyLabel: 'Show results',
///   clearLabel: 'Clear all',
///   sections: [
///     AppFilterOptionsSection<String>(
///       id: 'format',
///       title: 'Format',
///       options: const [
///         AppFilterOption(value: 'online', label: 'Online'),
///         AppFilterOption(value: 'in_person', label: 'In person'),
///       ],
///     ),
///     AppFilterSliderSection(id: 'price', title: 'Max price', min: 0, max: 500),
///   ],
/// );
/// if (result != null) setState(() => filters = result);
/// ```
Future<Map<String, Object?>?> showAppFilterSheet(
  BuildContext context, {
  required List<AppFilterSection> sections,
  String? title,
  String? applyLabel,
  String? clearLabel,
  bool showClear = true,
  Color? backgroundColor,
  double borderRadius = 28,
}) {
  return showModalBottomSheet<Map<String, Object?>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AppFilterSheet(
      sections: sections,
      title: title,
      applyLabel: applyLabel,
      clearLabel: clearLabel,
      showClear: showClear,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
    ),
  );
}

/// A filter sheet built from [AppFilterSection]s. It holds no app state: edits
/// are a draft that is only committed by the apply button, which pops the sheet
/// with the values (see [showAppFilterSheet]) and calls [onApply].
class AppFilterSheet extends StatefulWidget {
  /// Creates a filter sheet.
  const AppFilterSheet({
    super.key,
    required this.sections,
    this.title,
    this.applyLabel,
    this.clearLabel,
    this.showClear = true,
    this.onApply,
    this.backgroundColor,
    this.borderRadius = 28,
  });

  /// Sections shown top to bottom.
  final List<AppFilterSection> sections;

  /// Heading of the sheet. Defaults to the `filter_sheet.title` translation.
  final String? title;

  /// Label of the apply button. Defaults to `filter_sheet.apply`.
  final String? applyLabel;

  /// Label of the reset button. Defaults to `filter_sheet.clear_all`.
  final String? clearLabel;

  /// Whether the reset button is shown.
  final bool showClear;

  /// Called with the draft values when the user applies.
  final ValueChanged<Map<String, Object?>>? onApply;

  /// Sheet background. Defaults to the theme's `surface`.
  final Color? backgroundColor;

  /// Radius of the sheet's top corners.
  final double borderRadius;

  @override
  State<AppFilterSheet> createState() => _AppFilterSheetState();
}

class _AppFilterSheetState extends State<AppFilterSheet> {
  late final Map<String, Object?> _values = {
    for (final s in widget.sections) s.id: s.defaultValue,
  };

  void _clearAll() => setState(() {
    for (final s in widget.sections) {
      _values[s.id] = s.defaultValue;
    }
  });

  void _apply() {
    final result = Map<String, Object?>.of(_values);
    widget.onApply?.call(result);
    Navigator.of(context).maybePop(result);
  }

  void _toggle<T>(AppFilterOptionsSection<T> section, T value) {
    setState(() {
      if (section.multiSelect) {
        final current = List<T>.of(_values[section.id] as List<T>);
        current.contains(value) ? current.remove(value) : current.add(value);
        _values[section.id] = current;
      } else {
        final selected = _values[section.id] == value;
        if (selected && !section.allowDeselect) return;
        _values[section.id] = selected ? null : value;
      }
    });
  }

  bool _isSelected<T>(AppFilterOptionsSection<T> section, T value) {
    final current = _values[section.id];
    return section.multiSelect
        ? (current as List<T>).contains(value)
        : current == value;
  }

  Widget _buildSection(AppFilterSection section) {
    switch (section) {
      case AppFilterOptionsSection():
        return _buildOptions(section);
      case AppFilterSliderSection():
        return _buildSlider(section);
    }
  }

  Widget _buildOptions<T>(AppFilterOptionsSection<T> section) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in section.options)
          _FilterPill(
            label: o.label,
            selected: _isSelected(section, o.value),
            onTap: () => _toggle(section, o.value),
          ),
      ],
    );
  }

  Widget _buildSlider(AppFilterSliderSection section) {
    final value = (_values[section.id] as double).clamp(
      section.min,
      section.max,
    );
    final label = section.valueLabel?.call(value) ?? value.round().toString();
    return Slider(
      min: section.min,
      max: section.max,
      divisions: section.divisions,
      value: value,
      label: label,
      onChanged: (v) => setState(() => _values[section.id] = v),
    );
  }

  String _headingFor(AppFilterSection section) {
    if (section is! AppFilterSliderSection) return section.title;
    final v = _values[section.id] as double;
    final label = section.valueLabel?.call(v) ?? v.round().toString();
    return '${section.title} · $label';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? scheme.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title ?? 'filter_sheet.title'.tr(),
                    style: text.titleLarge,
                  ),
                  if (widget.showClear)
                    TextButton(
                      onPressed: _clearAll,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        widget.clearLabel ?? 'filter_sheet.clear_all'.tr(),
                      ),
                    ),
                ],
              ),
              for (final section in widget.sections) ...[
                const SizedBox(height: 16),
                Text(
                  _headingFor(section).toUpperCase(),
                  style: text.labelMedium?.copyWith(
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSection(section),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: widget.applyLabel ?? 'filter_sheet.apply'.tr(),
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? scheme.primary : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? scheme.primary : scheme.outline),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: selected ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
