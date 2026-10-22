import 'package:flutter/foundation.dart';

/// One selectable option inside an [AppFilterOptionsSection].
@immutable
class AppFilterOption<T> {
  /// Creates an option.
  const AppFilterOption({required this.value, required this.label});

  /// Value reported in the result when this option is selected.
  final T value;

  /// Text shown on the pill.
  final String label;
}

/// A group of filters inside an `AppFilterSheet`.
///
/// Each section has a unique [id] that keys its value in the sheet's result.
@immutable
sealed class AppFilterSection {
  /// Creates a section.
  const AppFilterSection({required this.id, required this.title});

  /// Key of this section's value in the result map.
  final String id;

  /// Heading shown above the section.
  final String title;

  /// Value used before the user touches the section and after "clear all".
  Object? get defaultValue;
}

/// A section of pills. Result value is `T?` when single-select and `List<T>`
/// when [multiSelect].
class AppFilterOptionsSection<T> extends AppFilterSection {
  /// Creates a pill section.
  const AppFilterOptionsSection({
    required super.id,
    required super.title,
    required this.options,
    this.initialValue,
    this.initialValues = const [],
    this.multiSelect = false,
    this.allowDeselect = true,
  });

  /// Pills to show.
  final List<AppFilterOption<T>> options;

  /// Selected value at start when single-select.
  final T? initialValue;

  /// Selected values at start when [multiSelect].
  final List<T> initialValues;

  /// Whether several pills can be selected at once.
  final bool multiSelect;

  /// Whether tapping the selected pill of a single-select section clears it.
  final bool allowDeselect;

  @override
  Object? get defaultValue => multiSelect ? initialValues : initialValue;
}

/// A slider section. Result value is the selected `double`.
class AppFilterSliderSection extends AppFilterSection {
  /// Creates a slider section.
  const AppFilterSliderSection({
    required super.id,
    required super.title,
    required this.min,
    required this.max,
    double? initialValue,
    this.divisions,
    this.valueLabel,
  }) : initialValue = initialValue ?? max;

  /// Lowest selectable value.
  final double min;

  /// Highest selectable value.
  final double max;

  /// Value at start. Defaults to [max].
  final double initialValue;

  /// Number of discrete steps, or null for a continuous slider.
  final int? divisions;

  /// Formats the current value for the heading and the slider bubble
  /// (e.g. `(v) => '\$${v.round()}'`). Defaults to the rounded number.
  final String Function(double value)? valueLabel;

  @override
  Object? get defaultValue => initialValue;
}
