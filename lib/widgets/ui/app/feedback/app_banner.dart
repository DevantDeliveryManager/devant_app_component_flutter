import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/theme/theme_constants.dart';

import '../../../../devant_components.dart';

/// Material-style banner for persistent in-page messages.

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.message,
    this.leading,
    this.actions = const [],
    this.backgroundColor,
    this.onDismiss,
    this.platform,
  });

  final String message;
  final Widget? leading;
  final List<Widget> actions;
  final Color? backgroundColor;
  final VoidCallback? onDismiss;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final appColors = context.appColors;
    final bg =
        backgroundColor ?? appColors.infoContainer ?? colors.secondaryContainer;
    final fg = backgroundColor != null
        ? colors.onSecondaryContainer
        : (appColors.onInfoContainer ?? colors.onSecondaryContainer);

    return MaterialBanner(
      backgroundColor: bg,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      leading: leading ??
          Icon(
            useCupertino ? CupertinoIcons.info_circle_fill : Icons.info_outline,
            color: fg,
            size: 22.sp,
          ),
      content: Text(
        message,
        style: context.textTheme.bodyMedium?.copyWith(color: fg),
      ),
      actions: [
        ...actions,
        if (onDismiss != null)
          TextButton(
            onPressed: onDismiss,
            child: Text(
              'Dismiss',
              style: TextStyle(color: fg),
            ),
          ),
      ],
    );
  }
}
