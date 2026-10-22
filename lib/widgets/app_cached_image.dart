import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A premium, highly customizable wrapper around [CachedNetworkImage].

class AppCachedImage extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// Optional width for the image.
  final double? width;

  /// Optional height for the image.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Optional placeholder displayed while the image is loading.
  /// If null, a shimmer or loading indicator is shown.
  final Widget? placeholder;

  /// Optional widget displayed if the image fails to load.
  final Widget? errorWidget;

  /// [Optional] color to be combined with the image.
  final Color? color;

  /// [Optional] blend mode for the [color].
  final BlendMode? colorBlendMode;

  /// The borderRadius of the image.
  final BorderRadius? borderRadius;

  /// The duration of the fade-in animation.
  final Duration? fadeInDuration;

  /// How to align the image within its bounds.
  final Alignment alignment;

  /// If true, the image will be wrapped in a [Skeletonizer] during loading.
  final bool useSkeleton;

  /// Optional key to use for caching.
  final String? cacheKey;

  /// Decodes the image at this many pixels wide (or high) instead of its
  /// full size: set for small thumbnails in lists, so scrolling doesn't
  /// decode large photos.
  final int? memCacheWidth;
  final int? memCacheHeight;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.borderRadius,
    this.fadeInDuration,
    this.alignment = Alignment.center,
    this.useSkeleton = true,
    this.cacheKey,
    this.memCacheWidth,
    this.memCacheHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Adjust sizing for screenutil if enabled
    final double? adjustedWidth = width?.w;
    final double? adjustedHeight = height?.h;

    Widget imageContent = CachedNetworkImage(
      imageUrl: imageUrl,
      cacheKey: cacheKey,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      width: adjustedWidth,
      height: adjustedHeight,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      fadeInDuration: fadeInDuration ?? const Duration(milliseconds: 500),
      placeholder: (context, url) =>
          placeholder ?? _buildDefaultPlaceholder(context),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildDefaultErrorWidget(context),
    );

    if (borderRadius != null) {
      imageContent = ClipRRect(
        borderRadius: borderRadius!,
        child: imageContent,
      );
    }

    return imageContent;
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    if (useSkeleton) {
      return Skeletonizer(
        enabled: true,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surfaceContainerHighest,
            borderRadius: borderRadius,
          ),
        ),
      );
    }
    return _buildLoadingIndicator(context);
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.theme.colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.9),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.theme.colorScheme.errorContainer.withValues(alpha: 0.9),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: context.theme.colorScheme.error,
        ),
      ),
    );
  }
}
