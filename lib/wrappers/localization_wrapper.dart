import 'package:easy_localization/easy_localization.dart'
    hide TextDirection, MapExtension;
import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';

import 'app_translations_loader.dart';

/// A wrapper to initialize [EasyLocalization] with supported locales.
class LocalizationWrapper extends StatelessWidget {
  final Widget child;

  const LocalizationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es'), Locale('fr')],
      path: 'assets/translations',
      assetLoader: const AppTranslationsLoader(),
      fallbackLocale: const Locale('en'),
      child: child,
    );
  }
}
