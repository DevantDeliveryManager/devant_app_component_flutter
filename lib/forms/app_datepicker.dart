import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../devant_components.dart';
import '../extensions/context_extension.dart';
import '../theme/app_borders.dart';
import '../theme/app_spacing.dart';

/// A date field that opens a Material dialog or Cupertino modal picker.

class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    super.key,
    this.value,
    required this.onChanged,
    this.label,
    this.hint = 'Select date',
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.isLoading = false,
    this.platform,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? label;
  final String hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  /// Whether the field is busy. While true it is faded and the date cannot be
  /// changed.
  final bool isLoading;
  final AppPlatformStyle? platform;

  DateTime get _first => firstDate ?? DateTime(1900);
  DateTime get _last => lastDate ?? DateTime(2100);

  String _format(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  Future<void> _pick(BuildContext context) async {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;
    // Starts on the value or today, kept inside [firstDate, lastDate] so a
    // range that ends before today (e.g. a birth date) still opens.
    final start = value ?? DateTime.now();
    final initial = start.isBefore(_first)
        ? _first
        : start.isAfter(_last)
            ? _last
            : start;

    if (useCupertino) {
      var temp = initial;
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) {
          return Container(
            height: 300.h,
            color: cs.surface,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  color: cs.surfaceContainerHighest,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: cs.onSurfaceVariant),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          onChanged(temp);
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initial,
                    minimumDate: _first,
                    maximumDate: _last,
                    onDateTimeChanged: (d) => temp = d,
                  ),
                ),
              ],
            ),
          );
        },
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _first,
      lastDate: _last,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;
    final tt = context.textTheme;
    final display = value != null ? _format(value!) : hint;

    final interactive = enabled && !isLoading;

    final field = GestureDetector(
      onTap: interactive ? () => _pick(context) : null,
      child: Opacity(
        opacity: interactive ? 1 : 0.5,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.ms,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : cs.surface,
            borderRadius: AppBorders.input,
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null && !useCupertino)
                      Text(
                        label!,
                        style: tt.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    Text(
                      display,
                      style: tt.bodyLarge?.copyWith(
                        color: value == null
                            ? cs.onSurfaceVariant
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                useCupertino
                    ? CupertinoIcons.calendar
                    : Icons.calendar_today_outlined,
                size: 20.sp,
                color: cs.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );

    if (useCupertino && label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              label!,
              style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
          field,
        ],
      );
    }

    return field;
  }
}
