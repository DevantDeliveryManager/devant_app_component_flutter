import 'package:flutter/material.dart';

import 'package:devant_components/extensions/context_extension.dart';

class AppErrorBanner extends StatelessWidget {
  const AppErrorBanner({
    super.key,
    required this.title,
    required this.message,
    this.statusCode,
    this.actionLabel = 'Refresh',
    this.onAction,
    this.margin,
  });

  final String title;
  final String message;
  final int? statusCode;

  final String actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colors = _getErrorColors(statusCode);

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getIcon(statusCode),
              size: 22,
              color: colors.foreground,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.font16,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: context.font14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                if (onAction != null) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onAction,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.foreground,
                      side: BorderSide(
                        color: colors.foreground,
                      ),
                    ),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 18,
                    ),
                    label: Text(actionLabel),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  _ErrorColors _getErrorColors(int? statusCode) {
    if (statusCode == null) {
      return const _ErrorColors(
        foreground: Color(0xFFD97706),
        background: Color(0xFFFFF7ED),
        border: Color(0xFFFED7AA),
      );
    }

    return switch (statusCode) {
      400 || 422 => const _ErrorColors(
          foreground: Color(0xFFD97706),
          background: Color(0xFFFFF7ED),
          border: Color(0xFFFED7AA),
        ),
      401 || 403 => const _ErrorColors(
          foreground: Color(0xFFDC2626),
          background: Color(0xFFFEF2F2),
          border: Color(0xFFFECACA),
        ),
      404 => const _ErrorColors(
          foreground: Color(0xFF2563EB),
          background: Color(0xFFEFF6FF),
          border: Color(0xFFBFDBFE),
        ),
      408 || 429 => const _ErrorColors(
          foreground: Color(0xFF9333EA),
          background: Color(0xFFFAF5FF),
          border: Color(0xFFE9D5FF),
        ),
      >= 500 => const _ErrorColors(
          foreground: Color(0xFFDC2626),
          background: Color(0xFFFEF2F2),
          border: Color(0xFFFECACA),
        ),
      _ => const _ErrorColors(
          foreground: Color(0xFF475569),
          background: Color(0xFFF8FAFC),
          border: Color(0xFFE2E8F0),
        ),
    };
  }

  IconData _getIcon(int? statusCode) {
    if (statusCode == null) {
      return Icons.warning_amber_rounded;
    }

    return switch (statusCode) {
      400 || 422 => Icons.warning_amber_rounded,
      401 || 403 => Icons.lock_outline_rounded,
      404 => Icons.search_off_rounded,
      408 => Icons.schedule_rounded,
      429 => Icons.hourglass_top_rounded,
      >= 500 => Icons.error_outline_rounded,
      _ => Icons.info_outline_rounded,
    };
  }
}

class _ErrorColors {
  const _ErrorColors({
    required this.foreground,
    required this.background,
    required this.border,
  });

  final Color foreground;
  final Color background;
  final Color border;
}
