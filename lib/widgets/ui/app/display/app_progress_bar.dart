import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_platform.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../theme/theme_constants.dart';

/// Linear progress bar. Pass `null` [value] for an indeterminate indicator.

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    this.value,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.platform,
  });

  /// Progress from 0–1, or `null` for indeterminate.
  final double? value;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final height = minHeight ?? 4.h;
    final track = backgroundColor ?? colors.surfaceContainerHighest;
    final fill = color ?? colors.primary;

    if (useCupertino && value == null) {
      return SizedBox(
        height: 20.h,
        child: Center(
          child: CupertinoActivityIndicator(color: fill),
        ),
      );
    }

    if (useCupertino && value != null) {
      return ClipRRect(
        borderRadius: AppBorders.full,
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: track),
              FractionallySizedBox(
                widthFactor: value!.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: ColoredBox(color: fill),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: AppBorders.full,
      child: LinearProgressIndicator(
        value: value,
        minHeight: height,
        color: fill,
        backgroundColor: track,
      ),
    );
  }
}
