import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/theme/app_borders.dart';
import 'package:devant_components/theme/app_spacing.dart';

import '../../../../app_platform.dart';

/// A single selectable segment entry for [AppSegmentedControl].
class AppSegment<T> {
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Adaptive segmented control (Material [SegmentedButton] / Cupertino).

class AppSegmentedControl<T extends Object> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.platform,
  });

  final List<AppSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;

    assert(segments.isNotEmpty,
        'AppSegmentedControl requires at least one segment');

    if (useCupertino) {
      final children = <T, Widget>{
        for (final segment in segments)
          segment.value: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (segment.icon != null) ...[
                  Icon(segment.icon, size: 16.sp),
                  SizedBox(width: AppSpacing.xs),
                ],
                Text(segment.label),
              ],
            ),
          ),
      };

      return CupertinoSegmentedControl<T>(
        children: children,
        groupValue: value,
        onValueChanged: onChanged,
        selectedColor: cs.primary,
        unselectedColor: cs.surface,
        borderColor: cs.outline,
        pressedColor: cs.primary.withValues(alpha: 0.2),
      );
    }

    return SegmentedButton<T>(
      segments: [
        for (final segment in segments)
          ButtonSegment<T>(
            value: segment.value,
            label: Text(segment.label),
            icon: segment.icon != null ? Icon(segment.icon) : null,
          ),
      ],
      selected: {value},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) onChanged(selected.first);
      },
      style: const ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppBorders.button),
        ),
      ),
    );
  }
}
