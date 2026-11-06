import 'package:flutter/material.dart';
import 'package:devant_components/widgets/ui/app/navigation/app_circle_icon_button.dart';

/// The brand's round frosted back button: a chevron on paper, softly lifted.
///
/// Goes back a screen when tapped, unless [onPressed] says otherwise. Use it
/// on its own over a page, or as [AppTopBar.leading].
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.enabled = true});

  /// The button's width and height, before screen scaling.
  static const double size = AppCircleIconButton.size;

  /// What a tap does; going back a screen when not given.
  final VoidCallback? onPressed;

  /// Off while something is being saved.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppCircleIconButton(
      icon: Icons.chevron_left_rounded,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: !enabled
          ? null
          : onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}
