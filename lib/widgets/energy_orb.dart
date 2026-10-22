import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A softly breathing, slowly rotating energy orb drawn entirely on a canvas.
///
/// Layers, back to front: a twinkling starfield, a faint glow, the far
/// halves of the orbital rings and the wireframe cage (hidden behind the
/// sphere), the organic sphere with its depth shading, the near halves of
/// the cage and rings with their particles, and finally the highlights.
///
/// Every motion runs at a whole-number multiple of one animation cycle, so
/// the loop is seamless.
///
/// ```dart
/// const Center(child: EnergyOrb(size: 300))
/// ```
class EnergyOrb extends StatefulWidget {
  const EnergyOrb({
    super.key,
    this.size = 280,
    this.animationDuration = const Duration(seconds: 8),
    this.showParticles = true,
    this.showWireframe = true,
  });

  /// Width and height of the square the orb is painted into. The orbital
  /// rings reach close to its edges.
  final double size;

  /// Length of one full loop: one wireframe revolution, two breaths.
  final Duration animationDuration;

  /// Shows the particles on the rings and the starfield.
  final bool showParticles;
  final bool showWireframe;

  @override
  State<EnergyOrb> createState() => _EnergyOrbState();
}

class _EnergyOrbState extends State<EnergyOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.animationDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant EnergyOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
      _syncAnimation(restart: true);
    }
  }

  /// Honours the platform's "reduce motion" setting by holding a still frame.
  void _syncAnimation({bool restart = false}) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      _controller.stop();
    } else if (restart || !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => CustomPaint(
            painter: EnergyOrbPainter(
              progress: _controller.value,
              showParticles: widget.showParticles,
              showWireframe: widget.showWireframe,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tuning knobs for [EnergyOrb]. Factors are relative to the painted size
/// unless noted otherwise.
abstract final class EnergyOrbTuning {
  /// Sphere radius as a fraction of the orb's size.
  static const double orbRadiusFactor = 0.25;

  /// How much the sphere grows and shrinks while breathing (0.03 = ±3%).
  static const double pulseStrength = 0.03;

  /// How far the sphere's edge wobbles, as a fraction of its radius.
  static const double deformation = 0.035;

  /// Overall strength of the background glow and particle halos (0–1).
  static const double glowIntensity = 0.45;

  /// Peak opacity of the wireframe lines (0–1).
  static const double wireframeOpacity = 0.45;

  /// Size of the wireframe cage relative to the sphere. Above 1 it reaches
  /// past the sphere's edge.
  static const double wireframeScale = 1.3;

  /// Number of points in the wireframe mesh.
  static const int wireframePoints = 22;

  /// Each wireframe point connects to this many nearest neighbours.
  static const int wireframeNeighbours = 3;

  /// Number of background stars.
  static const int starCount = 40;

  /// Points used to trace the sphere's organic outline.
  static const int blobResolution = 72;
}

abstract final class _OrbColors {
  static const Color terracotta = Color(0xFFBD6B4B);
  static const Color ivory = Color(0xFFFFFCF7);
  static const Color darkTeal = Color(0xFF193A3D);
  static const Color lightTeal = Color(0xFF6F9795);

  // Sphere body: banded sand with a warm highlight, mottled with
  // see-through teal patches.
  static const Color orbCore = Color(0xFFF2D3A2);
  static const Color orbPeach = Color(0xFFDDB98C);
  static const Color orbApricot = Color(0xFFC4A27E);
  static const Color orbEdge = Color(0xFFA08A72);
  static const Color orbBand = Color(0xFFE8C694);
  static const Color orbTealPatch = Color(0xFF24474B);
  static const Color orbOrange = Color(0xFFD9925F);

  static const Color gold = Color(0xFFD9B27C);
  static const Color wireFront = Color(0xFFE6CFA0);
  static const Color wireBack = Color(0xFF10292C);
}

const double _tau = math.pi * 2;

/// An elliptical orbit. Sizes are fractions of the painted size.
class _Orbit {
  const _Orbit({
    required this.radiusX,
    required this.radiusY,
    required this.rotation,
    required this.wobble,
    required this.wobbleLaps,
    required this.phase,
    required this.color,
    required this.opacity,
    this.strokeFactor = 1,
  });

  final double radiusX;
  final double radiusY;

  /// Base tilt of the ellipse, in radians.
  final double rotation;

  /// How far the tilt sways either side of [rotation], in radians.
  final double wobble;

  /// Sways per animation cycle. Must be a whole number to loop seamlessly.
  final int wobbleLaps;
  final double phase;
  final Color color;
  final double opacity;

  /// Multiplies the base ring thickness.
  final double strokeFactor;
}

/// A particle travelling along one of the [_orbits].
class _Particle {
  const _Particle({
    required this.orbit,
    required this.phase,
    required this.laps,
    required this.color,
    required this.sizeFactor,
  });

  final int orbit;

  /// Starting angle on the ellipse, in radians.
  final double phase;

  /// Revolutions per animation cycle; negative runs the other way. Must be
  /// a whole number to loop seamlessly.
  final int laps;
  final Color color;

  /// Core radius as a fraction of the painted size.
  final double sizeFactor;
}

const List<_Orbit> _orbits = [
  // Large terracotta ring, almost a circle, framing everything.
  _Orbit(
    radiusX: 0.485,
    radiusY: 0.465,
    rotation: 0.05,
    wobble: 0.03,
    wobbleLaps: 1,
    phase: 0,
    color: _OrbColors.terracotta,
    opacity: 0.85,
    strokeFactor: 1.4,
  ),
  // Thin gold ellipse, tilted steeply (~-57°).
  _Orbit(
    radiusX: 0.46,
    radiusY: 0.22,
    rotation: -1,
    wobble: 0.05,
    wobbleLaps: 2,
    phase: 1.1,
    color: _OrbColors.gold,
    opacity: 0.6,
  ),
  // Thin gold ellipse, wide and gently tilted (~24°).
  _Orbit(
    radiusX: 0.44,
    radiusY: 0.17,
    rotation: 0.42,
    wobble: 0.05,
    wobbleLaps: 1,
    phase: 2.3,
    color: _OrbColors.gold,
    opacity: 0.5,
  ),
];

const List<_Particle> _particles = [
  _Particle(
    orbit: 0,
    phase: 0,
    laps: 1,
    color: _OrbColors.gold,
    sizeFactor: 0.012,
  ),
  _Particle(
    orbit: 0,
    phase: math.pi,
    laps: 1,
    color: _OrbColors.terracotta,
    sizeFactor: 0.010,
  ),
  _Particle(
    orbit: 1,
    phase: 1.2,
    laps: 2,
    color: _OrbColors.gold,
    sizeFactor: 0.013,
  ),
  _Particle(
    orbit: 1,
    phase: 4.2,
    laps: -1,
    color: _OrbColors.ivory,
    sizeFactor: 0.008,
  ),
  _Particle(
    orbit: 2,
    phase: 2.4,
    laps: -1,
    color: _OrbColors.gold,
    sizeFactor: 0.011,
  ),
];

/// A soft patch of colour riding on the sphere's surface.
class _SurfacePatch {
  const _SurfacePatch({
    required this.latitude,
    required this.longitude,
    required this.size,
    required this.aspect,
    required this.laps,
    required this.color,
    required this.alpha,
    this.latitudeSwing = 0.25,
    this.swingLaps = 1,
  });

  /// Starting position, in radians. Latitude 0 is the equator.
  final double latitude;
  final double longitude;

  /// Width as a fraction of the sphere's radius, and height relative to it.
  final double size;
  final double aspect;

  /// Trips round the sphere per animation cycle; negative flows the other
  /// way. Whole numbers keep the loop seamless.
  final int laps;
  final Color color;
  final double alpha;

  /// How far the patch drifts up and down, in radians, and how often.
  final double latitudeSwing;
  final int swingLaps;
}

/// Drawn in order, so later patches sit on top: warm tones first, then the
/// stronger teal over them. Teal flows one way, warm tones the other.
/// Negative latitude is the upper half of the sphere.
const List<_SurfacePatch> _surfacePatches = [
  _SurfacePatch(
    latitude: -0.45,
    longitude: 0.6,
    size: 0.9,
    aspect: 0.32,
    laps: -1,
    color: _OrbColors.orbBand,
    alpha: 0.85,
    latitudeSwing: 0.12,
  ),
  _SurfacePatch(
    latitude: -0.15,
    longitude: 3.1,
    size: 0.5,
    aspect: 0.7,
    laps: -1,
    color: _OrbColors.orbCore,
    alpha: 0.9,
    swingLaps: 2,
  ),
  // Orange rides the upper half.
  _SurfacePatch(
    latitude: -0.6,
    longitude: 3.6,
    size: 0.5,
    aspect: 0.5,
    laps: -2,
    color: _OrbColors.orbOrange,
    alpha: 0.75,
    latitudeSwing: 0.15,
    swingLaps: 2,
  ),
  _SurfacePatch(
    latitude: -0.5,
    longitude: 1.6,
    size: 0.45,
    aspect: 0.45,
    laps: -1,
    color: _OrbColors.orbOrange,
    alpha: 0.65,
    latitudeSwing: 0.15,
  ),
  // Teal, strong and on top.
  _SurfacePatch(
    latitude: 0.2,
    longitude: 0,
    size: 0.75,
    aspect: 0.6,
    laps: 1,
    color: _OrbColors.orbTealPatch,
    alpha: 1,
  ),
  _SurfacePatch(
    latitude: 0.55,
    longitude: 4.6,
    size: 0.6,
    aspect: 0.45,
    laps: 2,
    color: _OrbColors.orbTealPatch,
    alpha: 0.95,
  ),
  _SurfacePatch(
    latitude: 0.05,
    longitude: 2.2,
    size: 0.55,
    aspect: 0.5,
    laps: 1,
    color: _OrbColors.orbTealPatch,
    alpha: 0.95,
    latitudeSwing: 0.35,
  ),
  _SurfacePatch(
    latitude: -0.2,
    longitude: 5.3,
    size: 0.5,
    aspect: 0.6,
    laps: 1,
    color: _OrbColors.orbTealPatch,
    alpha: 0.9,
    latitudeSwing: 0.4,
    swingLaps: 2,
  ),
];

class _Vec3 {
  const _Vec3(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  double distanceTo(_Vec3 o) {
    final dx = x - o.x;
    final dy = y - o.y;
    final dz = z - o.z;
    return math.sqrt(dx * dx + dy * dy + dz * dz);
  }
}

/// The wireframe's points on a unit sphere and the edges between them.
/// Built once and shared by every painter.
class _WireMesh {
  const _WireMesh(this.points, this.edges);

  final List<_Vec3> points;
  final List<(int, int)> edges;

  static final _WireMesh instance = _build();

  static _WireMesh _build() {
    const n = EnergyOrbTuning.wireframePoints;
    // Fixed seed: the same irregular mesh on every run.
    final random = math.Random(11);
    final golden = math.pi * (3 - math.sqrt(5));

    // A Fibonacci sphere spreads points evenly; the jitter pulls some inward
    // so the cage looks faceted rather than perfectly round.
    final points = List<_Vec3>.generate(n, (i) {
      final y = 1 - (i + 0.5) / n * 2;
      final ring = math.sqrt(1 - y * y);
      final theta = golden * i;
      final jitter = 0.8 + random.nextDouble() * 0.2;
      return _Vec3(
        math.cos(theta) * ring * jitter,
        y * jitter,
        math.sin(theta) * ring * jitter,
      );
    });

    final edges = <(int, int)>{};
    for (var i = 0; i < n; i++) {
      final nearest = List<int>.generate(n, (j) => j)
        ..remove(i)
        ..sort(
          (a, b) => points[i]
              .distanceTo(points[a])
              .compareTo(points[i].distanceTo(points[b])),
        );
      for (final j in nearest.take(EnergyOrbTuning.wireframeNeighbours)) {
        edges.add(i < j ? (i, j) : (j, i));
      }
    }

    return _WireMesh(points, edges.toList(growable: false));
  }
}

/// A background star. Position and size are fractions of the painted size.
class _Star {
  const _Star(this.x, this.y, this.size, this.alpha, this.phase, this.laps);

  final double x;
  final double y;
  final double size;
  final double alpha;
  final double phase;

  /// Twinkles per animation cycle; whole number so the loop is seamless.
  final int laps;

  static final List<_Star> field = _build();

  static List<_Star> _build() {
    final random = math.Random(29);
    return List<_Star>.generate(
      EnergyOrbTuning.starCount,
      (_) => _Star(
        0.02 + random.nextDouble() * 0.96,
        0.02 + random.nextDouble() * 0.96,
        0.003 + random.nextDouble() * 0.005,
        0.35 + random.nextDouble() * 0.5,
        random.nextDouble() * _tau,
        1 + random.nextInt(3),
      ),
      growable: false,
    );
  }
}

class EnergyOrbPainter extends CustomPainter {
  const EnergyOrbPainter({
    required this.progress,
    this.showParticles = true,
    this.showWireframe = true,
  });

  /// Position in the animation loop, 0–1.
  final double progress;
  final bool showParticles;
  final bool showWireframe;

  @override
  void paint(Canvas canvas, Size size) {
    final extent = size.shortestSide;
    if (extent <= 0) return;

    final center = size.center(Offset.zero);
    final t = progress * _tau;
    final breath = 1 + EnergyOrbTuning.pulseStrength * math.sin(2 * t);
    final radius = extent * EnergyOrbTuning.orbRadiusFactor * breath;
    final blob = _buildBlobPath(center, radius, t);

    if (showParticles) _paintStars(canvas, size, extent, t);
    _paintBackgroundGlow(canvas, center, radius, t);
    _paintOrbits(canvas, center, extent, t, front: false);
    if (showWireframe) _paintWireframe(canvas, center, radius, t, front: false);
    _paintSphere(canvas, center, radius, blob, t);
    _paintDepthShading(canvas, center, radius, blob);
    if (showWireframe) _paintWireframe(canvas, center, radius, t, front: true);
    _paintOrbits(canvas, center, extent, t, front: true);
    _paintHighlights(canvas, center, radius, blob);
  }

  // ── Organic outline ─────────────────────────────────────────────────────

  /// Traces the sphere's edge with a few overlapping sine waves, then
  /// smooths it with quadratic curves through the midpoints.
  Path _buildBlobPath(Offset c, double r, double t) {
    const n = EnergyOrbTuning.blobResolution;
    final amount = r * EnergyOrbTuning.deformation;

    final points = List<Offset>.generate(n, (i) {
      final a = i / n * _tau;
      final rr = r +
          amount *
              (math.sin(a * 3 + t) +
                  0.6 * math.cos(a * 5 - 2 * t) +
                  0.4 * math.sin(a * 2 + 3 * t + 1.3));
      return Offset(c.dx + math.cos(a) * rr, c.dy + math.sin(a) * rr);
    });

    Offset mid(Offset a, Offset b) =>
        Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

    final start = mid(points.last, points.first);
    final path = Path()..moveTo(start.dx, start.dy);
    for (var i = 0; i < n; i++) {
      final p = points[i];
      final m = mid(p, points[(i + 1) % n]);
      path.quadraticBezierTo(p.dx, p.dy, m.dx, m.dy);
    }
    return path..close();
  }

  // ── Layers ──────────────────────────────────────────────────────────────

  void _paintStars(Canvas canvas, Size size, double extent, double t) {
    final dot = Paint();
    final origin = Offset(
      (size.width - extent) / 2,
      (size.height - extent) / 2,
    );
    for (final star in _Star.field) {
      final twinkle = 0.6 + 0.4 * math.sin(t * star.laps + star.phase);
      dot.color = _OrbColors.gold.withValues(alpha: star.alpha * twinkle);
      canvas.drawCircle(
        origin + Offset(star.x * extent, star.y * extent),
        star.size * extent,
        dot,
      );
    }
  }

  void _paintBackgroundGlow(Canvas canvas, Offset c, double r, double t) {
    final glow =
        EnergyOrbTuning.glowIntensity * (0.85 + 0.15 * math.sin(2 * t));

    final outerRadius = r * 2.1;
    canvas.drawCircle(
      c,
      outerRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _OrbColors.lightTeal.withValues(alpha: 0.35 * glow),
            _OrbColors.lightTeal.withValues(alpha: 0.1 * glow),
            _OrbColors.lightTeal.withValues(alpha: 0),
          ],
          stops: const [0.3, 0.65, 1],
        ).createShader(Rect.fromCircle(center: c, radius: outerRadius)),
    );

    final warmRadius = r * 1.4;
    canvas.drawCircle(
      c,
      warmRadius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            _OrbColors.orbBand.withValues(alpha: 0.3 * glow),
            _OrbColors.orbBand.withValues(alpha: 0),
          ],
          stops: const [0.6, 1],
        ).createShader(Rect.fromCircle(center: c, radius: warmRadius)),
    );
  }

  void _paintSphere(Canvas canvas, Offset c, double r, Path blob, double t) {
    // Base body: banded sand, warmest towards the centre.
    canvas.drawPath(
      blob,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.1, -0.05),
          radius: 0.55,
          colors: [
            _OrbColors.orbCore,
            _OrbColors.orbPeach,
            _OrbColors.orbApricot,
            _OrbColors.orbEdge,
          ],
          stops: [0, 0.4, 0.75, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.1)),
    );

    // Colour patches travelling over the sphere's surface. Teal and warm
    // patches flow in opposite directions at different speeds, so the
    // colours keep sliding through each other. Gradient fills rather than
    // blurs keep this cheap.
    canvas
      ..save()
      ..clipPath(blob);
    for (final patch in _surfacePatches) {
      _paintSurfacePatch(canvas, c, r, t, patch);
    }
    canvas.restore();
  }

  /// Places [patch] on a unit sphere, spins it, and draws it foreshortened:
  /// narrow and faint near the edge, fading out as it rolls round the back.
  void _paintSurfacePatch(
    Canvas canvas,
    Offset c,
    double r,
    double t,
    _SurfacePatch patch,
  ) {
    final lon = patch.longitude + t * patch.laps;
    final lat = patch.latitude +
        patch.latitudeSwing * math.sin(t * patch.swingLaps + patch.longitude);
    final cosLat = math.cos(lat);
    final x = cosLat * math.sin(lon);
    final y = math.sin(lat);
    final z = cosLat * math.cos(lon);

    // Fully visible facing the viewer, gone just past the edge.
    final visibility = ((z + 0.3) / 0.6).clamp(0.0, 1.0);
    if (visibility <= 0) return;

    final facing = math.max<double>(z, 0);
    _softOval(
      canvas,
      c + Offset(x, y) * (r * 0.9),
      r * patch.size * (0.45 + 0.55 * facing),
      r * patch.size * patch.aspect,
      patch.color,
      patch.alpha * visibility,
    );
  }

  /// A soft-edged ellipse of [color], fading out from its centre.
  void _softOval(
    Canvas canvas,
    Offset at,
    double radiusX,
    double radiusY,
    Color color,
    double alpha,
  ) {
    canvas
      ..save()
      ..translate(at.dx, at.dy)
      ..scale(1, radiusY / radiusX)
      ..drawCircle(
        Offset.zero,
        radiusX,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: alpha * 0.6),
              color.withValues(alpha: 0),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: radiusX),
          ),
      )
      ..restore();
  }

  /// Darkens the rim, weighted to the lower right, so the sphere reads as
  /// round.
  void _paintDepthShading(Canvas canvas, Offset c, double r, Path blob) {
    canvas.drawPath(
      blob,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.12, -0.15),
          radius: 0.55,
          colors: [
            _OrbColors.darkTeal.withValues(alpha: 0),
            _OrbColors.darkTeal.withValues(alpha: 0.15),
            _OrbColors.darkTeal.withValues(alpha: 0.4),
          ],
          stops: const [0.65, 0.88, 1],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.1)),
    );
  }

  /// Draws the edges of the wireframe cage that face away from the viewer
  /// (dark, behind the sphere) or towards it (light, over the sphere).
  void _paintWireframe(
    Canvas canvas,
    Offset c,
    double r,
    double t, {
    required bool front,
  }) {
    final mesh = _WireMesh.instance;
    final yaw = t;
    final pitch = 0.42 + 0.08 * math.sin(t);
    final cosYaw = math.cos(yaw);
    final sinYaw = math.sin(yaw);
    final cosPitch = math.cos(pitch);
    final sinPitch = math.sin(pitch);
    final scale = r * EnergyOrbTuning.wireframeScale;

    // Rotate each point in 3D, then project with a touch of perspective.
    final positions = List<Offset>.filled(mesh.points.length, Offset.zero);
    final depths = List<double>.filled(mesh.points.length, 0);
    for (var i = 0; i < mesh.points.length; i++) {
      final p = mesh.points[i];
      final x1 = p.x * cosYaw + p.z * sinYaw;
      final z1 = -p.x * sinYaw + p.z * cosYaw;
      final y1 = p.y * cosPitch - z1 * sinPitch;
      final z2 = p.y * sinPitch + z1 * cosPitch;
      final perspective = 1 + z2 * 0.1;
      positions[i] = c + Offset(x1, y1) * (scale * perspective);
      depths[i] = (z2 + 1) / 2;
    }

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.6, r * 0.008)
      ..strokeCap = StrokeCap.round;
    for (final (a, b) in mesh.edges) {
      final depth = (depths[a] + depths[b]) / 2;
      if ((depth >= 0.5) != front) continue;
      line.color = front
          ? _OrbColors.wireFront.withValues(
              alpha: EnergyOrbTuning.wireframeOpacity * (0.3 + 0.7 * depth),
            )
          : _OrbColors.wireBack.withValues(
              alpha: EnergyOrbTuning.wireframeOpacity * 1.4 * (1 - depth),
            );
      canvas.drawLine(positions[a], positions[b], line);
    }

    if (!front) return;
    final dot = Paint();
    for (var i = 0; i < positions.length; i++) {
      final depth = depths[i];
      if (depth < 0.5) continue;
      dot.color = _OrbColors.wireFront.withValues(
        alpha: (EnergyOrbTuning.wireframeOpacity * 1.5 * depth).clamp(0, 1),
      );
      canvas.drawCircle(positions[i], r * 0.014 * (0.5 + depth), dot);
    }
  }

  /// Draws either the far side of every orbit (dim, before the sphere so it
  /// is hidden behind it) or the near side (bright, over the sphere).
  /// Particles are split the same way.
  void _paintOrbits(
    Canvas canvas,
    Offset c,
    double extent,
    double t, {
    required bool front,
  }) {
    final ring = Paint()..style = PaintingStyle.stroke;

    for (var i = 0; i < _orbits.length; i++) {
      final orbit = _orbits[i];
      final rx = extent * orbit.radiusX;
      final ry = extent * orbit.radiusY;
      final tilt = orbit.rotation +
          orbit.wobble * math.sin(t * orbit.wobbleLaps + orbit.phase);

      canvas
        ..save()
        ..translate(c.dx, c.dy)
        ..rotate(tilt);

      ring.strokeWidth = math.max(0.8, extent * 0.003 * orbit.strokeFactor);
      final rect =
          Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2);
      // In the orbit's own frame the lower half (sin θ > 0) faces the viewer.
      if (front) {
        ring.color = orbit.color.withValues(alpha: orbit.opacity);
        canvas.drawArc(rect, 0, math.pi, false, ring);
      } else {
        ring.color = orbit.color.withValues(alpha: orbit.opacity * 0.55);
        canvas.drawOval(rect, ring);
      }

      if (showParticles) {
        for (final particle in _particles) {
          if (particle.orbit != i) continue;
          _paintParticle(canvas, particle, rx, ry, extent, t, front: front);
        }
      }

      canvas.restore();
    }
  }

  void _paintParticle(
    Canvas canvas,
    _Particle particle,
    double rx,
    double ry,
    double extent,
    double t, {
    required bool front,
  }) {
    final theta = particle.phase + t * particle.laps;
    final sinTheta = math.sin(theta);
    if ((sinTheta >= 0) != front) return;

    final depth = (sinTheta + 1) / 2;
    final position = Offset(math.cos(theta) * rx, sinTheta * ry);
    final radius = extent * particle.sizeFactor * (0.55 + 0.65 * depth);
    final opacity = 0.35 + 0.65 * depth;

    canvas
      ..drawCircle(
        position,
        radius * 2.6,
        Paint()
          ..color = particle.color.withValues(
            alpha: 0.7 * opacity * EnergyOrbTuning.glowIntensity,
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.6),
      )
      ..drawCircle(
        position,
        radius,
        Paint()..color = particle.color.withValues(alpha: opacity),
      )
      ..drawCircle(
        position,
        radius * 0.45,
        Paint()..color = _OrbColors.ivory.withValues(alpha: opacity),
      );
  }

  void _paintHighlights(Canvas canvas, Offset c, double r, Path blob) {
    // Specular sheen, upper left.
    canvas
      ..save()
      ..translate(c.dx - r * 0.34, c.dy - r * 0.42)
      ..rotate(-0.6);
    final sheen =
        Rect.fromCenter(center: Offset.zero, width: r * 0.55, height: r * 0.28);
    canvas
      ..drawOval(
        sheen,
        Paint()
          ..shader = RadialGradient(
            colors: [
              _OrbColors.ivory.withValues(alpha: 0.35),
              _OrbColors.ivory.withValues(alpha: 0),
            ],
          ).createShader(sheen),
      )
      ..restore();

    // Faint rim light along the lower right edge.
    canvas.drawPath(
      blob,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.03
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.02)
        ..shader = LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            _OrbColors.orbBand.withValues(alpha: 0.5),
            _OrbColors.orbBand.withValues(alpha: 0),
          ],
          stops: const [0, 0.45],
        ).createShader(blob.getBounds()),
    );
  }

  @override
  bool shouldRepaint(covariant EnergyOrbPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showParticles != showParticles ||
        oldDelegate.showWireframe != showWireframe;
  }
}
