# devant_components

A reusable Flutter widget library: buttons and form widgets that follow your app's theme (light and dark) and are fully customizable. It is shared across multiple apps.

## Installation

Add the package to your app's `pubspec.yaml` as a git dependency:

```yaml
dependencies:
  devant_components:
    git:
      url: https://github.com/swagatapaldevant/devant_app_componant_flutter.git
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
      url: https://github.com/swagatapaldevant/devant_app_componant_flutter.git
      ref: v0.0.1   # tag, branch name or commit hash
```

### Get the latest changes

Git dependencies are locked in `pubspec.lock`. To pull newer commits:

```bash
flutter pub upgrade devant_components
```

### Private repository

If the repo is private, your machine needs git access to it (SSH key or a credential helper). With SSH, use the SSH url instead:

```yaml
url: git@github.com:swagatapaldevant/devant_app_componant_flutter.git
```

## Usage

Import once. Everything is exported from a single file:

```dart
import 'package:devant_components/devant_components.dart';
```

### AppButton

Filled, outlined and text variants, with a subtitle, leading and trailing widgets and a loading state.

```dart
AppButton(
  label: 'Pay now',
  subtitle: 'Total \$25.00',
  leading: const Icon(Icons.lock),
  trailing: const Icon(Icons.arrow_forward),
  isLoading: isSubmitting,
  onPressed: submit,
)

AppButton(
  label: 'Cancel',
  variant: AppButtonVariant.outlined,
  isExpanded: false,
  onPressed: () => Navigator.pop(context),
)
```

Useful options: `variant`, `isLoading`, `loadingLabel`, `loadingWidget`, `backgroundColor`, `foregroundColor`, `borderRadius`, `borderColor`, `elevation`, `padding`, `width`, `height`, `labelStyle`, `subtitleStyle`, `tooltip`, or a fully custom `child`. A button with no `onPressed` is shown disabled.

### Forms

All form widgets work inside a `Form`, so `formKey.currentState!.validate()` checks them together.

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      AppTextField(
        label: 'Email',
        hint: 'you@example.com',
        prefix: const Icon(Icons.email_outlined),
        keyboardType: TextInputType.emailAddress,
        validator: (v) => (v ?? '').contains('@') ? null : 'Invalid email',
      ),
      const AppTextField(
        label: 'Password',
        isPassword: true, // built-in show/hide toggle
      ),
      AppDropdown<String>(
        label: 'Country',
        items: const ['India', 'USA', 'UK'],
        onChanged: (v) => setState(() => country = v),
        validator: (v) => v == null ? 'Pick a country' : null,
      ),
      AppDatePicker(
        label: 'Date of birth',
        lastDate: DateTime.now(),
        onChanged: (d) => setState(() => dob = d),
      ),
      AppRadio<String>(
        label: 'Gender',
        value: gender,
        options: const [
          AppRadioOption(value: 'm', label: 'Male'),
          AppRadioOption(value: 'f', label: 'Female'),
        ],
        onChanged: (v) => setState(() => gender = v),
      ),
      AppChips<String>(
        label: 'Interests',
        items: const ['Music', 'Sports', 'Travel'],
        value: interests,
        multiSelect: true,
        onChanged: (v) => setState(() => interests = v),
      ),
      AppButton(
        label: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // submit
          }
        },
      ),
    ],
  ),
)
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
