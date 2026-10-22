import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// The selectable colour themes, as in the 2Verse brand guidelines. The
/// first is the default.
enum AppColorSchemeId {
  gangaDawn,
  saffronSanctum,
  tapovanForest,
  lotusPearl,
  roseQuartz,
  ivoryGold,
  himalayanNight,
  amethystAura,
  moonlitGanga,
  auroraChakra;

  AppColorScheme get scheme => AppColorSchemes.of(this);

  /// The saved value, or the default when unknown.
  static AppColorSchemeId fromName(String? name) => values.firstWhere(
        (id) => id.name == name,
        orElse: () => gangaDawn,
      );
}

/// A healer card header gradient, top to bottom, with the avatar colour
/// that goes with it.
typedef HealerCardTheme = ({List<Color> header, Color avatar});

/// One colour theme. Every theme fills the same tokens; screens read them
/// through `AppBrandColors` and `GuestPalette`.
class AppColorScheme extends Equatable {
  const AppColorScheme({
    required this.id,
    required this.brightness,
    required this.cta,
    required this.onCta,
    required this.ctaLight,
    required this.glassFill,
    required this.scrimTop,
    required this.scrimMiddle,
    required this.scrimBottom,
    required this.backgroundFallback,
    required this.plum,
    required this.plumMuted,
    required this.subtle,
    required this.link,
    required this.tabInactiveFill,
    required this.fieldFill,
    required this.fieldBorder,
    required this.socialFill,
    required this.noticeFill,
    required this.pageBackground,
    required this.gold,
    required this.accent,
    required this.verifiedChip,
    required this.modePill,
    required this.bookShadow,
    required this.danger,
    required this.cardThemes,
  });

  /// Builds every token from the theme's brand palette.
  factory AppColorScheme.fromPalette({
    required AppColorSchemeId id,
    required Brightness brightness,
    required Color bg,
    required Color bgAlt,
    required Color surface,
    required Color ink,
    required Color ink2,
    required Color muted,
    required Color line,
    required Color primary,
    required Color primaryDeep,
    required Color onPrimary,
    required Color accent,
    required Color accentStrong,
    required Color accentDeep,
    required Color gold,
    required Color softSage,
    required Color softGold,
    required Color deep,
    required Color danger,
    required List<Color> hills,
    required Color sky,
    required List<Color> river,
  }) {
    return AppColorScheme(
      id: id,
      brightness: brightness,
      cta: primary,
      onCta: onPrimary,
      ctaLight: Color.lerp(primary, surface, 0.35)!,
      glassFill: primary.withValues(alpha: 0.2),
      scrimTop: deep.withValues(alpha: 0.8),
      scrimMiddle: primary.withValues(alpha: 0.1),
      scrimBottom: deep.withValues(alpha: 0.7),
      backgroundFallback: [deep, primaryDeep, bgAlt],
      plum: ink,
      plumMuted: ink2,
      subtle: muted,
      link: accentStrong,
      tabInactiveFill: bgAlt,
      fieldFill: surface,
      fieldBorder: Color.alphaBlend(line, surface),
      socialFill: surface,
      noticeFill: softGold,
      pageBackground: bg,
      gold: gold,
      accent: accent,
      verifiedChip: softSage,
      modePill: deep.withValues(alpha: 0.55),
      bookShadow: primary.withValues(alpha: 0.25),
      danger: danger,
      cardThemes: [
        (header: hills, avatar: hills[1]),
        (header: [sky, accent, accentDeep], avatar: accentDeep),
        (header: [...river, primaryDeep], avatar: river.last),
      ],
    );
  }

  final AppColorSchemeId id;

  /// Light or dark theme.
  final Brightness brightness;

  /// Primary call to action.
  final Color cta;
  final Color onCta;

  /// Lighter CTA, for gradients and highlights.
  final Color ctaLight;

  /// Translucent fill for an action over a photo.
  final Color glassFill;

  /// Scrims over photographic backgrounds.
  final Color scrimTop;
  final Color scrimMiddle;
  final Color scrimBottom;

  /// Shown while artwork loads.
  final List<Color> backgroundFallback;

  /// Primary text.
  final Color plum;

  /// Secondary text.
  final Color plumMuted;

  /// Hints and captions.
  final Color subtle;

  /// Inline links and accents on text.
  final Color link;

  /// Unselected tab, inset tiles.
  final Color tabInactiveFill;

  /// Inputs and raised cards.
  final Color fieldFill;
  final Color fieldBorder;

  /// Social sign-in rows.
  final Color socialFill;

