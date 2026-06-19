import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular progress ring with a child in the center.
/// [progress] is 0..1+ ; values >= 1 render fully and switch to [completeColor].
class ProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final double stroke;
  final Color color;
  final Color completeColor;
  final Color trackColor;
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
  });

  @override
  Widget build(BuildContext context) {
    final target = progress.clamp(0, 1).toDouble();
    final arcColor = progress >= 1 ? completeColor : color;
    return SizedBox(
      width: size,
      height: size,
      // Sweep smoothly to the current value on load and whenever it changes.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: target),
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        child: Center(child: child),
        builder: (context, value, child) => CustomPaint(
          painter: _RingPainter(
            progress: value,
            stroke: stroke,
            color: arcColor,
            trackColor: trackColor,
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

  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.color,
    required this.trackColor,
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
      ..strokeCap = StrokeCap.round
      ..color = color;

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
      old.trackColor != trackColor;
}
