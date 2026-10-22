import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/extensions/context_extension.dart';

import '../enums/snack_bar_type.dart';
import '../widgets/toast/toast.dart';
import '../widgets/toast/toast_card.dart';
import '../widgets/ui/app/display/app_icon.dart';

void showToast(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.success,
  dynamic icon,
  Duration? duration,
  bool? autoDismiss,
}) {
  final colorScheme = context.colors;
  final appColors = context.appColors;

  final (backgroundColor, foregroundColor, iconColor) = switch (type) {
    SnackBarType.error => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        colorScheme.error,
      ),
    SnackBarType.success => (
        appColors.successContainer ?? appColors.success,
        appColors.onSuccessContainer ?? appColors.onSuccess,
        appColors.success,
      ),
    SnackBarType.warning => (
        appColors.warningContainer ?? appColors.warning,
        appColors.onWarningContainer ?? appColors.onWarning,
        appColors.warning,
      ),
    SnackBarType.info => (
        appColors.infoContainer ?? appColors.info,
        appColors.onInfoContainer ?? appColors.onInfo,
        appColors.info,
      ),
  };

  return ToastBar(
    position: ToastPosition.bottom,
    autoDismiss: autoDismiss ?? true,
    toastDuration: duration ?? const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 150),
    animationCurve: Curves.easeIn,
    builder: (context) => ToastCard(
      color: backgroundColor,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.05),
      leading: AppIcon(
        icon: icon ??
            switch (type) {
              SnackBarType.success => Icons.check_circle_outline,
              SnackBarType.error => Icons.error_outline,
              SnackBarType.warning || SnackBarType.info => Icons.info_outline,
            },
        color: iconColor,
        size: 22.sp,
      ),
      title: Text(
        message,
        style: context.theme.textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          color: foregroundColor,
        ),
      ),
    ),
  ).show(context);
}

void showGlobalToast({
  required String message,
  SnackBarType type = SnackBarType.success,
  dynamic icon,
  Duration? duration,
  bool? autoDismiss,
  BuildContext? rootContext,
}) {
  final ctx = rootContext;
  if (ctx == null) {
    return;
  }

  showToast(
    ctx,
    message: message,
    type: type,
    icon: icon,
    duration: duration,
    autoDismiss: autoDismiss,
  );
}
