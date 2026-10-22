import 'package:devant_components/widgets/ui/app/display/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_platform.dart';
import '../../../../extensions/context_extension.dart';

/// Circular avatar with optional network/asset image or initials fallback.

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.backgroundColor,
    this.foregroundColor,
    this.platform,
  });

  final String? imageUrl;
  final String? initials;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppPlatformStyle? platform;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final bg = backgroundColor ?? colors.primaryContainer;
    final fg = foregroundColor ?? colors.onPrimaryContainer;
    final resolvedRadius = radius.r;
    final size = resolvedRadius * 2;

    final Widget content;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = CommonImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(resolvedRadius),
      );
    } else {
      final label = (initials ?? '?').trim();
      content = ColoredBox(
        color: bg,
        child: Center(
          child: Text(
            label.isEmpty
                ? '?'
                : label.substring(0, label.length.clamp(0, 2)).toUpperCase(),
            style: context.textTheme.titleMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              fontSize: resolvedRadius * 0.75,
            ),
          ),
        ),
      );
    }

    if (useCupertino) {
      return ClipOval(
        child: SizedBox(width: size, height: size, child: content),
      );
    }

    return CircleAvatar(
      radius: resolvedRadius,
      backgroundColor: bg,
      foregroundColor: fg,
      child: ClipOval(
        child: SizedBox(width: size, height: size, child: content),
      ),
    );
  }
}
