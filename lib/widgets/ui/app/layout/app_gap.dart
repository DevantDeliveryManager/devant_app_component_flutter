import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:devant_components/theme/app_spacing.dart';

/// Named gap sizes mapped to [AppSpacing] tokens.
enum AppGapSize {
  xxs,
  xs,
  xsm,
  sm,
  sml,
  ms,
  msl,
  md,
  mdl,
  ml,
  lg,
  xl,
  xxl,
  xxxl,
}

class AppGap extends StatelessWidget {
  const AppGap(
    double this.value, {
    super.key,
    this.axis = Axis.vertical,
  }) : token = null;

  const AppGap.xxs({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xxs;

  const AppGap.xs({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xs;

  const AppGap.xsm({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xsm;

  const AppGap.sm({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.sm;

  const AppGap.sml({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.sml;

  const AppGap.ms({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.ms;

  const AppGap.msl({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.msl;

  const AppGap.md({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.md;

  const AppGap.mdl({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.mdl;

  const AppGap.ml({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.ml;

  const AppGap.lg({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.lg;

  const AppGap.xl({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xl;

  const AppGap.xxl({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xxl;

  const AppGap.xxxl({super.key, this.axis = Axis.vertical})
      : value = null,
        token = AppGapSize.xxxl;

  final double? value;
  final AppGapSize? token;
  final Axis axis;

  double get _resolved {
    if (value != null) return value!;
    return switch (token!) {
      AppGapSize.xxs => AppSpacing.xxs,
      AppGapSize.xs => AppSpacing.xs,
      AppGapSize.xsm => AppSpacing.xsm,
      AppGapSize.sm => AppSpacing.sm,
      AppGapSize.sml => AppSpacing.sml,
      AppGapSize.ms => AppSpacing.ms,
      AppGapSize.msl => AppSpacing.msl,
      AppGapSize.md => AppSpacing.md,
      AppGapSize.mdl => AppSpacing.mdl,
      AppGapSize.ml => AppSpacing.ml,
      AppGapSize.lg => AppSpacing.lg,
      AppGapSize.xl => AppSpacing.xl,
      AppGapSize.xxl => AppSpacing.xxl,
      AppGapSize.xxxl => AppSpacing.xxxl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = _resolved;
    return axis == Axis.vertical
        ? SizedBox(height: size)
        : SizedBox(width: size);
  }
}
