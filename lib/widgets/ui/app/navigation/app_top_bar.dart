import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:devant_components/extensions/context_extension.dart';

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
  });

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
      title: titleWidget ??
          Text(
            title,
            style: theme.appBarTheme.titleTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 1.1
                ) ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
      leadingWidth: 50.w,
      leading: Visibility(
        visible: isVisibility ?? false,
        child: GestureDetector(
          onTap: handleBack,
          child: ColoredBox(
            color: Colors.transparent,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: theme.appBarTheme.iconTheme?.color ??
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
