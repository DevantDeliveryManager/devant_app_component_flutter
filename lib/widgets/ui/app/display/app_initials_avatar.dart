import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/app_fonts.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// Someone's initials in a lit circle, standing in for their photo: "JR"
/// for "Jaya Roy". With [hasRing], set in a paper ring edged in gold and
/// softly lifted.
///
/// Without a [color], the person gets one of the brand's four avatar
/// colours, always the same one for the same name: see [colorFor].
class AppInitialsAvatar extends StatelessWidget {
  const AppInitialsAvatar({
    super.key,
    required this.name,
    this.color,
    this.size = 40,
    this.hasRing = false,
  });

  final String name;

  /// [colorFor] the name when not given.
  final Color? color;

  /// The circle's width and height, before screen scaling; the ring adds
  /// to it.
  final double size;
  final bool hasRing;

  /// The paper ring's width, inside the gold one.
  static const double _ringGap = 2.5;

  /// The fourth avatar colour, a dusk lavender; the theme has no tone of
  /// its own for it.
  static const Color lavender = Color(0xFF7A7FAE);

  /// The brand's avatar colours: teal, clay, gold and lavender.
  static List<Color> get colors => [
    AppBrandColors.cta,
    AppBrandColors.accent,
    AppBrandColors.gold,
    lavender,
  ];

  /// The same person always gets the same colour: picked by the sum of
  /// [key]'s character codes, as on the website.
  static Color colorFor(String key) {
    final palette = colors;
    return palette[key.codeUnits.fold<int>(0, (sum, code) => sum + code) %
        palette.length];
  }

  /// "JR" for "Jaya Roy": the first letters of the first two words.
  static String initialsOf(String name) => name
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part.characters.first.toUpperCase())
      .join();

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? colorFor(name);
    final fontSize = size * 0.37;
    final avatar = Container(
      width: size.r,
      height: size.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Lit from the top left: pale, the colour, then its shade.
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.5),
          radius: 0.9,
          colors: [
            Color.lerp(color, Colors.white, 0.65)!,
            color,
            Color.lerp(color, Colors.black, 0.38)!,
          ],
          stops: const [0, 0.6, 1],
        ),
      ),
      child: Text(
        initialsOf(name),
        style: TextStyle(
          fontFamily: AppFonts.roboto,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: fontSize * 0.02,
          color: AppBrandColors.onImage,
        ),
      ),
    );
    if (!hasRing) return avatar;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppBrandColors.gold.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: AppBrandColors.deep.withValues(alpha: 0.6),
            blurRadius: 18,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(_ringGap),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppBrandColors.fieldFill,
        ),
        child: avatar,
      ),
    );
  }
}
