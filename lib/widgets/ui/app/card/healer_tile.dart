import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../button/app_button.dart';
import '../../../../enums/button_varient.dart';
import '../../../../extensions/context_extension.dart';
import '../../../../theme/theme_constants.dart';
import '../display/common_image.dart';

/// Pattern drawn over a [HealerTile]'s header gradient.
enum HeaderPattern { rings, waves, triangles }

/// A profile card: a patterned header with an avatar, a name, a meta line,
/// an optional quote, chips, and a price pinned to the bottom.
///
/// Everything is taken as a parameter; the tile holds no state and does no
/// formatting or localisation of its own.
///
/// ```dart
/// HealerTile(
///   name: 'Asha Rao',
///   meta: 'Yoga & Breathwork · Rishikesh · 12 yrs',
///   quote: 'Breath is the bridge.',
///   address: 'Rishikesh',
///   mode: 'Online · In person',
///   chips: ['Yoga', 'Breathwork'],
///   priceCaption: 'From',
///   price: '₹4,500',
///   onTap: () {},
/// )
/// ```
class HealerTile extends StatelessWidget {
  const HealerTile({
    super.key,
    required this.name,
    required this.price,
    this.initial,
    this.imageUrl,
    this.meta,
    this.quote,
    this.address,
    this.mode,
    this.chips = const [],
    this.priceCaption,
    this.priceColor,
    this.headerColors,
    this.avatarColor,
    this.pattern = HeaderPattern.rings,
    this.onTap,
    this.bookLabel = 'Book',
    this.bookButtonPadding,
    this.bookFontSize = 11,
    this.nameStyle,
    this.metaStyle,
    this.quoteStyle,
    this.addressStyle,
    this.modeStyle,
    this.chipStyle,
    this.initialStyle,
    this.priceCaptionStyle,
    this.priceStyle,
    this.semanticLabel,
  });

  /// Display name, shown under the header.
  final String name;

  /// Price text, shown pinned to the bottom, e.g. `₹4,500` or `Free`.
  final String price;

  /// Letter shown in the avatar without [imageUrl], or while it loads.
  /// Defaults to the first letter of [name].
  final String? initial;

  /// Profile photo URL.
  final String? imageUrl;

  /// Line under the name, e.g. `Yoga · Rishikesh · 12 yrs`.
  final String? meta;

  /// Short italic line, e.g. a headline or testimonial.
  final String? quote;

  /// Location pill on the header.
  final String? address;

  /// Second pill on the header, e.g. `Online · In person`.
  final String? mode;

  /// Verified tags shown as chips.
  final List<String> chips;

  /// Small text above [price], e.g. `From`.
  final String? priceCaption;

  /// Colour of [price]. Defaults to the theme's primary colour.
  final Color? priceColor;

  /// Header gradient, top-left to bottom-right. Defaults to the theme's
  /// primary and tertiary colours.
  final List<Color>? headerColors;

  /// Avatar background. Defaults to the theme's primary colour.
  final Color? avatarColor;

  /// Pattern drawn over the header.
  final HeaderPattern pattern;

  /// Called when the tile or its book button is tapped. The button is only
  /// shown when this is not null.
  final VoidCallback? onTap;

  /// Label of the book button.
  final String bookLabel;

  /// Padding inside the book button. Defaults to the [AppButton] preset;
  /// pass [EdgeInsets.zero] for none.
  final EdgeInsetsGeometry? bookButtonPadding;

  /// Font size of the book button label.
  final double bookFontSize;

  // Each style below is merged over the tile's themed default, so only the
  // properties you set change.

  /// Style of [name].
  final TextStyle? nameStyle;

  /// Style of [meta].
  final TextStyle? metaStyle;

  /// Style of [quote].
  final TextStyle? quoteStyle;

  /// Style of [address].
  final TextStyle? addressStyle;

  /// Style of [mode].
  final TextStyle? modeStyle;

  /// Style of each of [chips].
  final TextStyle? chipStyle;

  /// Style of the avatar letter.
  final TextStyle? initialStyle;

  /// Style of [priceCaption].
  final TextStyle? priceCaptionStyle;

  /// Style of [price].
  final TextStyle? priceStyle;

  /// Accessibility label; defaults to [name].
  final String? semanticLabel;

  /// The coloured banner; the avatar straddles its bottom edge.
  static const double _headerHeight = 69;
  static const double _avatarSize = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.textTheme;
    final accent = priceColor ?? colors.primary;
    final avatar = avatarColor ?? colors.primary;
    final gradient = headerColors ?? [colors.primary, colors.tertiary];
    final meta = this.meta;
    final quote = this.quote;
    final address = this.address;
    final mode = this.mode;

