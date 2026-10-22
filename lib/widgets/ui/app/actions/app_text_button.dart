import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_platform.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../theme/theme_constants.dart';


/// A compact text-only button with Material and Cupertino variants.

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.platform,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;
    final fg = color ?? cs.primary;
    final resolvedSize = fontSize ?? 14.sp;

    final text = Text(
      label,
      style: TextStyle(
        fontSize: resolvedSize,
        fontWeight: fontWeight,
        color: onPressed == null ? fg.withValues(alpha: 0.5) : fg,
      ),
    );

    if (useCupertino) {
      return CupertinoButton(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        onPressed: onPressed,
        minimumSize: Size.zero,
        child: text,
      );
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: fg,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: text,
    );
  }
}
