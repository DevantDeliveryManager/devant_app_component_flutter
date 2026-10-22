import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extension.dart';
import '../theme/theme_constants.dart';
import 'ui/app/layout/app_gap.dart';

/// A wrapping group of chips where any number can be chosen; bound to
/// [selected], which holds the keys of [options] that are on. In the brand
/// colours, unlike the Material-themed `AppChip`.
class AppMultiChipSelect extends StatelessWidget {
  const AppMultiChipSelect({
    super.key,
    required this.selected,
    required this.options,
  });

  final ValueNotifier<Set<String>> selected;

  /// Key to the label shown for it, in display order.
  final Map<String, String> options;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: selected,
      builder: (context, chosen, _) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final MapEntry(key: key, value: label) in options.entries)
            _Chip(
              label: label,
              isOn: chosen.contains(key),
              onTap: () => selected.value = chosen.contains(key)
                  ? ({...chosen}..remove(key))
                  : {...chosen, key},
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.isOn, required this.onTap});

  final String label;
  final bool isOn;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = isOn ? AppBrandColors.onCta : AppBrandColors.plum;

    return Semantics(
      button: true,
      selected: isOn,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isOn ? AppBrandColors.plum : AppBrandColors.fieldFill,
            borderRadius: AppBorders.full,
            border: Border.all(
              color: isOn ? AppBrandColors.plum : AppBrandColors.fieldBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isOn) ...[
                Icon(Icons.check_rounded, size: 16, color: foreground),
                const AppGap.xs(axis: Axis.horizontal),
              ],
              Text(
                label,
                style: context.textTheme.labelLarge?.copyWith(
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
