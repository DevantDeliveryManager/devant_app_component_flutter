import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:devant_components/extensions/context_extension.dart';
import 'package:devant_components/theme/app_spacing.dart';
import 'package:devant_components/widgets/ui/app/navigation/app_back_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
    this.centerTitle = true,
    this.onPressed,
    this.isTransparent = false,
    this.isVisibility = false,
    this.leading,
  });

  /// In place of the plain back arrow, e.g. an [AppBackButton]; shown
  /// whatever [isVisibility] says.
  final Widget? leading;

  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final VoidCallback? onPressed;
  final bool? centerTitle;
  final bool isTransparent;
  final bool? isVisibility;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Check if we can pop
    final bool canPop = context.canPop();

    void handleBack() {
      if (onPressed != null) {
        onPressed!();
      } else if (canPop) {
        context.pop();
      } else {}
    }

    return AppBar(
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: isTransparent ? Colors.transparent : null,
      shadowColor: Colors.transparent,
      title:
          titleWidget ??
          Text(
            title,
            style:
                theme.appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 1.1,
                ) ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
      // A custom leading keeps the page's margin on its left.
      leadingWidth: leading == null ? 50.w : AppBackButton.size.r + AppSpacing.md,
      leading: leading != null
          ? Padding(
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Center(child: leading),
            )
          : Visibility(
              visible: isVisibility ?? false,
              child: GestureDetector(
                onTap: handleBack,
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color:
                        theme.appBarTheme.iconTheme?.color ??
                        theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
      iconTheme: theme.appBarTheme.iconTheme,
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
