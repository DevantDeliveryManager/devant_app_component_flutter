import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extension.dart';
import '../theme/theme_constants.dart';

/// An AI-written alternative shown under a field: a sparkle icon, the text,
/// and an Apply button that hands the text back through [onApply].
class AiSuggestionBox extends StatelessWidget {
  const AiSuggestionBox({
    super.key,
    required this.text,
    required this.onApply,
  });

  final String text;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: AppBrandColors.socialFill,
        borderRadius: AppBorders.input,
        border: Border.all(color: AppBrandColors.cta.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.r),
                child: Icon(
                  Icons.auto_awesome,
                  size: 16.r,
                  color: AppBrandColors.cta,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  text,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppBrandColors.plum,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: onApply,
              child: Text(
                "Apply",
                style: TextStyle(
                  color: AppBrandColors.cta,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
