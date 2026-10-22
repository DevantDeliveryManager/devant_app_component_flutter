/// A dialling code the user can attach to a phone number.
class CountryCode {
  const CountryCode({
    required this.name,
    required this.iso,
    required this.dialCode,
    required this.flag,
  });

  final String name;

  /// ISO 3166-1 alpha-2, e.g. `IN`.
  final String iso;

  /// E.164 prefix including the `+`, e.g. `+91`.
  final String dialCode;

  /// Emoji flag, rendered by the platform font.
  final String flag;

  /// Compact form for the picker trigger: `🇮🇳 +91`.
  String get shortLabel => '$flag $dialCode';

  /// Full form for the picker list: `🇮🇳 India (+91)`.
  String get fullLabel => '$flag $name ($dialCode)';
}

/// Dialling codes offered in the phone field.
abstract final class CountryCodes {
  CountryCodes._();

  static const CountryCode india =
      CountryCode(name: 'India', iso: 'IN', dialCode: '+91', flag: '🇮🇳');

  /// Pre-selected when the phone field first appears.
  static const CountryCode fallback = india;

  /// Looks a code up by ISO, falling back to [fallback] when unknown.
  static CountryCode fromIso(String iso) {
    final upper = iso.toUpperCase();
    for (final country in all) {
      if (country.iso == upper) return country;
    }
    return fallback;
  }

  static const List<CountryCode> all = [
    india,
  ];
}
