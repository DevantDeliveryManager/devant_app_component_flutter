import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devant_components/theme/app_fonts.dart';
import 'package:devant_components/theme/app_shadows.dart';
import 'package:devant_components/theme/app_spacing.dart';
import 'package:devant_components/theme/brand_colors.dart';

/// The brand's field: a small uppercase [label] tucked in the top corner,
/// the value under it, and a gold ring while it has focus (clay, with the
/// reason under it, when [errorText] is given). 60 tall on one line; with
/// [maxLines] above 1 it grows with its text, e.g. a note.
///
/// Editable with a [controller]; with a [value] instead, it shows that as
/// it is (e.g. a country code), or [hint] while it is empty, and [onTap]
/// can open a picker.
class AppLabelField extends StatefulWidget {
  const AppLabelField({
    super.key,
    required this.label,
    this.controller,
    this.value,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.leading,
    this.trailing,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.minLines,
    this.maxLines = 1,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  }) : assert(
         (controller == null) != (value == null),
         'Give a controller to edit, or a value to show.',
       );

  final String label;
  final TextEditingController? controller;
  final String? value;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  /// For a field showing a [value]: what a tap does, e.g. open a picker.
  final VoidCallback? onTap;

  /// At the start of the field, e.g. a "₹".
  final Widget? leading;

  /// At the end of the field, e.g. a "Verified" tag or a chevron.
  final Widget? trailing;

  /// Rings the field in clay and says why under it.
  final String? errorText;

  /// Off, e.g. while the form is being sent.
  final bool enabled;

  /// Shown but can't be changed.
  final bool readOnly;

  final int? minLines;

  /// Above 1, the field grows with its text instead of staying 60 tall.
  final int? maxLines;

  /// Takes focus as soon as it shows, e.g. a reply box just opened.
  final bool autofocus;

  final TextCapitalization textCapitalization;

  /// One line's height, in design pixels.
  static const double height = 60;

  @override
  State<AppLabelField> createState() => _AppLabelFieldState();
}

class _AppLabelFieldState extends State<AppLabelField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  @override
  void dispose() {
    _focus
      ..removeListener(_onFocus)
      ..dispose();
    super.dispose();
  }

  void _onFocus() => setState(() {});

  static TextStyle _text({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
  }) => TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: size.sp,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color ?? AppBrandColors.plum,
  );

  @override
  Widget build(BuildContext context) {
    final isFocused = _focus.hasFocus;
    final valueStyle = _text(size: 15, weight: FontWeight.w500);
    final controller = widget.controller;
    final errorText = widget.errorText;
    final hasError = errorText != null;
    final ring = hasError ? AppBrandColors.accent : AppBrandColors.gold;
    final isRinged = isFocused || hasError;
    final leading = widget.leading;
    final trailing = widget.trailing;
    final isMultiline = (widget.maxLines ?? 2) > 1;

    final value = controller != null
        ? TextField(
            controller: controller,
            focusNode: _focus,
            autofocus: widget.autofocus,
            textCapitalization: widget.textCapitalization,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            style: valueStyle.copyWith(height: isMultiline ? 1.5 : null),
            cursorColor: AppBrandColors.plum,
            // Bare text: the box around it is the field. The app theme
            // fills inputs and outlines them (more so when focused), so
            // every border and the fill are turned off here, not just
            // left unset.
            decoration: InputDecoration(
              isCollapsed: true,
              filled: false,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintText: widget.hint,
              hintStyle: _text(size: 15, color: AppBrandColors.subtle),
            ),
          )
        // Nothing chosen yet: the hint, faint.
        : widget.value!.isEmpty && widget.hint != null
        ? Text(
            widget.hint!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _text(size: 15, color: AppBrandColors.subtle),
          )
        : Text(
            widget.value!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          );

    final field = GestureDetector(
      // The whole box, label included, focuses the field (or, showing a
      // value, does what a tap on it does).
      onTap: controller == null
          ? (widget.enabled ? widget.onTap : null)
          : _focus.requestFocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: isMultiline ? null : AppLabelField.height.r,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: isMultiline ? AppSpacing.ms : 0,
        ),
        decoration: BoxDecoration(
          color: AppBrandColors.fieldFill.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isRinged
                ? ring
                : AppBrandColors.plum.withValues(alpha: 0.12),
            width: isRinged ? 1.5 : 1,
          ),
          boxShadow: isRinged
              ? [
                  // The soft halo outside the ring.
                  BoxShadow(
                    color: ring.withValues(alpha: hasError ? 0.1 : 0.14),
                    spreadRadius: 5,
                  ),
                ]
              : AppShadows.field,
        ),
        child: Row(
          crossAxisAlignment: isMultiline
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[leading, SizedBox(width: AppSpacing.ms)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.label.isNotEmpty) ...[
                    Text(
                      widget.label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _text(
                        size: 10.5,
                        weight: FontWeight.w600,
                        color: AppBrandColors.subtle,
                        letterSpacing: 0.63,
                      ),
                    ),
                    SizedBox(height: isMultiline ? AppSpacing.xs : 2.h),
                  ],
                  value,
                ],
              ),
            ),
            if (trailing != null) ...[SizedBox(width: AppSpacing.ms), trailing],
          ],
        ),
      ),
    );

    if (!hasError) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        field,
        Padding(
          padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 0),
          child: Text(
            errorText,
            style: _text(size: 11.5, color: AppBrandColors.accent),
          ),
        ),
      ],
    );
  }
}
