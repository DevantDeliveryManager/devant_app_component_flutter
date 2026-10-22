import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A glossy terracotta sphere floating over stacked lotus disks.
///
/// Each disk is a flat ring of outlined leaf petals seen in perspective.
/// The disks turn in alternating directions (clockwise, anticlockwise,
/// clockwise…) while the sphere bobs gently up and down.
///
/// Paint it on a light, warm background.
///
/// ```dart
/// const Center(child: LotusOrb(size: 320))
/// ```
class LotusOrb extends StatefulWidget {
  const LotusOrb({
    super.key,
    this.size = 320,
    this.rotationDuration = const Duration(seconds: 40),
    this.floatDuration = const Duration(milliseconds: 3600),
    this.showSphere = true,
  });

  /// False draws only the turning disks, e.g. as a faint backdrop.
  final bool showSphere;

  /// Width of the painting. Its height is [LotusOrbTuning.heightFactor]
  /// times this.
  final double size;

  /// Time for the disks to complete one full turn.
  final Duration rotationDuration;

  /// Time for one full up-and-down float of the sphere.
  final Duration floatDuration;

  @override
  State<LotusOrb> createState() => _LotusOrbState();
}

class _LotusOrbState extends State<LotusOrb> with TickerProviderStateMixin {
  late final AnimationController _rotation = AnimationController(
    vsync: this,
    duration: widget.rotationDuration,
  );
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: widget.floatDuration,
  );
  late final Listenable _ticks = Listenable.merge([_rotation, _float]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant LotusOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    var changed = false;
    if (oldWidget.rotationDuration != widget.rotationDuration) {
      _rotation.duration = widget.rotationDuration;
      changed = true;
    }
    if (oldWidget.floatDuration != widget.floatDuration) {
      _float.duration = widget.floatDuration;
      changed = true;
    }
    if (changed) _syncAnimation(restart: true);
  }

  /// Honours the platform's "reduce motion" setting by holding a still frame.
  void _syncAnimation({bool restart = false}) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    for (final controller in [_rotation, _float]) {
      if (reduceMotion) {
        controller.stop();
      } else if (restart || !controller.isAnimating) {
        controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _rotation.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size * LotusOrbTuning.heightFactor,
        child: AnimatedBuilder(
          animation: _ticks,
          builder: (context, child) => CustomPaint(
            painter: LotusOrbPainter(
              rotation: _rotation.value,
              float: _float.value,
              showSphere: widget.showSphere,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tuning knobs for [LotusOrb]. Lengths are fractions of the painting's
/// width.
abstract final class LotusOrbTuning {
  /// Painting height relative to its width.
  static const double heightFactor = 0.90;

  /// How flat the disks look: their height divided by their width.
  static const double tilt = 0.60;

  /// Sphere radius.
  // static const double sphereRadius = 0.13;

  // /// Sphere centre's resting height, measured from the painting's centre
  // /// (negative is up).
  // static const double sphereRestY = -0.06;

  static const double sphereRestY = -0.10;
  static const double sphereRadius = 0.14;

  /// How far the sphere floats up and down either side of its rest.
  static const double floatAmplitude = 0.02;

  /// Strength of the soft glow around the sphere (0–1).
  static const double glowIntensity = 0.6;

  /// Thickness of petal and ring outlines.
  static const double strokeWidth = 0.0042;
}

abstract final class _LotusColors {
  static const Color gold = Color(0xFFD9B27C);
  static const Color teal = Color(0xFF4E6E70);
  static const Color terracotta = Color(0xFFD27A5A);
  static const Color slate = Color(0xFF8FA3A2);

  static const Color sphereLight = Color(0xFFF7C27A);
  static const Color sphereMid = Color(0xFFE39A5B);
  static const Color sphereDeep = Color(0xFFC9683F);
  static const Color sphereEdge = Color(0xFF9E4A33);

  static const Color glow = Color(0xFFF6D9A8);
  static const Color shadow = Color(0xFF8C5A3C);
}

const double _tau = math.pi * 2;

/// One ring of identical petals on a disk. Radii are fractions of the
/// disk's radius.
class _PetalRow {
  const _PetalRow({
    required this.count,
    required this.inner,
    required this.outer,
    required this.width,
    required this.color,
    this.offset = 0,
    this.opacity = 0.85,
  });

  final int count;

  /// Where each petal starts and ends, from the disk's centre outwards.
  final double inner;
  final double outer;

  /// Petal width as a fraction of the gap between neighbours.
  final double width;
  final Color color;

  /// Starting angle as a fraction of the gap between neighbours, so a row
  /// can sit between another row's petals.
  final double offset;
  final double opacity;
}

/// A flat disk of petals. Positions and radii are fractions of the
/// painting's width.
class _Disk {
  const _Disk({
    required this.centerY,
    required this.radius,
    required this.direction,
    required this.ringColor,
    required this.rows,
    this.ringOpacity = 0.4,
  });

  /// Height of the disk's centre from the painting's centre (negative is
  /// up).
  final double centerY;
  final double radius;

  /// 1 turns clockwise, -1 anticlockwise.
  final int direction;
  final Color ringColor;
  final double ringOpacity;
  final List<_PetalRow> rows;
}

/// Drawn largest and lowest first, so higher disks sit on top. Directions
/// alternate.
// const List<_Disk> _disks = [
//   // Outer disk, lowest: terracotta leaves with small gold ones beyond.
//    _Disk(
//     centerY: 0.20,
//     radius: 0.53,
//     direction: -1,
//     ringColor: _LotusColors.slate,
//     ringOpacity: 0.25,
//     rows: [
//       _PetalRow(
//         count: 22,
//         inner: 0.68,
//         outer: 0.92,
//         width: 0.38,
//         color: _LotusColors.teal,
//         opacity: 0.65,
//       ),
//       _PetalRow(
//         count: 22,
//         inner: 0.94,
//         outer: 1.05,
//         width: 0.28,
//         color: _LotusColors.gold,
//         offset: 0.5,
//         opacity: 0.6,
//       ),
//     ],
//   ),

//   // Existing outer disk
//   _Disk(
//     centerY: 0.12,
//     radius: 0.47,
//     direction: 1,
//     ringColor: _LotusColors.terracotta,
//     ringOpacity: 0.3,
//     rows: [
//       _PetalRow(
//         count: 18,
//         inner: 0.6,
//         outer: 0.86,
//         width: 0.42,
//         color: _LotusColors.terracotta,
//       ),
//       _PetalRow(
//         count: 18,
//         inner: 0.92,
//         outer: 1.04,
//         width: 0.3,
//         color: _LotusColors.gold,
//         offset: 0.5,
//         opacity: 0.75,
//       ),
//     ],
//   ),

//   _Disk(
//     centerY: 0.12,
//     radius: 0.47,
//     direction: 1,
//     ringColor: _LotusColors.terracotta,
//     ringOpacity: 0.3,
//     rows: [
//       _PetalRow(
//         count: 18,
//         inner: 0.6,
//         outer: 0.86,
//         width: 0.42,
//         color: _LotusColors.terracotta,
//       ),
//       _PetalRow(
//         count: 18,
//         inner: 0.92,
//         outer: 1.04,
//         width: 0.3,
//         color: _LotusColors.gold,
//         offset: 0.5,
//         opacity: 0.75,
//       ),
//     ],
//   ),
//   // Middle disk: teal leaves with gold ones tucked between.
//   _Disk(
//     centerY: -0.03,
//     radius: 0.31,
//     direction: -1,
//     ringColor: _LotusColors.slate,
//     ringOpacity: 0.45,
//     rows: [
//       _PetalRow(
//         count: 14,
//         inner: 0.52,
//         outer: 0.86,
//         width: 0.45,
//         color: _LotusColors.teal,
//       ),
//       _PetalRow(
//         count: 14,
//         inner: 0.72,
//         outer: 0.95,
//         width: 0.25,
//         color: _LotusColors.gold,
//         offset: 0.5,
//         opacity: 0.7,
//       ),
//     ],
//   ),
//   // Top disk, highest and smallest: gold leaves.
//   _Disk(
//     centerY: -0.18,
//     radius: 0.19,
//     direction: 1,
//     ringColor: _LotusColors.gold,
//     ringOpacity: 0.45,
//     rows: [
//       _PetalRow(
//         count: 12,
//         inner: 0.5,
//         outer: 0.92,
//         width: 0.42,
//         color: _LotusColors.gold,
//         opacity: 0.8,
//       ),
//     ],
//   ),
// ];

const List<_Disk> _disks = [
  // 1. Outermost disk
  // Mostly outside the canvas, only edge petals should be visible.
  _Disk(
  centerY: 0,
  radius: 0.95,
  direction: -1,
  ringColor: _LotusColors.gold,
  ringOpacity: 0.10,
  rows: [
    _PetalRow(
      count: 24,
      inner: 0.88,
      outer: 0.98,
      width: 0.18,
      color: _LotusColors.gold,
      opacity: 0.58,
    ),
  ],
),

  // 2. Visible outer disk
  _Disk(
    centerY: 0.13,
    radius: 0.54,
    direction: 1,
    ringColor: _LotusColors.terracotta,
    ringOpacity: 0.26,
    rows: [
      _PetalRow(
        count: 18,
        inner: 0.70,
        outer: 0.98,
        width: 0.42,
        color: _LotusColors.terracotta,
        opacity: 0.80,
      ),
    ],
  ),

  // 3. Middle disk
  _Disk(
    centerY: -0.03,
    radius: 0.35,
    direction: -1,
    ringColor: _LotusColors.slate,
    ringOpacity: 0.38,
    rows: [
      _PetalRow(
        count: 14,
        inner: 0.62,
        outer: 0.95,
        width: 0.44,
        color: _LotusColors.teal,
        opacity: 0.82,
      ),
    ],
  ),

  // 4. Top disk
  _Disk(
    centerY: -0.23,
    radius: 0.23,
    direction: 1,
    ringColor: _LotusColors.gold,
    ringOpacity: 0.42,
    rows: [
      _PetalRow(
        count: 11,
        inner: 0.60,
        outer: 0.98,
        width: 0.40,
        color: _LotusColors.gold,
        opacity: 0.78,
      ),
    ],
  ),
];

class LotusOrbPainter extends CustomPainter {
  const LotusOrbPainter({
    required this.rotation,
    required this.float,
    this.showSphere = true,
  });

  /// Position in the disks' turn, 0–1.
  final double rotation;

  /// Position in the sphere's float, 0–1.
  final double float;

  /// Whether to draw the sphere, its glow and its shadow.
  final bool showSphere;

  @override
  void paint(Canvas canvas, Size size) {
    // Fit the painting's aspect ratio inside whatever space we were given.
    final width =
        math.min(size.width, size.height / LotusOrbTuning.heightFactor);
    if (width <= 0) return;
    final center = size.center(Offset.zero);

    // Sine easing, so the float slows at the top and bottom.
    final lift = math.sin(float * _tau);
    final sphereCenter = center +
        Offset(
          0,
          width *
              (LotusOrbTuning.sphereRestY -
                  LotusOrbTuning.floatAmplitude * lift),
        );
    final sphereRadius = width * LotusOrbTuning.sphereRadius;

    if (showSphere) _paintGlow(canvas, sphereCenter, sphereRadius, lift);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, width * LotusOrbTuning.strokeWidth)
      ..strokeJoin = StrokeJoin.round;
    for (final disk in _disks) {
      _paintDisk(canvas, center, width, disk, stroke);
    }

    if (!showSphere) return;
    _paintShadow(canvas, center, width, sphereRadius, lift);
    _paintSphere(canvas, sphereCenter, sphereRadius);
  }

  // ── Disks ───────────────────────────────────────────────────────────────

  void _paintDisk(
    Canvas canvas,
    Offset center,
    double width,
    _Disk disk,
    Paint stroke,
  ) {
    final c = center + Offset(0, width * disk.centerY);
    final radius = width * disk.radius;
    const tilt = LotusOrbTuning.tilt;

    stroke.color = disk.ringColor.withValues(alpha: disk.ringOpacity);
    canvas.drawOval(
      Rect.fromCenter(
        center: c,
        width: radius * 2,
        height: radius * 2 * tilt,
      ),
      stroke,
    );

    final turn = rotation * _tau * disk.direction;
    for (final row in disk.rows) {
      final gap = _tau / row.count;
      for (var i = 0; i < row.count; i++) {
        final angle = turn + (i + row.offset) * gap;
        // Petals at the back (top of the oval) are a little fainter.
        final nearness = (math.sin(angle) + 1) / 2;
        stroke.color = row.color.withValues(
          alpha: row.opacity * (0.55 + 0.45 * nearness),
        );
        canvas.drawPath(
          _petalPath(c, radius, angle, gap, row),
          stroke,
        );
      }
    }
  }

  /// A pointed leaf lying flat on the disk, pointing outwards along
  /// [angle]. Built in the disk's plane, then squashed into perspective;
  /// the squash is linear, so the curves stay exact.
  Path _petalPath(
    Offset c,
    double radius,
    double angle,
    double gap,
    _PetalRow row,
  ) {
    const tilt = LotusOrbTuning.tilt;
    final dx = math.cos(angle);
    final dy = math.sin(angle);

    final inner = radius * row.inner;
    final outer = radius * row.outer;
    final middle = (inner + outer) / 2;
    // A quadratic curve reaches half way to its control point, so double
    // the half-width to get the intended width.
    final bulge = middle * gap * row.width;

    Offset project(double along, double across) => Offset(
          c.dx + dx * along - dy * across,
          c.dy + (dy * along + dx * across) * tilt,
        );

    final base = project(inner, 0);
    final tip = project(outer, 0);
    final left = project(middle, bulge);
    final right = project(middle, -bulge);

    return Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(left.dx, left.dy, tip.dx, tip.dy)
      ..quadraticBezierTo(right.dx, right.dy, base.dx, base.dy)
      ..close();
  }

  // ── Sphere ──────────────────────────────────────────────────────────────

  void _paintGlow(Canvas canvas, Offset c, double r, double lift) {
    final glowRadius = r * 3;
    final strength = LotusOrbTuning.glowIntensity * (0.9 + 0.1 * lift);
    canvas.drawCircle(
      c,
      glowRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _LotusColors.glow.withValues(alpha: 0.7 * strength),
            _LotusColors.glow.withValues(alpha: 0.25 * strength),
            _LotusColors.glow.withValues(alpha: 0),
          ],
          stops: const [0.25, 0.55, 1],
        ).createShader(Rect.fromCircle(center: c, radius: glowRadius)),
    );
  }

  /// A soft shadow on the middle disk. It shrinks and fades as the sphere
  /// rises.
  void _paintShadow(
    Canvas canvas,
    Offset center,
    double width,
    double r,
    double lift,
  ) {
    final c = center + Offset(0, width * (_disks[1].centerY + 0.015));
    final spread = r * (1.15 - 0.1 * lift);
    final rect = Rect.fromCenter(
      center: c,
      width: spread * 2,
      height: spread * 2 * LotusOrbTuning.tilt,
    );
    canvas.drawOval(
      rect,
      Paint()
        ..color = _LotusColors.shadow.withValues(alpha: 0.22 - 0.06 * lift)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.25),
    );
  }

  void _paintSphere(Canvas canvas, Offset c, double r) {
    final bounds = Rect.fromCircle(center: c, radius: r);

    // Body, lit from the upper left.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.45),
          radius: 1.05,
          colors: [
            _LotusColors.sphereLight,
            _LotusColors.sphereMid,
            _LotusColors.sphereDeep,
            _LotusColors.sphereEdge,
          ],
          stops: [0, 0.35, 0.75, 1],
        ).createShader(bounds),
    );

    // Warm bounce light along the lower edge.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _LotusColors.sphereLight.withValues(alpha: 0),
            _LotusColors.sphereLight.withValues(alpha: 0),
            _LotusColors.sphereLight.withValues(alpha: 0.25),
          ],
          stops: const [0, 0.75, 1],
        ).createShader(bounds),
    );

    // Specular highlight.
    final highlight = c + Offset(-r * 0.38, -r * 0.45);
    final highlightRadius = r * 0.45;
    canvas.drawCircle(
      highlight,
      highlightRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.45),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(
          Rect.fromCircle(center: highlight, radius: highlightRadius),
        ),
    );
  }

  @override
  bool shouldRepaint(covariant LotusOrbPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.float != float ||
        oldDelegate.showSphere != showSphere;
  }
}
