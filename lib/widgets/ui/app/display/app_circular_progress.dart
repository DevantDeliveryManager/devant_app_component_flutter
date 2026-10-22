import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_platform.dart';
import '../../../../extensions/context_extension.dart';

/// Circular progress / activity indicator with adaptive Material / Cupertino UI.

class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 28,
    this.strokeWidth = 3,
    this.color,
    this.platform,
  });

  /// Progress from 0–1, or `null` for indeterminate.
  final double? value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final indicatorColor = color ?? colors.primary;
    final resolvedSize = size.r;

    if (useCupertino) {
      return SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: CupertinoActivityIndicator(
          color: indicatorColor,
          radius: resolvedSize / 2,
        ),
      );
    }

    return SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth,
        color: indicatorColor,
      ),
    );
  }
}
