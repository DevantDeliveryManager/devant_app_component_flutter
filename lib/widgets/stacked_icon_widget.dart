import 'package:flutter/material.dart';

class StackedIconWidget extends StatelessWidget {
  const StackedIconWidget({
    super.key,
    required this.icon,
    this.count,
    this.showDot = false,
    this.iconSize = 24,
    this.iconColor,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeSize = 18,
    this.maxCount = 99,
    this.onTap,
    this.padding = const EdgeInsets.all(8),
  });

  final IconData icon;

  /// Badge count.
  ///
  /// null or <= 0 hides the count badge.
  final int? count;

  /// Displays a simple dot instead of count.
  final bool showDot;

  final double iconSize;
  final Color? iconColor;

  final Color? badgeColor;
  final Color? badgeTextColor;
  final double badgeSize;

  /// Example:
  /// 100 becomes "99+"
  final int maxCount;

  final VoidCallback? onTap;

  final EdgeInsetsGeometry padding;

  bool get _showBadge => showDot || (count != null && count! > 0);

  String get _badgeText {
    if (count == null) return '';

    if (count! > maxCount) {
      return '$maxCount+';
    }

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final widget = Padding(
      padding: padding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          if (_showBadge)
            Positioned(
              top: -6,
              right: -8,
              child: showDot
                  ? _buildDot(colorScheme)
                  : _buildCountBadge(colorScheme),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return widget;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: widget,
    );
  }

  Widget _buildDot(ColorScheme colorScheme) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        color: badgeColor ?? colorScheme.error,
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.surface,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildCountBadge(ColorScheme colorScheme) {
    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor ?? colorScheme.error,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colorScheme.surface,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _badgeText,
        style: TextStyle(
          color: badgeTextColor ?? colorScheme.onError,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }
}
