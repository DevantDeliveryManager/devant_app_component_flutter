import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/app_borders.dart';
import 'package:devant_components/theme/app_curves.dart';
import 'package:devant_components/theme/app_durations.dart';
import 'package:devant_components/theme/app_fonts.dart';
import 'package:devant_components/theme/app_spacing.dart';
import 'package:devant_components/theme/brand_colors.dart';
import 'package:devant_components/widgets/ui/app/actions/app_segmented_control.dart';

/// The brand's switch between a few views, e.g. "Day | Week | Month" or
/// "Wallet | Payouts | Report": a soft track with the chosen [AppSegment]
/// raised on paper. Every segment takes an equal share of the width.
///
/// Unlike [AppSegmentedControl], it looks the same on every platform.
class AppTabSwitch<T extends Object> extends StatelessWidget {
  const AppTabSwitch({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<AppSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    assert(segments.isNotEmpty, 'AppTabSwitch requires at least one segment');

    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppBrandColors.plum.withValues(alpha: 0.06),
        borderRadius: AppBorders.full,
        border: Border.all(color: AppBrandColors.plum.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _Segment(
                segment: segment,
                isSelected: segment.value == value,
                onTap: () => onChanged(segment.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.isSelected,
    required this.onTap,
  });

  final AppSegment<Object> segment;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppBrandColors.plum : AppBrandColors.subtle;
    final icon = segment.icon;

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: AppDurations.quick,
        curve: AppCurves.standard,
        height: 40.r,
        decoration: BoxDecoration(
          color: isSelected ? AppBrandColors.fieldFill : Colors.transparent,
          borderRadius: AppBorders.full,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppBrandColors.plum.withValues(alpha: 0.06),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                  BoxShadow(
                    color: AppBrandColors.plum.withValues(alpha: 0.4),
                    blurRadius: 14,
                    spreadRadius: -8,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xsm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16.r, color: color),
                    SizedBox(width: AppSpacing.xs),
                  ],
                  Flexible(
                    child: Text(
                      segment.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.inter,
                        fontSize: 13.5.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
