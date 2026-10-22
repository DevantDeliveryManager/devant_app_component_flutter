// // lib/src/shared/widgets/healer_card.dart
// import 'dart:math' as math;

// import 'package:flutter/material.dart';

// import '../../../../utils/healer_model.dart';


// enum HeaderPattern { rings, waves, triangles }

// class HealerCard extends StatelessWidget {
//   const HealerCard({
//     super.key,
//     required this.healer,
//     required this.index,
//     this.isFavourite = false,
//     this.onFavouriteTap,
//     this.onBook,
//     this.onTap,
//   });

//   final HealerModel healer;

//   /// Its place in the list/carousel; picks the colour theme and pattern.
//   final int index;
//   final bool isFavourite;
//   final VoidCallback? onFavouriteTap;
//   final VoidCallback? onBook;
//   final VoidCallback? onTap;

//   static const double _headerHeight = 96;
//   static const double _avatarSize = 56;

//   /// "Yoga & Breathwork · 12 yrs"; parts it lacks are left out.
//   String get _meta => [
//         if (healer.practices.isNotEmpty)
//           healer.practices.map((p) => p.name).whereType<String>().join(' & '),
//         if (healer.yearsOfPractice case final years? when years > 0)
//           LocaleKeys.healer_card_years.tr(args: ['$years']),
//       ].where((s) => s.isNotEmpty).join(' · ');

//   /// The cheapest option costs nothing.
//   bool get _isFree => healer.fromPrice == 0;

//   /// One formatter per currency, shared by every card: building a
//   /// [NumberFormat] is costly, and cards are built on every scroll.
//   static final Map<String, NumberFormat> _priceFormats = {};

//   static NumberFormat _priceFormat(String code) =>
//       _priceFormats[code] ??= NumberFormat.currency(
//         locale: code == 'INR' ? 'en_IN' : 'en_US',
//         name: code,
//         symbol: switch (code) {
//           'INR' => '₹ ',
//           'USD' => r'$ ',
//           _ => '$code ',
//         },
//         decimalDigits: 0,
//       );

//   String? _price() {
//     final amount = healer.fromPrice;
//     if (amount == null) return null;
//     if (amount == 0) return LocaleKeys.healer_profile_free.tr();

//     final code = (healer.currency ?? 'INR').toUpperCase();
//     return _priceFormat(code).format(amount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final text = context.textTheme;
//     final theme = GuestPalette
//         .healerCardThemes[index % GuestPalette.healerCardThemes.length];
//     final pattern = HeaderPattern.values[index % HeaderPattern.values.length];
//     final name = healer.displayName ?? '';
//     final meta = _meta;
//     final headline = healer.headline;
//     final next = healer.nextSessionAt;
//     final price = _price();

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: GuestPalette.surface,
//           borderRadius: BorderRadius.circular(12.r),
//           border: Border.all(color: GuestPalette.border),
//           boxShadow: GuestPalette.cardShadow,
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // ─────────────────────────────────────────
//             // TOP SECTION - HEADER + HEALER DETAILS
//             // ─────────────────────────────────────────
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // HEADER + AVATAR
//                 SizedBox(
//                   height: _headerHeight + _avatarSize / 2,
//                   child: Stack(
//                     children: [
//                       SizedBox(
//                         height: _headerHeight,
//                         width: double.infinity,
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: theme.header,
//                             ),
//                           ),
//                           // Static artwork: lets the engine cache it as a
//                           // picture instead of redrawing paths while
//                           // scrolling.
//                           child: CustomPaint(
//                             painter: _HeaderPatternPainter(pattern),
//                             isComplex: true,
//                           ),
//                         ),
//                       ),

//                       // NEXT AVAILABLE SESSION
//                       if (next != null)
//                         Positioned(
//                           top: AppSpacing.sm,
//                           left: AppSpacing.sm,
//                           right: AppSpacing.sm,
//                           child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: _NextSessionPill(
//                               date: next.toLocal(),
//                             ),
//                           ),
//                         ),

