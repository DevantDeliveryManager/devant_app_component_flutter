import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/app_platform.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    hide ScaleEffect, SlideEffect, SwapEffect;

/// Page dots powered by `smooth_page_indicator`.

class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.dotSize = 8,
    this.spacing = 8,
    this.activeColor,
    this.inactiveColor,
    this.platform,
  });

  final PageController controller;
  final int count;
  final double dotSize;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final active = activeColor ?? colors.primary;
    final inactive = inactiveColor ?? colors.outlineVariant;
    final size = dotSize.r;
    final gap = spacing.r;

    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: useCupertino
          ? WormEffect(
              dotHeight: size,
              dotWidth: size,
              spacing: gap,
              activeDotColor: active,
              dotColor: inactive,
            )
          : ExpandingDotsEffect(
              dotHeight: size,
              dotWidth: size,
              spacing: gap,
              expansionFactor: 3,
              activeDotColor: active,
              dotColor: inactive,
            ),
    );
  }
}
