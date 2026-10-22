import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:devant_components/devant_components.dart' show AppButton;
import 'package:flutter/material.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/theme/brand_colors.dart';
import 'package:devant_components/theme/theme_constants.dart';

import '../../../../app_platform.dart';

/// Opinionated alert dialog with confirm / cancel actions. A `null`
/// [cancelLabel] leaves only the confirm action, for a notice.
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    this.message,
    this.confirmLabel = 'OK',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    this.icon,
    this.platform,
    this.isBusy = false,
    this.onConfirm,
  });

  final String title;
  final String? message;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;

  /// The badge above the title (Material only); a warning when
  /// [isDestructive], else an info mark.
  final IconData? icon;
  final AppPlatformStyle? platform;

  /// Work is running: the confirm button shows a loader, Cancel is off, and
  /// the dialog can't be dismissed.
  final bool isBusy;

  /// Replaces the default confirm action (closing with `true`).
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final colors = context.colors;
    final confirmColor = isDestructive ? colors.error : colors.primary;
    final confirm = isBusy
        ? null
        : onConfirm ?? () => Navigator.of(context).pop(true);

    if (useCupertino) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: message == null
            ? null
            : Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: Text(message!),
              ),
        actions: [
          if (cancelLabel case final cancel?)
            CupertinoDialogAction(
              onPressed:
                  isBusy ? null : () => Navigator.of(context).pop(false),
              child: Text(cancel),
            ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            onPressed: confirm,
            child: Text(
              confirmLabel,
              style: TextStyle(color: confirmColor),
            ),
          ),
        ],
      );
    }

    // Top to bottom: icon, title, message, then the actions, centred so the
    // eye lands on the question and ends on the buttons.
    final accent = isDestructive ? colors.error : AppBrandColors.cta;
    final onAccent = isDestructive ? colors.onError : AppBrandColors.onCta;
    final buttonRadius = BorderRadius.circular(12);
    final body = message;

    return PopScope(
      // Not even the back button closes it while work is running.
      canPop: !isBusy,
      child: Dialog(
      backgroundColor: AppBrandColors.pageBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 6,
      insetPadding: EdgeInsets.all(AppSpacing.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md + 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: _badge,
                  height: _badge,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ??
                        (isDestructive
                            ? Icons.warning_amber_rounded
                            : Icons.info_outline_rounded),
                    size: 22,
                    color: accent,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppBrandColors.plum,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (body != null) ...[
                SizedBox(height: AppSpacing.xxs),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppBrandColors.plumMuted,
                    height: 1.4,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (cancelLabel case final cancel?) ...[
                    Expanded(
                      // Soft and borderless: the confirm button is the one
                      // that stands out.
                      child: AppButton(
                        label: cancel,
                        onPressed: isBusy
                            ? null
                            : () => Navigator.of(context).pop(false),
                        isFullWidth: true,
                        borderRadius: buttonRadius,
                        color: AppBrandColors.tabInactiveFill,
                        textColor: AppBrandColors.plum,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: AppButton(
                      label: confirmLabel,
                      onPressed: confirm,
                      isLoading: isBusy,
                      isFullWidth: true,
                      borderRadius: buttonRadius,
                      color: accent,
                      textColor: onAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  static const double _badge = 44;
  static const double _maxWidth = 320;
}

/// Presents [AppAlertDialog] and returns `true` if confirmed.
///
/// With [onConfirm], tapping confirm doesn't close the dialog: it stays open
/// with the confirm button loading while [onConfirm] runs, then closes with
/// its result (`true` if it worked, `false` if not).
Future<bool?> showAppAlertDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'OK',
  String? cancelLabel = 'Cancel',
  bool isDestructive = false,
  IconData? icon,
  AppPlatformStyle? platform,
  Future<bool> Function()? onConfirm,
}) {
  final useCupertino = platform != null
      ? platform == AppPlatformStyle.cupertino
      : context.isCupertinoUi;

  Widget dialog() => onConfirm == null
      ? AppAlertDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
          icon: icon,
          platform: platform,
        )
      : _ConfirmingAlertDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          isDestructive: isDestructive,
          icon: icon,
          platform: platform,
          onConfirm: onConfirm,
        );

  if (useCupertino) {
    return showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => dialog(),
    );
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: onConfirm == null,
    builder: (_) => dialog(),
  );
}

/// An [AppAlertDialog] whose confirm runs [onConfirm] first, staying open and
/// busy until it finishes.
class _ConfirmingAlertDialog extends StatefulWidget {
  const _ConfirmingAlertDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.isDestructive,
    required this.icon,
    required this.platform,
    required this.onConfirm,
  });

  final String title;
  final String? message;
  final String confirmLabel;
  final String? cancelLabel;
  final bool isDestructive;
  final IconData? icon;
  final AppPlatformStyle? platform;
  final Future<bool> Function() onConfirm;

  @override
  State<_ConfirmingAlertDialog> createState() => _ConfirmingAlertDialogState();
}

class _ConfirmingAlertDialogState extends State<_ConfirmingAlertDialog> {
  bool _isBusy = false;

  Future<void> _confirm() async {
    setState(() => _isBusy = true);
    var succeeded = false;
    try {
      succeeded = await widget.onConfirm();
    } finally {
      if (mounted) Navigator.of(context).pop(succeeded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppAlertDialog(
      title: widget.title,
      message: widget.message,
      confirmLabel: widget.confirmLabel,
      cancelLabel: widget.cancelLabel,
      isDestructive: widget.isDestructive,
      icon: widget.icon,
      platform: widget.platform,
      isBusy: _isBusy,
      onConfirm: _confirm,
    );
  }
}
