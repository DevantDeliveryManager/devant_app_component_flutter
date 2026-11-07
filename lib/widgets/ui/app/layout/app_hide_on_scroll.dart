import 'package:flutter/material.dart';
import 'package:devant_components/theme/app_curves.dart';
import 'package:devant_components/theme/app_durations.dart';

/// Shows [header] above the scrollable [child], hiding it while the list
/// is scrolled down and bringing it back as soon as it's scrolled up, or
/// back to the top. For a search bar over a long list.
///
/// Listens to the scrolling inside [child] without taking it over, so the
/// list's own listeners, e.g. loading more, still hear it.
class AppHideOnScroll extends StatefulWidget {
  const AppHideOnScroll({super.key, required this.header, required this.child});

  final Widget header;
  final Widget child;

  @override
  State<AppHideOnScroll> createState() => _AppHideOnScrollState();
}

class _AppHideOnScrollState extends State<AppHideOnScroll> {
  bool _isShown = true;

  /// Scrolled this far in one direction before the header moves, so a
  /// little jitter doesn't flicker it.
  static const double _threshold = 8;

  double _travel = 0;

  bool _onScroll(ScrollUpdateNotification notification) {
    final metrics = notification.metrics;
    // Only the list itself, not a sideways row inside it.
    if (notification.depth != 0 || metrics.axis != Axis.vertical) {
      return false;
    }
    final delta = notification.scrollDelta ?? 0;
    if (metrics.pixels <= metrics.minScrollExtent) {
      _travel = 0;
      _show(true);
      return false;
    }
    // A change of direction starts the count again.
    if ((delta > 0) != (_travel > 0)) _travel = 0;
    _travel += delta;
    if (_travel > _threshold) _show(false);
    if (_travel < -_threshold) _show(true);
    return false;
  }

  void _show(bool shown) {
    if (shown != _isShown) setState(() => _isShown = shown);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRect(
          child: AnimatedAlign(
            duration: AppDurations.quick,
            curve: AppCurves.standard,
            alignment: Alignment.bottomCenter,
            heightFactor: _isShown ? 1 : 0,
            child: AnimatedOpacity(
              duration: AppDurations.quick,
              opacity: _isShown ? 1 : 0,
              child: widget.header,
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: _onScroll,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
