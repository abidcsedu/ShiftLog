import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular progress ring with a child in the center.
/// [progress] is 0..1+ ; values >= 1 render fully and switch to [completeColor].
/// When [gradient] is set, the arc is painted with it (unless complete).
class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double stroke;
  final Color color;
  final Color completeColor;
  final Color trackColor;
  final List<Color>? gradient;
  final Widget child;

  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 190,
    this.stroke = 12,
    required this.color,
    required this.completeColor,
    required this.trackColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final target = progress.clamp(0, 1).toDouble();
    final complete = progress >= 1;
    final arcColor = complete ? completeColor : color;
    return SizedBox(
      width: size,
      height: size,
      // Sweep smoothly to the current value on load and whenever it changes.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeOutCubic,
        child: Center(child: child),
        builder: (context, value, child) => CustomPaint(
          painter: _RingPainter(
            progress: value,
            stroke: stroke,
            color: arcColor,
            trackColor: trackColor,
            gradient: complete ? null : gradient,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final Color color;
  final Color trackColor;
  final List<Color>? gradient;

  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.color,
    required this.trackColor,
    this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    if (gradient != null && gradient!.length >= 2) {
      // Sweep gradient starting at the top (-90°) for a premium accent.
      arc.shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: const GradientRotation(-math.pi / 2),
        colors: gradient!,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      arc.color = color;
    }

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.gradient != gradient;
}