    return Semantics(
      button: onTap != null,
      label: semanticLabel ?? name,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: colors.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: _headerHeight + _avatarSize.r / 2,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: _headerHeight,
                          width: double.infinity,
                          child: _TileHeader(
                            colors: gradient,
                            pattern: pattern,
                          ),
                        ),
                        Positioned(
                          top: AppSpacing.sm,
                          left: AppSpacing.sm,
                          right: AppSpacing.sm,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (address != null)
                                _Pill(
                                  label: address,
                                  icon: Icons.location_on_outlined,
                                  style: addressStyle,
                                ),
                              if (mode != null) ...[
                                if (address != null)
                                  SizedBox(height: AppSpacing.xxs),
                                _Pill(label: mode, style: modeStyle),
                              ],
                            ],
                          ),
                        ),
                        Positioned(
                          left: AppSpacing.md,
                          bottom: 0,
                          child: _Avatar(
                            initial:
                                initial ??
                                (name.isEmpty ? '' : name[0].toUpperCase()),
                            imageUrl: imageUrl,
                            color: avatar,
                            size: _avatarSize.r,
                            style: initialStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.ms),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleLarge
                              ?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w500,
                              )
                              .merge(nameStyle),
                        ),
                        if (meta != null && meta.isNotEmpty)
                          Text(
                            meta,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelMedium
                                ?.copyWith(color: colors.secondary)
                                .merge(metaStyle),
                          ),
                        if (quote != null && quote.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            quote,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                )
                                .merge(quoteStyle),
                          ),
                        ],
                        if (chips.isNotEmpty) ...[
                          SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xxs,
                            runSpacing: AppSpacing.xxs,
                            children: [
                              for (final chip in chips)
                                _Chip(
                                  label: chip,
                                  color: accent,
                                  style: chipStyle,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.ms),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 1, color: colors.outlineVariant),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (priceCaption != null)
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    priceCaption!,
                                    maxLines: 1,
                                    style: text.bodySmall
                                        ?.copyWith(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 9.sp,
                                        )
                                        .merge(priceCaptionStyle),
                                  ),
                                ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  price,
                                  maxLines: 1,
                                  style: text.titleSmall
                                      ?.copyWith(
                                        color: accent,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp,
                                      )
                                      .merge(priceStyle),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (onTap != null) ...[
                          SizedBox(width: AppSpacing.sm),
                          AppButton(
                            label: bookLabel,
                            onPressed: onTap,
                            height: ButtonSize.small,
                            // Grows with the user's text scale so the label
                            // is never clipped.
                            heightValue: MediaQuery.textScalerOf(
                              context,
                            ).scale(28),
                            padding: bookButtonPadding,
                            fontSize: bookFontSize,
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The header gradient with its line pattern.
class _TileHeader extends StatelessWidget {
  const _TileHeader({required this.colors, required this.pattern});

  final List<Color> colors;
  final HeaderPattern pattern;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.length >= 2 ? colors : [colors.first, colors.first],
        ),
      ),
      child: CustomPaint(painter: _HeaderPatternPainter(pattern)),
    );
  }
}

class _HeaderPatternPainter extends CustomPainter {
  const _HeaderPatternPainter(this.pattern);

  final HeaderPattern pattern;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.2);

    switch (pattern) {
      case HeaderPattern.rings:
        final c = Offset(size.width * 0.85, size.height * 0.15);
        for (var r = 30.0; r < size.width; r += 24) {
          canvas.drawCircle(c, r, paint);
        }
      case HeaderPattern.waves:
        for (var row = 0; row < 7; row++) {
          final path = Path();
          final baseY = size.height * (0.1 + row * 0.14);
          for (var x = 0.0; x <= size.width; x += 4) {
            final y = baseY + math.sin(x / size.width * math.pi * 2 + row) * 10;
            x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
          }
          canvas.drawPath(path, paint);
        }
      case HeaderPattern.triangles:
        final apex = Offset(size.width * 0.62, size.height * 0.05);
        for (var i = 0; i < 3; i++) {
          final grow = 1 + i * 0.35;
          final h = size.height * 0.75 * grow;
          final w = h * 0.9;
          final top = apex + Offset(0, i * 14.0);
          canvas.drawPath(
            Path()
              ..moveTo(top.dx, top.dy)
              ..lineTo(top.dx - w / 2, top.dy + h)
              ..lineTo(top.dx + w / 2, top.dy + h)
              ..close(),
            paint,
          );
        }
    }
  }

  @override
  bool shouldRepaint(covariant _HeaderPatternPainter oldDelegate) =>
      oldDelegate.pattern != pattern;
}

/// A dark, translucent pill over the header, e.g. the address.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.icon, this.style});

  final String label;
  final IconData? icon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            SizedBox(width: AppSpacing.xxs),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)
                  .merge(style),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.initial,
    required this.color,
    required this.size,
    this.imageUrl,
    this.style,
  });

  final String initial;
  final Color color;
  final double size;
  final String? imageUrl;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final letter = Center(
      child: Text(
        initial,
        style: context.textTheme.titleLarge
            ?.copyWith(color: Colors.white)
            .merge(style),
      ),
    );
    final url = imageUrl;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: url != null && url.isNotEmpty
            ? CommonImage(
                imageUrl: url,
                width: size - 6,
                height: size - 6,
                fit: BoxFit.cover,
                placeholder: letter,
                errorWidget: letter,
              )
            : letter,
      ),
    );
  }
}

/// A verified tag: tinted background with a tick.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color, this.style});

  final String label;
  final Color color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs + 2, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, size: 12, color: color),
          SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: context.textTheme.labelSmall
                ?.copyWith(color: color, fontWeight: FontWeight.w700)
                .merge(style),
          ),
        ],
      ),
    );
  }
}
