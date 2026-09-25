# devant_components

A reusable Flutter widget library: buttons and form widgets that follow your app's theme (light and dark) and are fully customizable. It is shared across multiple apps.

[![GitHub stars](https://img.shields.io/github/stars/DevantDeliveryManager/devant_app_component_flutter?style=for-the-badge&logo=github)](https://github.com/DevantDeliveryManager/devant_app_component_flutter/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/DevantDeliveryManager/devant_app_component_flutter?style=for-the-badge&logo=github)](https://github.com/DevantDeliveryManager/devant_app_component_flutter/network/members)
[![GitHub issues](https://img.shields.io/github/issues/DevantDeliveryManager/devant_app_component_flutter?style=for-the-badge&logo=github)](https://github.com/DevantDeliveryManager/devant_app_component_flutter/issues)
[![GitHub last commit](https://img.shields.io/github/last-commit/DevantDeliveryManager/devant_app_component_flutter?style=for-the-badge&logo=github)](https://github.com/DevantDeliveryManager/devant_app_component_flutter/commits/main)

## Installation

Add the package to your app's `pubspec.yaml` as a git dependency:

```yaml
dependencies:
  devant_components:
    git:
      url: https://github.com/DevantDeliveryManager/devant_app_component_flutter.git
```

Then run:

```bash
flutter pub get
```

### Pin a version (recommended for production apps)

Without `ref`, Flutter uses the default branch. To keep your app stable, pin to a branch, tag or commit:

```yaml
dependencies:
  devant_components:
    git:
      url: https://github.com/DevantDeliveryManager/devant_app_component_flutter.git
      ref: v0.0.1   # tag, branch name or commit hash
```

### Get the latest changes

Git dependencies are locked in `pubspec.lock`. To pull newer commits:

```bash
flutter pub upgrade devant_components
```


## Usage

Import once. Everything is exported from a single file:

```dart
import 'package:devant_components/devant_components.dart';
```



| Widget | Purpose |
|---|---|
| `AppTextField` | Text input: label, hint, helper, prefix/suffix, password toggle, counter, multi-line |
| `AppDropdown<T>` | Dropdown for any list of items, with a custom label or item builder |
| `AppDatePicker` | Field that opens the Material date picker; custom format, min/max dates, clearable |
| `AppRadio<T>` | Radio group built from `AppRadioOption`s; vertical or horizontal |
| `AppChips<T>` | Single or multi select chips, with an optional selection limit |

Notes:
- `AppDropdown` uses `value` as the initial selection only. Its later selections are held by the field and reported through `onChanged`.
- `AppRadio` and `AppChips` follow the `value` you pass, so rebuild them from your state as shown above.

## Theming

Widgets read colors and text styles from your app's `Theme`, so they follow light and dark mode and your `ColorScheme` automatically. Each widget also accepts per-instance overrides (colors, border radius, text styles).

## Example app

A demo app with a screen for each widget category is in [example/](example/):

```bash
cd example
flutter run
```

## Contributing

See [CLAUDE.md](CLAUDE.md) for the project structure and conventions. In short: every public widget is exported from `lib/devant_components.dart`, and every widget gets a demo screen in `example/lib/screens/`.
