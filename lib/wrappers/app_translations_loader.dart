import 'dart:convert';
import 'dart:ui' show Locale;

import 'package:easy_localization/easy_localization.dart'
    show AssetLoader, RootBundleAssetLoader;
import 'package:flutter/services.dart';

/// Loads the translations bundled with `devant_components` and merges them
/// under the app's own, so the app's keys win on conflict.
///
/// ```dart
/// EasyLocalization(
///   supportedLocales: const [Locale('en')],
///   path: 'assets/translations',
///   assetLoader: const AppTranslationsLoader(),
///   child: const MyApp(),
/// )
/// ```
class AppTranslationsLoader extends AssetLoader {
  /// Creates a loader. [appLoader] reads the app's own translations.
  const AppTranslationsLoader({this.appLoader = const RootBundleAssetLoader()});

  /// Loader for the app's own translation files.
  final AssetLoader appLoader;

  static const _packageAsset =
      'packages/devant_components/assets/translations/en.json';

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final packageJson = await rootBundle
        .loadString(_packageAsset)
        .then(_decode);
    Map<String, dynamic>? app;
    try {
      app = await appLoader.load(path, locale);
    } catch (_) {
      // The app may not ship this locale; the package defaults still apply.
    }
    return _merge(packageJson, app ?? const {});
  }

  static Map<String, dynamic> _decode(String source) =>
      Map<String, dynamic>.from(json.decode(source) as Map);

  static Map<String, dynamic> _merge(
    Map<String, dynamic> base,
    Map<String, dynamic> over,
  ) {
    final out = Map<String, dynamic>.of(base);
    over.forEach((key, value) {
      final existing = out[key];
      out[key] =
          existing is Map<String, dynamic> && value is Map<String, dynamic>
          ? _merge(existing, value)
          : value;
    });
    return out;
  }
}
