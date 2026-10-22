/// The two form factors every screen in this app is designed for.
library;

enum AppDeviceType {
  mobile,
  tablet,
}

/// Shared size scale for App components beyond buttons.
enum AppSize {
  small,
  medium,
  large,
}

/// Shared visual emphasis for chips, badges, banners, etc.
enum AppVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  success,
  info,
  warning,
}

/// Input density / chrome variants.
enum AppInputVariant {
  outlined,
  filled,
  underlined,
}
