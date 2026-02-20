import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stacker_news/colors.dart';

/// A single line segment of the bolt.
class _BoltSegment {
  final Offset start;
  final Offset end;

  const _BoltSegment(this.start, this.end);
}

/// All pre-computed segments (trunk + branches) for one bolt.
class _BoltData {
  final List<_BoltSegment> segments;

  const _BoltData(this.segments);
}

// ---------------------------------------------------------------------------
// Bolt generation — port of the JS Bolt constructor + draw()
// ---------------------------------------------------------------------------

double _randInRange(Random rng, double min, double max) {
  return rng.nextDouble() * (max - min) + min;
}

/// Recursively generates bolt segments starting from [start],
/// walking at [angle] degrees, with random jitter [spread].
List<_BoltSegment> _generateSegments({
  required Random rng,
  required Offset start,
  required double length,
  required double angle,
  required double speed,
  required double spread,
  required int branchChance,
  required int maxBranches,
  bool isChild = false,
}) {
  final segments = <_BoltSegment>[];
  var current = start;
  var lastAngle = angle;
  var childCount = 0;

  while (true) {
    final angleChange = _randInRange(rng, 1, spread);
    lastAngle += lastAngle > angle ? -angleChange : angleChange;
    final radians = lastAngle * pi / 180;

    final next = Offset(
      current.dx + cos(radians) * speed,
      current.dy + sin(radians) * speed,
    );

    segments.add(_BoltSegment(current, next));

    // Distance from start
    final d = (next - start).distance;

    // Maybe spawn a branch
    if (rng.nextInt(100) < branchChance && childCount < maxBranches) {
      childCount++;
      final branchAngle = lastAngle + _randInRange(rng, 350 - spread, 370 + spread);
      segments.addAll(
        _generateSegments(
          rng: rng,
          start: next,
          length: d * 0.8,
          angle: branchAngle,
          speed: speed - 2,
          spread: spread - 2,
          branchChance: branchChance,
          maxBranches: maxBranches,
          isChild: true,
        ),
      );
    }

    current = next;

    if (d >= length) break;
  }

  return segments;
}

_BoltData _generateBolt(Size size) {
  final rng = Random();

  // Start from a random horizontal position in the middle 50%, at the top
  final startX = rng.nextDouble() * (size.width * 0.5) + (size.width * 0.25);
  final start = Offset(startX, 0);

  final segments = _generateSegments(
    rng: rng,
    start: start,
    length: size.height,
    angle: 90, // pointing downward
    speed: 100,
    spread: 30,
    branchChance: 20,
    maxBranches: 10,
  );

  return _BoltData(segments);
}

class _LightningPainter extends CustomPainter {
  final List<_BoltSegment> segments;
  final double progress; // 0..1, how many segments to draw
  final double opacity;

  _LightningPainter({
    required this.segments,
    required this.progress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (segments.isEmpty || opacity <= 0) return;

    final visibleCount = (segments.length * progress).ceil();

    // Glow paint (outer)
    final glowPaint = Paint()
      ..color = SNColors.light.withValues(alpha: opacity * 0.6)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Core paint (inner bright line)
    final corePaint = Paint()
      ..color = SNColors.primary.withValues(alpha: opacity)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < visibleCount && i < segments.length; i++) {
      final seg = segments[i];
      canvas.drawLine(seg.start, seg.end, glowPaint);
      canvas.drawLine(seg.start, seg.end, corePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LightningPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.opacity != opacity;
  }
}

/// A full-screen lightning bolt overlay that draws itself progressively
/// and then fades out.
///
/// Usage:
/// ```dart
/// LightningBolt(onDone: () => provider.unstrike(id))
/// ```
class LightningBolt extends StatefulWidget {
  final VoidCallback? onDone;

  const LightningBolt({super.key, this.onDone});

  @override
  State<LightningBolt> createState() => _LightningBoltState();
}

class _LightningBoltState extends State<LightningBolt> with TickerProviderStateMixin {
  _BoltData? _bolt;

  late AnimationController _drawController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    // Phase 1: draw (progressive reveal)
    _drawController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Phase 2: fade out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 777),
      value: 1.0, // start fully opaque
    );

    // When drawing finishes → start fading
    _drawController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.reverse().then((_) {
          widget.onDone?.call();
        });
      }
    });

    // Generate bolt after first frame so we have a size
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = MediaQuery.of(context).size;
      setState(() {
        _bolt = _generateBolt(size);
      });
      _drawController.forward();
    });
  }

  @override
  void dispose() {
    _drawController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bolt == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: Listenable.merge([_drawController, _fadeController]),
          builder: (context, _) {
            return CustomPaint(
              painter: _LightningPainter(
                segments: _bolt!.segments,
                progress: _drawController.value,
                opacity: _fadeController.value,
              ),
            );
          },
        ),
      ),
    );
  }
}
