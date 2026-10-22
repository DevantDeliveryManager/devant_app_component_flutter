import 'package:devant_components/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_platform.dart';
import '../extensions/context_extension.dart';


/// A single dropdown menu item for [AppDropdown].
class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Adaptive dropdown / picker for selecting a single value.

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.enabled = true,
    this.platform,
  });

  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final String? hint;
  final bool enabled;
  final AppPlatformStyle? platform;

  String _labelFor(T? v) {
    if (v == null) return hint ?? 'Select';
    return items
        .firstWhere(
          (i) => i.value == v,
          orElse: () => AppDropdownItem(value: v, label: hint ?? 'Select'),
        )
        .label;
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    final cs = context.colors;
    final initialIndex = items.indexWhere((i) => i.value == value);
    var selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 280.h,
          color: cs.surface,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  border: Border(bottom: BorderSide(color: cs.outlineVariant)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel',
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        onChanged(items[selectedIndex].value);
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
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 36.h,
                  onSelectedItemChanged: (i) => selectedIndex = i,
                  children: [
                    for (final item in items)
                      Center(
                        child: Text(
                          item.label,
                          style: TextStyle(color: cs.onSurface),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;
    final tt = context.textTheme;

    if (useCupertino) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                label!,
                style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          GestureDetector(
            onTap: enabled ? () => _showCupertinoPicker(context) : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.ms,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: AppBorders.input,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _labelFor(value),
                      style: tt.bodyLarge?.copyWith(
                        color:
                            value == null ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_down,
                    size: 16.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return DropdownButtonFormField<T>(
      initialValue: value,
      // Fill the available width rather than demanding the widest item's
      // intrinsic width, which overflows inside a narrow parent.
      isExpanded: true,
      items: [
        for (final item in items)
          DropdownMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            child: Text(item.label),
          ),
      ],
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        hintText: hint,
      ),
    );
  }
}
