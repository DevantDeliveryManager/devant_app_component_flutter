import 'package:flutter/material.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// Predefined box shadows aligned with Material 3 elevation tiers.

abstract final class AppShadows {
  AppShadows._();

  /// No shadow — flat, tonal surface (elevation 0).
  static const List<BoxShadow> none = [];

  /// Minimal shadow — barely lifted surfaces (elevation 1).
  /// Use for: toggle surfaces, filled cards on white background.
  static const List<BoxShadow> subtle = [
    BoxShadow(
      color: Color(0x0D000000), // 5% black
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Card shadow — clearly elevated content (elevation 2–3).
  /// Use for: cards, list items that are tappable, floating elements.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% black
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Elevated shadow — significantly raised surface (elevation 6–8).
  /// Use for: FABs, dropdown menus, tooltips.
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x0F000000), // 6% black
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Modal shadow — overlay surfaces, dialogs, bottom sheets (elevation 12+).
  /// Use for: dialogs, modals, side sheets.
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x29000000), // 16% black
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% black
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // ── Brand fields ──────────────────────────────────────────────────────────

  /// The soft lift under a paper field or chip, e.g. a search bar and the
  /// filter chips beside it, so they read as one row of controls.
  static List<BoxShadow> get field => [
        BoxShadow(
          color: AppBrandColors.plum.withValues(alpha: 0.35),
          blurRadius: 14,
          spreadRadius: -12,
          offset: const Offset(0, 6),
        ),
      ];

  /// A field while typing in it: a soft gold halo.
  static List<BoxShadow> get fieldFocus => [
        BoxShadow(
          color: AppBrandColors.gold.withValues(alpha: 0.14),
          spreadRadius: 5,
        ),
      ];

  /// A chosen teal chip or tile: the field's lift, deeper.
  static List<BoxShadow> get fieldChosen => [
        BoxShadow(
          color: AppBrandColors.deep.withValues(alpha: 0.55),
          blurRadius: 14,
          spreadRadius: -10,
          offset: const Offset(0, 6),
        ),
      ];
}