  /// Tinted callouts.
  final Color noticeFill;

  /// Screen background.
  final Color pageBackground;
  final Color gold;

  /// Decorative accent (the brand's second colour).
  final Color accent;

  /// The verified-practice chip on a healer card.
  final Color verifiedChip;

  /// The mode pill over a healer card's header.
  final Color modePill;

  /// The shadow under a healer card's Book button.
  final Color bookShadow;
  final Color danger;

  /// Healer card headers, taken in turn down a list.
  final List<HealerCardTheme> cardThemes;

  bool get isDark => brightness == Brightness.dark;

  @override
  List<Object?> get props => [id];
}

/// The theme definitions, from the brand guidelines.
abstract final class AppColorSchemes {
  static AppColorScheme of(AppColorSchemeId id) => _all[id]!;

  static final Map<AppColorSchemeId, AppColorScheme> _all = {
    AppColorSchemeId.gangaDawn: AppColorScheme.fromPalette(
      id: AppColorSchemeId.gangaDawn,
      brightness: Brightness.light,
      bg: const Color(0xFFF6F0E6),
      bgAlt: const Color(0xFFEDE3D3),
      surface: const Color(0xFFFFFDF9),
      ink: const Color(0xFF1D2A2C),
      ink2: const Color(0xFF4A5657),
      muted: const Color(0xFF66615A),
      line: const Color(0x242F5358),
      primary: const Color(0xFF2F5358),
      primaryDeep: const Color(0xFF1E3A3E),
      onPrimary: const Color(0xFFFFFDF9),
      accent: const Color(0xFFC0704F),
      accentStrong: const Color(0xFF98512F),
      accentDeep: const Color(0xFFA55A3B),
      gold: const Color(0xFFC9A45C),
      softSage: const Color(0xFFE8EEE5),
      softGold: const Color(0xFFF4EAD6),
      deep: const Color(0xFF1E3A3E),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFF8FA68E), Color(0xFF5E7F6F), Color(0xFF2F5358)],
      sky: const Color(0xFFE7B48C),
      river: const [Color(0xFFA9C6D3), Color(0xFF5E8A93)],
    ),
    AppColorSchemeId.saffronSanctum: AppColorScheme.fromPalette(
      id: AppColorSchemeId.saffronSanctum,
      brightness: Brightness.light,
      bg: const Color(0xFFFBF3E7),
      bgAlt: const Color(0xFFF4E3CB),
      surface: const Color(0xFFFFFAF2),
      ink: const Color(0xFF2B140F),
      ink2: const Color(0xFF5E4238),
      muted: const Color(0xFF7E675C),
      line: const Color(0x1F7A1F1F),
      primary: const Color(0xFF7A1F1F),
      primaryDeep: const Color(0xFF5A1414),
      onPrimary: const Color(0xFFFFF7EA),
      accent: const Color(0xFFE0892E),
      accentStrong: const Color(0xFF8F581D),
      accentDeep: const Color(0xFFC06F18),
      gold: const Color(0xFFC99A3B),
      softSage: const Color(0xFFF7E6CF),
      softGold: const Color(0xFFF6E7C2),
      deep: const Color(0xFF3A0F10),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFFC9875A), Color(0xFF9A4E36), Color(0xFF6E2320)],
      sky: const Color(0xFFE48E55),
      river: const [Color(0xFFE9B98A), Color(0xFFB8704A)],
    ),
    AppColorSchemeId.tapovanForest: AppColorScheme.fromPalette(
      id: AppColorSchemeId.tapovanForest,
      brightness: Brightness.light,
      bg: const Color(0xFFEEF0E8),
      bgAlt: const Color(0xFFE1E6D8),
      surface: const Color(0xFFFAFBF6),
      ink: const Color(0xFF16231B),
      ink2: const Color(0xFF43524A),
      muted: const Color(0xFF636C65),
      line: const Color(0x1F1F3D2B),
      primary: const Color(0xFF1F3D2B),
      primaryDeep: const Color(0xFF142A1D),
      onPrimary: const Color(0xFFF6F7F0),
      accent: const Color(0xFFB5733C),
      accentStrong: const Color(0xFF86552C),
      accentDeep: const Color(0xFF985B29),
      gold: const Color(0xFFB89A5A),
      softSage: const Color(0xFFDDE6D3),
      softGold: const Color(0xFFEDE4CC),
      deep: const Color(0xFF122419),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFF87A781), Color(0xFF4F7552), Color(0xFF1F3D2B)],
      sky: const Color(0xFFB6C9A9),
      river: const [Color(0xFFA9C2B8), Color(0xFF5F857A)],
    ),
    AppColorSchemeId.lotusPearl: AppColorScheme.fromPalette(
      id: AppColorSchemeId.lotusPearl,
      brightness: Brightness.light,
      bg: const Color(0xFFF8F5F7),
      bgAlt: const Color(0xFFEFE8EE),
      surface: const Color(0xFFFFFFFF),
      ink: const Color(0xFF231B2B),
      ink2: const Color(0xFF5A4E63),
      muted: const Color(0xFF736C7A),
      line: const Color(0x1A4A3563),
      primary: const Color(0xFF4A3563),
      primaryDeep: const Color(0xFF35244A),
      onPrimary: const Color(0xFFFFFFFF),
      accent: const Color(0xFFD9899B),
      accentStrong: const Color(0xFF8B5863),
      accentDeep: const Color(0xFFC06C80),
      gold: const Color(0xFFC7A26A),
      softSage: const Color(0xFFEDE6F3),
      softGold: const Color(0xFFF3EBDD),
      deep: const Color(0xFF241A33),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFFBBA7CE), Color(0xFF8C75A8), Color(0xFF4A3563)],
      sky: const Color(0xFFD7C5E4),
      river: const [Color(0xFFD7E0EE), Color(0xFF9AA9C9)],
    ),
    AppColorSchemeId.roseQuartz: AppColorScheme.fromPalette(
      id: AppColorSchemeId.roseQuartz,
      brightness: Brightness.light,
      bg: const Color(0xFFFBF4F1),
      bgAlt: const Color(0xFFF4E6E0),
      surface: const Color(0xFFFFFCFA),
      ink: const Color(0xFF2E1C1C),
      ink2: const Color(0xFF6A4E4B),
      muted: const Color(0xFF7D6A67),
      line: const Color(0x1C783C3C),
      primary: const Color(0xFF8C4A4A),
      primaryDeep: const Color(0xFF6E3434),
      onPrimary: const Color(0xFFFFF9F6),
      accent: const Color(0xFFD98E73),
      accentStrong: const Color(0xFF8B5B4A),
      accentDeep: const Color(0xFFC0735A),
      gold: const Color(0xFFC9A27A),
      softSage: const Color(0xFFF6E3DC),
      softGold: const Color(0xFFF5E9DA),
      deep: const Color(0xFF3A1F22),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFFD9A3A0), Color(0xFFB06F6D), Color(0xFF7A3E3F)],
      sky: const Color(0xFFE9A99A),
      river: const [Color(0xFFEBC8C4), Color(0xFFC08F8C)],
    ),
    AppColorSchemeId.ivoryGold: AppColorScheme.fromPalette(
      id: AppColorSchemeId.ivoryGold,
      brightness: Brightness.light,
      bg: const Color(0xFFF7F4EE),
      bgAlt: const Color(0xFFEEE9DF),
      surface: const Color(0xFFFFFFFF),
      ink: const Color(0xFF141414),
      ink2: const Color(0xFF4B4945),
      muted: const Color(0xFF706C66),
      line: const Color(0x1A141414),
      primary: const Color(0xFF141414),
      primaryDeep: const Color(0xFF000000),
      onPrimary: const Color(0xFFF7F4EE),
      accent: const Color(0xFFB08D57),
      accentStrong: const Color(0xFF7F663F),
      accentDeep: const Color(0xFF947444),
      gold: const Color(0xFFB08D57),
      softSage: const Color(0xFFEFEBE3),
      softGold: const Color(0xFFF1E9D8),
      deep: const Color(0xFF141414),
      danger: const Color(0xFFB3261E),
      hills: const [Color(0xFFBDB3A2), Color(0xFF8A8173), Color(0xFF3A3631)],
      sky: const Color(0xFFD6C8AE),
      river: const [Color(0xFFD8D2C6), Color(0xFF9E978B)],
    ),
    AppColorSchemeId.himalayanNight: AppColorScheme.fromPalette(
      id: AppColorSchemeId.himalayanNight,
      brightness: Brightness.dark,
      bg: const Color(0xFF0A0F1E),
      bgAlt: const Color(0xFF18213D),
      surface: const Color(0xFF121A31),
      ink: const Color(0xFFF3EEE4),
      ink2: const Color(0xFFB8BCCB),
      muted: const Color(0xFF8A90A6),
      line: const Color(0x1AFFFFFF),
      primary: const Color(0xFFE0BC76),
      primaryDeep: const Color(0xFFC79E55),
      onPrimary: const Color(0xFF0A0F1E),
      accent: const Color(0xFF9AA6FF),
      accentStrong: const Color(0xFF9AA6FF),
      accentDeep: const Color(0xFF7C89F0),
      gold: const Color(0xFFE6C27A),
      softSage: const Color(0xFF1A2442),
      softGold: const Color(0xFF262236),
      deep: const Color(0xFF060A15),
      danger: const Color(0xFFFF8A80),
      hills: const [Color(0xFF2F3A6C), Color(0xFF1E2750), Color(0xFF111833)],
      sky: const Color(0xFF4A3A70),
      river: const [Color(0xFF34427A), Color(0xFF1A2348)],
    ),
    AppColorSchemeId.amethystAura: AppColorScheme.fromPalette(
      id: AppColorSchemeId.amethystAura,
      brightness: Brightness.dark,
      bg: const Color(0xFF120B1F),
      bgAlt: const Color(0xFF251A3D),
      surface: const Color(0xFF1D1330),
      ink: const Color(0xFFF5EEF7),
      ink2: const Color(0xFFC7B9D2),
      muted: const Color(0xFF9284A4),
      line: const Color(0x14FFFFFF),
      primary: const Color(0xFFEDBBA5),
      primaryDeep: const Color(0xFFD9A088),
      onPrimary: const Color(0xFF120B1F),
      accent: const Color(0xFFB98CFF),
      accentStrong: const Color(0xFFB98CFF),
      accentDeep: const Color(0xFF9E6BF0),
      gold: const Color(0xFFE8C08E),
      softSage: const Color(0xFF2A1D45),
      softGold: const Color(0xFF2E2336),
      deep: const Color(0xFF0B0614),
      danger: const Color(0xFFFF8A80),
      hills: const [Color(0xFF4A2E78), Color(0xFF301D55), Color(0xFF1A0F33)],
      sky: const Color(0xFF7A3C73),
      river: const [Color(0xFF5A3E8A), Color(0xFF2A1A4D)],
    ),
    AppColorSchemeId.moonlitGanga: AppColorScheme.fromPalette(
      id: AppColorSchemeId.moonlitGanga,
      brightness: Brightness.dark,
      bg: const Color(0xFF07161A),
      bgAlt: const Color(0xFF143038),
      surface: const Color(0xFF0F262C),
      ink: const Color(0xFFEAF4F2),
      ink2: const Color(0xFFA9C2C0),
      muted: const Color(0xFF809A98),
      line: const Color(0x14FFFFFF),
      primary: const Color(0xFF9FE3D6),
      primaryDeep: const Color(0xFF7FCABC),
      onPrimary: const Color(0xFF07161A),
      accent: const Color(0xFFF0A868),
      accentStrong: const Color(0xFFF0A868),
      accentDeep: const Color(0xFFDB8F4E),
      gold: const Color(0xFFE3CB92),
      softSage: const Color(0xFF12323A),
      softGold: const Color(0xFF223029),
      deep: const Color(0xFF040E11),
      danger: const Color(0xFFFF8A80),
      hills: const [Color(0xFF1B4A52), Color(0xFF113540), Color(0xFF0A2229)],
      sky: const Color(0xFF1F4F57),
      river: const [Color(0xFF1F5E66), Color(0xFF0D3038)],
    ),
    AppColorSchemeId.auroraChakra: AppColorScheme.fromPalette(
      id: AppColorSchemeId.auroraChakra,
      brightness: Brightness.dark,
      bg: const Color(0xFF06110F),
      bgAlt: const Color(0xFF132924),
      surface: const Color(0xFF0E1F1B),
      ink: const Color(0xFFECF5F0),
      ink2: const Color(0xFFA8C2B8),
      muted: const Color(0xFF7A938A),
      line: const Color(0x14FFFFFF),
      primary: const Color(0xFF7CF0C2),
      primaryDeep: const Color(0xFF5FD8A9),
      onPrimary: const Color(0xFF06110F),
      accent: const Color(0xFFC59BFF),
      accentStrong: const Color(0xFFC59BFF),
      accentDeep: const Color(0xFFA97CF2),
      gold: const Color(0xFFE4D08A),
      softSage: const Color(0xFF12302A),
      softGold: const Color(0xFF262B22),
      deep: const Color(0xFF030A08),
      danger: const Color(0xFFFF8A80),
      hills: const [Color(0xFF1E4A48), Color(0xFF123433), Color(0xFF081E1D)],
      sky: const Color(0xFF2A2F58),
      river: const [Color(0xFF1C4F55), Color(0xFF0B2A2E)],
    ),
  };
}
