import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Skeleton / shimmer wrapper around placeholder content.

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    required this.child,
    this.enabled = true,
    this.ignorePointers = true,
  });

  final Widget child;
  final bool enabled;
  final bool ignorePointers;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Skeletonizer(
      enabled: enabled,
      ignorePointers: ignorePointers,
      child: child,
    );
  }
}