//                       // FAVOURITE BUTTON
//                       Positioned(
//                         bottom: AppSpacing.ms,
//                         right: AppSpacing.sm,
//                         child: Material(
//                           color: AppBrandColors.onCta.withValues(alpha: 0.92),
//                           shape: const CircleBorder(),
//                           child: InkWell(
//                             customBorder: const CircleBorder(),
//                             onTap: onFavouriteTap,
//                             child: Tooltip(
//                               message: isFavourite
//                                   ? LocaleKeys.healer_card_favourite_remove.tr()
//                                   : LocaleKeys.healer_card_favourite_add.tr(),
//                               child: Padding(
//                                 padding: EdgeInsets.all(AppSpacing.sm),
//                                 child: Icon(
//                                   isFavourite
//                                       ? Icons.favorite_rounded
//                                       : Icons.favorite_border_rounded,
//                                   size: 18.r,
//                                   color: isFavourite
//                                       ? GuestPalette.accent
//                                       : GuestPalette.ink,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // AVATAR
//                       Positioned(
//                         left: AppSpacing.md,
//                         bottom: 0,
//                         child: _Avatar(
//                           initial: name.isEmpty ? '?' : name[0].toUpperCase(),
//                           imageUrl: healer.profileImage,
//                           color: theme.avatar,
//                           size: _avatarSize.r,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // HEALER INFORMATION
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(
//                     AppSpacing.ms,
//                     AppSpacing.sm,
//                     AppSpacing.ms,
//                     0,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // NAME
//                       AppText.ellipsis(
//                         name,
//                         style: text.titleMedium?.copyWith(
//                           color: GuestPalette.ink,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),

//                       // META
//                       if (meta.isNotEmpty)
//                         AppText.ellipsis(
//                           meta,
//                           style: text.labelMedium?.inter.copyWith(
//                             color: GuestPalette.inkSubtle,
//                           ),
//                         ),

//                       // HEADLINE
//                       if (headline != null && headline.isNotEmpty) ...[
//                         const AppGap.sm(),
//                         AppText(
//                           headline,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: text.bodySmall?.copyWith(
//                             color: GuestPalette.inkMuted,
//                             fontStyle: FontStyle.italic,
//                             height: 1.4,
//                             // fontSize:  9.sp,
//                           ),
//                         ),
//                       ],

//                       const AppGap.sm(),

//                       // PRACTICE CHIPS
//                       Wrap(
//                         spacing: AppSpacing.xxs,
//                         runSpacing: AppSpacing.xxs,
//                         children: [
//                           for (final p in healer.practices)
//                             if (p.name != null) _Chip(label: p.name!),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             // ─────────────────────────────────────────
//             // BOTTOM SECTION - PRICE
//             // ─────────────────────────────────────────
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                 AppSpacing.ms,
//                 AppSpacing.ms,
//                 AppSpacing.ms,
//                 AppSpacing.ms,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Divider(
//                     height: 1,
//                     color: GuestPalette.border,
//                   ),
//                   const AppGap.sm(),
//                   if (price != null)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // "From" only makes sense in front of an amount.
//                         if (!_isFree)
//                           AppText.ellipsis(
//                             LocaleKeys.healer_card_price_from.tr(),
//                             style: text.bodySmall?.inter.copyWith(
//                               color: GuestPalette.inkSubtle,
//                               fontSize: 9.sp,
//                             ),
//                           ),
//                         AppText.ellipsis(
//                           price,
//                           style: text.titleMedium?.inter.copyWith(
//                             color: _isFree
//                                 ? GuestPalette.accent
//                                 : GuestPalette.teal,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _NextSessionPill extends StatelessWidget {
//   const _NextSessionPill({required this.date});

//   final DateTime date;

//   /// One formatter per locale, shared by every card.
//   static final Map<String, DateFormat> _formats = {};

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.locale.toString();
//     final when =
//         (_formats[locale] ??= DateFormat.MMMd(locale).add_jm()).format(date);

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppSpacing.sm,
//         vertical: AppSpacing.xs,
//       ),
//       decoration: BoxDecoration(
//         color: GuestPalette.modePill,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.schedule_rounded, size: 12.r, color: AppBrandColors.onCta),
//           const AppGap.xxs(axis: Axis.horizontal),
//           Flexible(
//             child: AppText.ellipsis(
//               LocaleKeys.healer_card_next_session.tr(args: [when]),
//               style: context.textTheme.labelSmall?.inter.copyWith(
//                 color: AppBrandColors.onCta,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 9.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Avatar extends StatelessWidget {
//   const _Avatar({
//     required this.initial,
//     required this.color,
//     required this.size,
//     this.imageUrl,
//   });

//   final String initial;
//   final Color color;
//   final double size;
//   final String? imageUrl;

//   @override
//   Widget build(BuildContext context) {
//     final letter = Center(
//       child: Text(
//         initial,
//         style:
//             context.textTheme.titleLarge?.copyWith(color: AppBrandColors.onCta),
//       ),
//     );

//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: color,
//         shape: BoxShape.circle,
//         border: Border.all(color: AppBrandColors.onCta, width: 3),
//         boxShadow: GuestPalette.cardShadow,
//       ),
//       child: ClipOval(
//         child: switch (imageUrl) {
//           // Sized, so the photo is decoded at avatar size rather than full
//           // resolution as cards scroll in.
//           final url? when url.isNotEmpty => CommonImage(
//               imageUrl: url,
//               width: HealerCard._avatarSize,
//               height: HealerCard._avatarSize,
//               fit: BoxFit.cover,
//               placeholder: letter,
//               errorWidget: letter,
//             ),
//           _ => letter,
//         },
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   const _Chip({required this.label});

//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppSpacing.sm,
//         vertical: AppSpacing.xs,
//       ),
//       decoration: BoxDecoration(
//         color: GuestPalette.verifiedChip,
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.check_rounded, size: 12.r, color: GuestPalette.teal),
//           const AppGap.xxs(axis: Axis.horizontal),
//           AppText(
//             label,
//             style: context.textTheme.bodySmall?.inter.copyWith(
//               color: GuestPalette.teal,
//               fontWeight: FontWeight.w700,
//               fontSize: 8.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HeaderPatternPainter extends CustomPainter {
//   const _HeaderPatternPainter(this.pattern);

