import 'package:devant_components/theme/theme_constants.dart';
import 'package:flutter/cupertino.dart' hide RefreshCallback;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_platform.dart';
import '../extensions/context_extension.dart';


/// A single dropdown menu item for [AppDropdown].
class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final String label;
  final bool enabled;
}

/// Adaptive dropdown / picker for selecting a single value.

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.enabled = true,
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.platform,
  });

  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final String? hint;
  final bool enabled;

  /// Whether the dropdown is busy. While true it is faded and cannot be opened.
  final bool isLoading;

  /// Optional icon/widget shown before the selected text.
  final Widget? leading;

  /// Optional widget shown at the end of the tile. Replaces the default
  /// animated chevron.
  final Widget? trailing;
  final AppPlatformStyle? platform;

  String _labelFor(T? v) {
    if (v == null) return hint ?? 'Select';
    return items
        .firstWhere(
          (i) => i.value == v,
          orElse: () => AppDropdownItem(value: v, label: hint ?? 'Select'),
        )
        .label;
  }

  Future<void> _showCupertinoPicker(BuildContext context) async {
    final cs = context.colors;
    final initialIndex = items.indexWhere((i) => i.value == value);
    var selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        return Container(
          height: 280.h,
          color: cs.surface,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  border: Border(bottom: BorderSide(color: cs.outlineVariant)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel',
                          style: TextStyle(color: cs.onSurfaceVariant)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        onChanged(items[selectedIndex].value);
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 36.h,
                  onSelectedItemChanged: (i) => selectedIndex = i,
                  children: [
                    for (final item in items)
                      Center(
                        child: Text(
                          item.label,
                          style: TextStyle(color: cs.onSurface),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final useCupertino = platform != null
        ? platform == AppPlatformStyle.cupertino
        : context.isCupertinoUi;
    final cs = context.colors;
    final tt = context.textTheme;

    if (useCupertino) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                label!,
                style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
            ),
          GestureDetector(
            onTap: enabled && !isLoading
                ? () => _showCupertinoPicker(context)
                : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.ms,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: AppBorders.input,
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                      child: leading!,
                    ),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      _labelFor(value),
                      style: tt.bodyLarge?.copyWith(
                        color:
                            value == null ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                    ),
                  ),
                  trailing ??
                      Icon(
                        CupertinoIcons.chevron_down,
                        size: 16.sp,
                        color: cs.onSurfaceVariant,
                      ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              label!,
              style: tt.labelLarge?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        _MaterialDropdownTile<T>(
          items: items,
          value: value,
          text: _labelFor(value),
          enabled: enabled,
          isLoading: isLoading,
          leading: leading,
          trailing: trailing,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Compact, animated tile that opens a menu anchored right under it.
class _MaterialDropdownTile<T> extends StatefulWidget {
  const _MaterialDropdownTile({
    required this.items,
    required this.value,
    required this.text,
    required this.enabled,
    required this.isLoading,
    required this.onChanged,
    this.leading,
    this.trailing,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final String text;
  final bool enabled;
  final bool isLoading;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<T?> onChanged;

  @override
  State<_MaterialDropdownTile<T>> createState() =>
      _MaterialDropdownTileState<T>();
}

class _MaterialDropdownTileState<T> extends State<_MaterialDropdownTile<T>> {
  bool _open = false;

  Future<void> _openMenu() async {
    final cs = Theme.of(context).colorScheme;
    final box = context.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final origin =
        box.localToGlobal(Offset(0, box.size.height + 4), ancestor: overlay);

    setState(() => _open = true);
    final picked = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(origin.dx, origin.dy, box.size.width, 0),
        Offset.zero & overlay.size,
      ),
      constraints: BoxConstraints.tightFor(width: box.size.width),
      color: cs.surface,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: cs.outlineVariant),
      ),
      items: [
        for (final item in widget.items)
          PopupMenuItem<T>(
            value: item.value,
            enabled: item.enabled,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: item.value == widget.value
                          ? cs.primary
                          : cs.onSurface,
                      fontWeight: item.value == widget.value
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.value == widget.value)
                  Icon(Icons.check, size: 18, color: cs.primary),
              ],
            ),
          ),
      ],
    );
    if (mounted) setState(() => _open = false);
    if (picked != null) widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final hasValue = widget.value != null;

    return Semantics(
      button: true,
      enabled: widget.enabled && !widget.isLoading,
      expanded: _open,
      child: Opacity(
        opacity: widget.enabled && !widget.isLoading ? 1 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : cs.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _open ? cs.primary : cs.outlineVariant,
              width: _open ? 1.5 : 1,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: widget.enabled && !widget.isLoading ? _openMenu : null,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      if (widget.leading != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            size: 20,
                            color: _open ? cs.primary : cs.onSurfaceVariant,
                          ),
                          child: widget.leading!,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: (tt.bodyMedium ?? const TextStyle()).copyWith(
                            color: hasValue
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                          child: Text(
                            widget.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      widget.trailing ??
                          AnimatedRotation(
                            turns: _open ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 22,
                              color:
                                  _open ? cs.primary : cs.onSurfaceVariant,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
