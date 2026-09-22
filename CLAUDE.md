# CLAUDE.md

## Project

`devant_components` is a Flutter package of reusable UI widgets. It is consumed by ~10 different apps, so every widget must be generic, configurable, and free of app-specific logic.

- SDK: Dart ^3.12.2, Flutter package (no `main.dart`, no app code)
- Lints: `flutter_lints` (see `analysis_options.yaml`)
- Commands: `flutter analyze`, `flutter test`

## Structure

One folder per widget category under `lib/`:

```
lib/
  devant_components.dart   # single public entry point (barrel file)
  button/                  # buttons (app_button.dart, ...)
  forms/                   # text field, dropdown, date picker, radio, chips
  bottom_sheet/            # modal / persistent bottom sheets
  dialogbox/               # alert, confirm, and custom dialogs
  snackbar/                # snackbars / toasts
  feedback/                # success, failure, pending widgets
  banner/                  # inline / top banners (info, warning, error, etc.)
```

Folder names are `snake_case`, singular, and match the categories above. Do not add a new top-level category without asking.

## Example app (demo screens)

[example/](example/) is a Flutter demo app (depends on this package via `path: ../`; run with `cd example && flutter run`) showing every widget in use. It has one demo screen per feature category, each showcasing the different types/variants of that feature.

```
example/
  lib/main.dart            # app entry; home screen lists links to each demo screen
  lib/screens/
    button_demo_screen.dart        # filled/outlined/text, loading, subtitle, leading/trailing, disabled
    form_demo_screen.dart          # text field, dropdown, date picker, radio, chips
    bottom_sheet_demo_screen.dart
    dialogbox_demo_screen.dart
    snackbar_demo_screen.dart
    feedback_demo_screen.dart      # success, failure, pending
    banner_demo_screen.dart
```

- **Every new widget or new variant must get a demo** in its category's screen, in the same change.
- Demos import only `package:devant_components/devant_components.dart`, exactly as consuming apps do. This also verifies the export.
- Show each type/variant and state (default, loading, disabled, error, etc.) with a short section label. Keep demos simple: no app-specific logic and no extra packages.
- The example app may use its own `MaterialApp` and theme; include a light/dark toggle when practical to check theming.

## Exports (important)

**Everything public must be exported from [lib/devant_components.dart](lib/devant_components.dart).** Apps import only `package:devant_components/devant_components.dart`.

- When adding a widget file, add its `export` line in the same change, grouped by folder and alphabetized.
- Never make apps import from `package:devant_components/<folder>/...` directly.
- Keep internal helpers private: don't export them, and prefix with `_` where possible.

## Widget guidelines

- **Reusable first:** no hardcoded strings, colors, or app-specific navigation/state. Everything comes via constructor parameters.
- **Theming:** default to `Theme.of(context)` (colors, text styles) so widgets adapt to each app's theme and dark mode. Allow per-widget overrides through optional params.
- **No heavy dependencies:** avoid adding packages to `pubspec.yaml` unless essential; each one is inherited by all 10 apps. Ask first.
- **State management agnostic:** don't depend on Provider, Bloc, GetX, etc. Use callbacks (`onPressed`, `onChanged`) and plain `StatefulWidget` only when needed.
- **API design:** `const` constructors, `super.key`, named parameters, required only where truly needed, sensible defaults. Use `final` fields.
- **Naming:** widgets are prefixed `Devant` only if a collision with Flutter names is possible; otherwise follow the existing style (e.g. `AppButton` in `app_button.dart`). One public widget per file; file name is the `snake_case` of the class name.
- **Accessibility:** provide `Semantics`/tooltips where relevant, respect minimum tap size (48x48), and support text scaling.
- **Docs:** add `///` doc comments on every public class and parameter, with a short usage example for non-trivial widgets.
- **Breaking changes:** these widgets are used by many apps. Avoid renaming or removing public APIs; deprecate with `@Deprecated` first. Bump `version` in `pubspec.yaml` and note the change in `CHANGELOG.md`.

## Category notes

- **button:** variants (filled, outlined, text, icon), loading and disabled states, optional icons.
- **forms:** `AppTextField`, `AppDropdown`, `AppDatePicker`, `AppRadio`, `AppChips`. All integrate with `Form`/`FormField` (validator, autovalidateMode) and share the internal `app_input_decoration.dart` (not exported) for a consistent look.
- **bottom_sheet:** helper functions (e.g. `showXBottomSheet`) plus the content widgets; support drag handle, scroll control, and safe area.
- **dialogbox:** `showXDialog` helpers returning `Future<T?>`; support title, message, custom content, and action buttons.
- **snackbar:** helper to show via `ScaffoldMessenger`; types (success, error, info, warning), optional action.
- **feedback:** three states, **success**, **failure**, **pending**. Each takes a title, message, optional icon/animation, and optional action callback (e.g. retry).
- **banner:** dismissible, typed (info, success, warning, error), optional action and icon.

## Testing

- Add widget tests under `test/`, mirroring the `lib/` folder layout.
- Cover default rendering, callbacks, disabled/loading states, and theming.
- Run `flutter analyze` and `flutter test` before finishing any change.

## Working with Claude

- Follow existing code style; keep changes minimal and focused.
- Don't edit `pubspec.yaml` dependencies without asking.
- After creating or renaming a file, verify the export in `lib/devant_components.dart`.
- After adding or changing a widget, update its demo screen in `example/lib/screens/`.
