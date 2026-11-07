import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/app_borders.dart';
import 'package:devant_components/theme/app_curves.dart';
import 'package:devant_components/theme/app_durations.dart';
import 'package:devant_components/theme/app_fonts.dart';
import 'package:devant_components/theme/app_shadows.dart';
import 'package:devant_components/theme/app_spacing.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// The brand's small filter chip: paper with a faint ring, or teal once
/// [isSelected]. As wide as its label, with an optional [count] small and
/// faded beside it. Use a row of them to filter a list.
class AppPillChip extends StatelessWidget {
  const AppPillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count = 0,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Shown beside the label when above 0.
  final int count;

  @override
  Widget build(BuildContext context) {
    final foreground =
        isSelected ? AppBrandColors.onCta : AppBrandColors.plumMuted;
    TextStyle style(double size, FontWeight weight, Color color) => TextStyle(
          fontFamily: AppFonts.roboto,
          fontSize: size.sp,
          fontWeight: weight,
          color: color,
        );

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: AppDurations.quick,
        curve: AppCurves.standard,
        decoration: BoxDecoration(
          borderRadius: AppBorders.full,
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppBrandColors.cta, AppBrandColors.ctaDeep],
                )
              : null,
          color: isSelected
              ? null
              : AppBrandColors.fieldFill.withValues(alpha: 0.9),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppBrandColors.plum.withValues(alpha: 0.12),
          ),
          // The same lift as the search bar beside it.
          boxShadow: isSelected ? AppShadows.fieldChosen : AppShadows.field,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            // As wide as its label: no alignment here, which would stretch
            // it across the row.
            child: Container(
              height: 32.r,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sml),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: style(12.5, FontWeight.w500, foreground)),
                  if (count > 0) ...[
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '$count',
                      style: style(
                        11,
                        FontWeight.w600,
                        foreground.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
