import 'package:flutter/material.dart';

import '../../../../app_platform.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../theme/theme_constants.dart';

/// Themed tooltip wrapping [message] around [child].

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration,
    this.triggerMode,
    this.showDuration,
    this.platform,
  });

  final String message;
  final Widget child;
  final Duration? waitDuration;

  /// How it opens; long press by default on touch screens. Use
  /// [TooltipTriggerMode.tap] for an info button.
  final TooltipTriggerMode? triggerMode;

  /// How long it stays after a touch opened it.
  final Duration? showDuration;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;

    return Tooltip(
      message: message,
      waitDuration: waitDuration ?? AppDurations.normal,
      triggerMode: triggerMode,
      showDuration: showDuration,
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: useCupertino ? AppBorders.md : AppBorders.sm,
        boxShadow: AppShadows.elevated,
      ),
      textStyle: context.textTheme.bodySmall?.copyWith(
        color: colors.onInverseSurface,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: child,
    );
  }
}
