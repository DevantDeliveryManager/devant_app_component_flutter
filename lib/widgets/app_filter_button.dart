import 'package:devant_components/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import '../theme/theme_constants.dart';

/// Opens a screen's filters; sits inside [AppSearchBar]. A badge counts the
/// filters chosen, when there are any.
class AppFilterButton extends StatelessWidget {
  const AppFilterButton({
    super.key,
    this.onTap,
    this.activeCount = 0,
    this.semanticLabel,
  });

  final VoidCallback? onTap;

  /// Filters currently applied; `0` hides the badge.
  final int activeCount;

  /// Read by screen readers, e.g. "Filters".
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      value: activeCount > 0 ? '$activeCount' : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: AppBrandColors.cta,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: SizedBox.square(
                dimension: 40,
                child: Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: AppBrandColors.onCta,
                ),
              ),
            ),
          ),
          if (activeCount > 0)
            Positioned(
              top: -AppSpacing.xs,
              right: -AppSpacing.xs,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: AppSpacing.ml,
                  minHeight: AppSpacing.ml,
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                decoration: BoxDecoration(
                  color: AppBrandColors.link,
                  borderRadius: AppBorders.full,
                  border: Border.all(color: AppBrandColors.fieldFill),
                ),
                child: Text(
                  '$activeCount',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppBrandColors.onCta,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
