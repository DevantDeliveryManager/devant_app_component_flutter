import 'dart:async';

import 'package:devant_components/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extension.dart';

/// The app's search bar (Discover, Explore sessions, Bookings): a search
/// icon and a field on paper, ringed in gold while typing, with a clear
/// button once there's text and an optional [trailing] action inside it,
/// e.g. [AppFilterButton].
///
/// [onChanged] gets the trimmed text once typing pauses for [debounce], so
/// a search isn't sent per keystroke; submitting or clearing reports it at
/// once.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hint,
    this.onChanged,
    this.trailing,
    this.controller,
    this.clearTooltip,
    this.debounce = const Duration(milliseconds: 300),
  });

  final String hint;
  final ValueChanged<String>? onChanged;

  /// Shown at the end of the field.
  final Widget? trailing;

  /// Owned here when not given.
  final TextEditingController? controller;

  /// Read out for the clear button.
  final String? clearTooltip;
  final Duration debounce;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _debounce;

  /// The text last reported, so the same search isn't sent twice.
  late String _reported = _controller.text.trim();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_rebuild);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () => _report(value));
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    _report(value);
  }

  void _clear() {
    _controller.clear();
    _onSubmitted('');
  }

  void _report(String value) {
    final query = value.trim();
    if (!mounted || query == _reported) return;
    _reported = query;
    widget.onChanged?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textTheme.bodyMedium?.inter;
    final trailing = widget.trailing;
    final isFocused = _focus.hasFocus;
    final hasText = _controller.text.isNotEmpty;
    final ink = AppBrandColors.plum;
    final gold = AppBrandColors.gold;

    return AnimatedContainer(
      duration: AppDurations.quick,
      curve: AppCurves.standard,
      height: 50.r,
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: trailing != null || hasText ? AppSpacing.xsm : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isFocused ? gold : ink.withValues(alpha: 0.12),
          width: isFocused ? 1.5 : 1,
        ),
        boxShadow: isFocused ? AppShadows.fieldFocus : AppShadows.field,
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20.r, color: AppBrandColors.subtle),
          SizedBox(width: AppSpacing.ms),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              onChanged: _onChanged,
              onSubmitted: _onSubmitted,
              onTapOutside: (_) => _focus.unfocus(),
              textInputAction: TextInputAction.search,
              cursorColor: ink,
              style: textStyle?.copyWith(
                color: ink,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: textStyle?.copyWith(
                  color: AppBrandColors.subtle.withValues(alpha: 0.85),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (hasText)
            IconButton(
              tooltip: widget.clearTooltip,
              visualDensity: VisualDensity.compact,
              onPressed: _clear,
              icon: Icon(
                Icons.close_rounded,
                size: 18.r,
                color: AppBrandColors.subtle,
              ),
            ),
          if (trailing != null) ...[
            SizedBox(width: AppSpacing.xs),
            trailing,
          ],
        ],
      ),
    );
  }
}