//   final HeaderPattern pattern;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1
//       ..color = AppBrandColors.onCta.withValues(alpha: 0.2);

//     switch (pattern) {
//       case HeaderPattern.rings:
//         final c = Offset(size.width * 0.85, size.height * 0.15);
//         for (var r = 30.0; r < size.width; r += 24) {
//           canvas.drawCircle(c, r, paint);
//         }
//       case HeaderPattern.waves:
//         for (var row = 0; row < 7; row++) {
//           final path = Path();
//           final baseY = size.height * (0.1 + row * 0.14);
//           for (var x = 0.0; x <= size.width; x += 4) {
//             final y = baseY + math.sin(x / size.width * math.pi * 2 + row) * 10;
//             x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
//           }
//           canvas.drawPath(path, paint);
//         }
//       case HeaderPattern.triangles:
//         final apex = Offset(size.width * 0.62, size.height * 0.05);
//         for (var i = 0; i < 3; i++) {
//           final h = size.height * 0.75 * (1 + i * 0.35);
//           final w = h * 0.9;
//           final top = apex + Offset(0, i * 14.0);
//           canvas.drawPath(
//             Path()
//               ..moveTo(top.dx, top.dy)
//               ..lineTo(top.dx - w / 2, top.dy + h)
//               ..lineTo(top.dx + w / 2, top.dy + h)
//               ..close(),
//             paint,
//           );
//         }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _HeaderPatternPainter old) =>
//       old.pattern != pattern;
// }
