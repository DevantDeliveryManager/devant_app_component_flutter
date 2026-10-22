import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/theme_constants.dart';



Widget aiPill({VoidCallback? onTap, bool isLoading = false, required List<String> loadingLabels}) {
  // Align loosens the parent's tight (stretch) constraints so the pill can
  // size itself instead of filling the column's width.
  return Align(
    alignment: Alignment.centerLeft,
    widthFactor: 1,
    child: _AiPill(onTap: onTap, isLoading: isLoading, loadingLabels: loadingLabels),
  );
}

class _AiPill extends StatefulWidget {
  _AiPill({required this.onTap, required this.isLoading, required this.loadingLabels});

  final VoidCallback? onTap;
  final bool isLoading;
  final List<String> loadingLabels;

  @override
  State<_AiPill> createState() => _AiPillState();
}

class _AiPillState extends State<_AiPill> {
  static const _labelInterval = Duration(milliseconds: 1600);

  Timer? _timer;
  int _step = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isLoading) _startCycling();
  }

  @override
  void didUpdateWidget(_AiPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading == oldWidget.isLoading) return;
    widget.isLoading ? _startCycling() : _stopCycling();
  }

  void _startCycling() {
    _step = 1;
    _timer = Timer.periodic(_labelInterval, (_) {
      // Stays on the last label until loading ends.
      if (_step < widget.loadingLabels.length - 1) setState(() => _step++);
    });
  }

  void _stopCycling() {
    _timer?.cancel();
    _step = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Index 0 is the resting name.
  

  @override
  Widget build(BuildContext context) {
    final label = widget.loadingLabels[_step];

    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedSize(
        duration: AppDurations.fast,
        curve: Curves.easeOut,
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(
            AppSpacing.xs + 1.r,
            AppSpacing.xs + 1.r,
            AppSpacing.ms,
            AppSpacing.xs + 1.r,
          ),
          decoration: BoxDecoration(
            color: AppBrandColors.socialFill,
            borderRadius: AppBorders.full,
            border:
                Border.all(color: AppBrandColors.cta.withValues(alpha: 0.35)),
            boxShadow: AppShadows.card,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Orb(isLoading: widget.isLoading),
              SizedBox(width: AppSpacing.sm - 1.r),
              AnimatedSwitcher(
                duration: AppDurations.fast,
                child: Text(
                  label,
                  key: ValueKey(label),
                  style: TextStyle(
                    color: AppBrandColors.plum,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ).copyWith(fontSize: 12.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.r,
      height: 20.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppBrandColors.ctaLight, AppBrandColors.cta],
        ),
        boxShadow: [
          BoxShadow(
            color: AppBrandColors.cta.withValues(alpha: 0.55),
            blurRadius: AppSpacing.xs + 2.r,
          ),
        ],
      ),
      child: isLoading
          ? Padding(
              padding: EdgeInsets.all(4.r),
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppBrandColors.onCta,
              ),
            )
          : Icon(
              Icons.auto_awesome,
              size: 11.r,
              color: AppBrandColors.onCta,
            ),
    );
  }
}
