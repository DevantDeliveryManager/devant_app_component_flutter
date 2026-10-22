import 'dart:async';

import 'package:devant_components/theme/theme_constants.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import 'ui/app/layout/layout.dart';



/// The app's search bar (Discover, Explore sessions): a rounded field with
/// a search icon and an optional [trailing] action inside it, e.g.
/// [AppFilterButton].
///
/// [onChanged] gets the trimmed text once typing pauses for [debounce], so
/// a search isn't sent per keystroke; submitting reports it at once.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.trailing,
    this.debounce = const Duration(milliseconds: 300),
  });

  final String hint;
  final ValueChanged<String>? onChanged;

  /// Shown at the end of the field.
  final Widget? trailing;
  final Duration debounce;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () => _report(value));
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    _report(value);
  }

  void _report(String value) {
    if (mounted) widget.onChanged?.call(value.trim());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium?.inter;
    final trailing = widget.trailing;

    return Container(
      height: 52,
      padding: EdgeInsets.only(
        left: AppSpacing.ms,
        right: trailing == null ? AppSpacing.ms : 6,
      ),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppBrandColors.fieldBorder),
        boxShadow:  [
          BoxShadow(
            color: AppBrandColors.scheme.bookShadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
           Icon(
            Icons.search_rounded,
            size: 20,
            color: AppBrandColors.plumMuted,
          ),
          const AppGap.sm(axis: Axis.horizontal),
          Expanded(
            child: TextField(
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              textInputAction: TextInputAction.search,
              cursorColor: AppBrandColors.cta,
              style: textStyle?.copyWith(
                color: AppBrandColors.plum,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: textStyle?.copyWith(color: AppBrandColors.subtle),
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (trailing != null) ...[
            const AppGap.xs(axis: Axis.horizontal),
            trailing,
          ],
        ],
      ),
    );
  }
}
