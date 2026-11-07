import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// The brand's round frosted icon button: an icon on paper, softly lifted,
/// e.g. back, or "Mark all read" in a top bar. With [hasDot], a clay dot
/// marks something new.
class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.hasDot = false,
    this.diameter = size,
  });

  /// The button's width and height, before screen scaling.
  static const double size = 44;

  final IconData icon;

  /// Greyed out and untappable when null.
  final VoidCallback? onPressed;

  /// Shown on long press and read out by screen readers.
  final String? tooltip;

  final bool hasDot;

  /// Smaller for in-card controls, e.g. a month's arrows.
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final ink = AppBrandColors.plum;
    final paper = AppBrandColors.fieldFill;

    Widget button = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ink.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: paper.withValues(alpha: 0.85),
        shape: CircleBorder(
          side: BorderSide(color: ink.withValues(alpha: 0.085)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: diameter.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: (diameter * 0.5).r,
                  color: isEnabled ? ink : ink.withValues(alpha: 0.35),
                ),
                if (hasDot)
                  Positioned(
                    top: 10.r,
                    right: 11.r,
                    child: Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppBrandColors.accent,
                        border: Border.all(color: paper, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    final tooltip = this.tooltip;
    if (tooltip != null) button = Tooltip(message: tooltip, child: button);
    return Semantics(button: true, enabled: isEnabled, child: button);
  }
}
