import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// The brand's round frosted back button: a chevron on paper, softly lifted.
///
/// Goes back a screen when tapped, unless [onPressed] says otherwise. Use it
/// on its own over a page, or as [AppTopBar.leading].
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.enabled = true});

  /// The button's width and height, before screen scaling.
  static const double size = 44;

  /// What a tap does; going back a screen when not given.
  final VoidCallback? onPressed;

  /// Off while something is being saved.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppBrandColors.plum.withValues(alpha: 0.35),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppBrandColors.fieldFill.withValues(alpha: 0.85),
        shape: CircleBorder(
          side: BorderSide(color: AppBrandColors.plum.withValues(alpha: 0.085)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: !enabled
              ? null
              : onPressed ?? () => Navigator.of(context).maybePop(),
          child: SizedBox.square(
            dimension: size.r,
            child: Icon(
              Icons.chevron_left_rounded,
              color: AppBrandColors.plum,
              semanticLabel: MaterialLocalizations.of(
                context,
              ).backButtonTooltip,
            ),
          ),
        ),
      ),
    );
  }
}
