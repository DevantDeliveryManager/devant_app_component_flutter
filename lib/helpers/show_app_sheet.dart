import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../theme/app_borders.dart';


/// Shows a highly customizable bottom sheet with premium features like backdrop blur.

Future<T?> showAppSheet<T>({
  required Widget child,
  bool hasBlur = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  BuildContext? rootContext,
}) {
  final ctx = rootContext;
  if (ctx == null) return Future.value(null);

  return showModalBottomSheet<T>(
    context: ctx,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    barrierColor: ctx.theme.colorScheme.scrim.withValues(alpha: 0.2),
    elevation: 0,
    useSafeArea: useSafeArea,
    enableDrag: enableDrag,
    shape: const RoundedRectangleBorder(
      borderRadius: AppBorders.bottomSheet,
    ),
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: hasBlur ? 3 : 0,
          sigmaY: hasBlur ? 3 : 0,
        ),
        child: SizedBox(
          child: child,
        ),
      ),
    ),
  );
}
