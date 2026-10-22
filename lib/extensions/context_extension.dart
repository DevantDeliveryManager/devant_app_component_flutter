import 'package:devant_components/enums/app_ui_enums.dart';
import 'package:flutter/material.dart';

import '../enums/snack_bar_type.dart';
import '../theme/color_schemes.dart';
import '../theme/theme.dart';

extension ContextExtension on BuildContext {
  // ── Theme shortcuts ──────────────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  TextTheme get typography => theme.textTheme;
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Semantic/custom colors (success, warning, info).
  AppColorsExtension get appColors =>
      theme.extension<AppColorsExtension>() ??
      (isDarkMode ? AppPalettes.dark : AppPalettes.light);

  /// Design tokens (spacing, border radii, elevation defaults).
  AppDesignTokens get designTokens =>
      theme.extension<AppDesignTokens>() ?? AppDesignTokens.fallback;

  // ── MediaQuery shortcuts ─────────────────────────────────────────────────
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  Size get screenSize => mediaQuerySize;
  double get width => mediaQuerySize.width;
  double get height => mediaQuerySize.height;

  /// Safe-area insets for the current view.
  EdgeInsets get safeArea => MediaQuery.paddingOf(this);

  // ── Keyboard ──────────────────────────────────────────────────────────────
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
  void hideKeyboard() => FocusScope.of(this).unfocus();

  // ── Platform ─────────────────────────────────────────────────────────────
  bool get isIOS => theme.platform == TargetPlatform.iOS;
  bool get isAndroid => theme.platform == TargetPlatform.android;

  // ── Overlays ─────────────────────────────────────────────────────────────
  void showSnackBar(
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          duration: duration,
        ),
      );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: appColors.success,
        ),
      );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colors.error,
        ),
      );
  }

  Future<T?> showAppBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
    );
  }

  Future<T?> showAppDialog<T>({required WidgetBuilder builder}) {
    return showDialog<T>(
      context: this,
      builder: builder,
    );
  }

  /// Shows a snackbar with a colour driven by [SnackBarType].

  void showTypedSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final bg = switch (type) {
      SnackBarType.success => appColors.success,
      SnackBarType.warning => appColors.warning,
      SnackBarType.error => colors.error,
      SnackBarType.info => colors.inverseSurface,
    };
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: bg,
          duration: duration,
        ),
      );
  }

  
}

/// Mobile / tablet resolution used by every screen in the app.

/// padding: EdgeInsets.all(context.adaptive(mobile: 24.0, tablet: 48.0))

/// if (context.isTablet) TabletNav() else MobileNav(),

extension AppDeviceExtension on BuildContext {
  /// Shortest-side breakpoint, so a phone in landscape stays "mobile".
  static const double tabletBreakpoint = 600;

  AppDeviceType get deviceType =>
      MediaQuery.sizeOf(this).shortestSide >= tabletBreakpoint
          ? AppDeviceType.tablet
          : AppDeviceType.mobile;

  bool get isTablet => deviceType == AppDeviceType.tablet;
  bool get isMobile => deviceType == AppDeviceType.mobile;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Picks the value matching the current device type.
  T adaptive<T>({required T mobile, required T tablet}) =>
      isTablet ? tablet : mobile;
}

extension AppFontSizeExtension on BuildContext {
  static const double _designWidth = 390;
  static const double _minScale = 0.85;
  static const double _maxScale = 1.30;

  double get _fontScale {
    final width = MediaQuery.sizeOf(this).width;

    return (width / _designWidth).clamp(
      _minScale,
      _maxScale,
    );
  }

  double _responsiveFont(double size) {
    return size * _fontScale;
  }

  // Raw font sizes
  double get font10 => _responsiveFont(10);
  double get font11 => _responsiveFont(11);
  double get font12 => _responsiveFont(12);
  double get font13 => _responsiveFont(13);
  double get font14 => _responsiveFont(14);
  double get font15 => _responsiveFont(15);
  double get font16 => _responsiveFont(16);
  double get font18 => _responsiveFont(18);
  double get font20 => _responsiveFont(20);
  double get font22 => _responsiveFont(22);
  double get font24 => _responsiveFont(24);
  double get font28 => _responsiveFont(28);
  double get font32 => _responsiveFont(32);
  double get font36 => _responsiveFont(36);
  double get font40 => _responsiveFont(40);
  double get font48 => _responsiveFont(48);

  // Semantic font sizes
  double get fontCaption => font12;
  double get fontLabel => font14;
  double get fontBody => font16;
  double get fontBodyLarge => font18;
  double get fontTitle => font20;
  double get fontTitleLarge => font24;
  double get fontHeading => font28;
  double get fontHeadingLarge => font32;
  double get fontDisplay => font40;
  double get fontDisplayLarge => font48;
}
