import 'package:flutter/material.dart';

import 'app_color_scheme.dart';


/// Brand colours of the active colour theme. The theme is chosen in
/// Profile; `App` applies it before building the screens.
abstract final class AppBrandColors {
  AppBrandColors._();

  static AppColorScheme _active = AppColorSchemeId.gangaDawn.scheme;

  /// The active theme.
  static AppColorScheme get scheme => _active;

  /// Called only by `App`, when the theme changes.
  // A method, not a setter: only `App` should change the theme.
  // ignore: use_setters_to_change_properties
  static void apply(AppColorScheme scheme) => _active = scheme;

  // ── Primary brand ─────────────────────────────────────────────

  /// Primary call to action.
  static Color get cta => _active.cta;
  static Color get onCta => _active.onCta;

  /// Lighter CTA, for gradients, highlights and decorative orbs.
  static Color get ctaLight => _active.ctaLight;

  // ── Photographic backgrounds ──────────────────────────────────

  /// Translucent fill for an action over a photo.
  static Color get glassFill => _active.glassFill;
  static const Color glassBorder = Color(0x66FFFFFF);

  /// Text and icons over photographic backgrounds.
  static const Color onImage = Colors.white;
  static const Color onImageMuted = Color(0xE6FFFFFF);

  /// Scrims over images, so copy stays legible.
  static Color get scrimTop => _active.scrimTop;
  static Color get scrimMiddle => _active.scrimMiddle;
  static Color get scrimBottom => _active.scrimBottom;

  /// Fallback gradient while artwork loads.
  static List<Color> get backgroundFallback => _active.backgroundFallback;

  // ── Surfaces & text ───────────────────────────────────────────

  /// Primary headings and text.
  static Color get plum => _active.plum;

  /// Secondary text.
  static Color get plumMuted => _active.plumMuted;

  /// Tertiary text, hints and captions.
  static Color get subtle => _active.subtle;

  /// Inline links.
  static Color get link => _active.link;

  /// Unselected tab background.
  static Color get tabInactiveFill => _active.tabInactiveFill;

  /// Input surfaces.
  static Color get fieldFill => _active.fieldFill;

  /// Field border.
  static Color get fieldBorder => _active.fieldBorder;

  /// Social sign-in surface.
  static Color get socialFill => _active.socialFill;

  /// Tinted callout background.
  static Color get noticeFill => _active.noticeFill;

  /// Screen background.
  static Color get pageBackground => _active.pageBackground;


  static const Color splashBg = Color(0xFF1F3A3E);
  static const Color splashCoral = Color(0xFFD2694B);
  static const Color splashGold = Color(0xFFD4AF5F);
  static const Color splashMuted = Color(0xFFA9B8B5);
}
