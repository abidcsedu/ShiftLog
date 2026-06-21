import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/providers.dart';

enum _Period { morning, afternoon, evening }

_Period _periodFor(int hour) => hour < 12
    ? _Period.morning
    : (hour < 17 ? _Period.afternoon : _Period.evening);

/// Time-of-day greeting, optionally personalised with the employee's name.
String greetingFor(DateTime now, String? name) {
  final part = switch (_periodFor(now.hour)) {
    _Period.morning => 'Good morning',
    _Period.afternoon => 'Good afternoon',
    _Period.evening => 'Good evening',
  };
  return name == null ? part : '$part, $name';
}

/// Brief welcome on app open: a time-of-day animation + greeting, then Home.
/// Each period gets its own motion: a rising sun (morning), a sun with slowly
/// rotating rays (afternoon), and a moon with twinkling stars (evening).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final _Period _period;

  @override
  void initState() {
    super.initState();
    _period = _periodFor(DateTime.now().hour);
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    if (_period == _Period.morning) {
      _c.forward();
    } else {
      _c.repeat();
    }
    Timer(const Duration(milliseconds: 1900), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(displayNameProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 132,
              height: 132,
              child: AnimatedBuilder(
                animation: _c,
                builder: (_, _) => CustomPaint(
                  painter: _GreetingPainter(period: _period, t: _c.value),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Greeting text fades + rises in.
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, v, child) => Opacity(
                opacity: v.clamp(0, 1),
                child: Transform.translate(
                    offset: Offset(0, (1 - v) * 12), child: child),
              ),
              child: Text(
                greetingFor(DateTime.now(), name),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingPainter extends CustomPainter {
  final _Period period;
  final double t; // 0..1 animation value
  _GreetingPainter({required this.period, required this.t});

  static const _morning = Color(0xFFF59E0B); // amber sunrise
  static const _afternoon = Color(0xFFFBBF24); // bright gold
  static const _evening = Color(0xFF818CF8); // indigo dusk

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    switch (period) {
      case _Period.morning:
        _paintMorning(canvas, size, center);
      case _Period.afternoon:
        _paintAfternoon(canvas, center);
      case _Period.evening:
        _paintEvening(canvas, size, center);
    }
  }

  void _glow(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(colors: [
            color.withValues(alpha: 0.35),
            color.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCircle(center: c, radius: r)));
  }

  // Sun rises from below a horizon, with a warm glow.
  void _paintMorning(Canvas canvas, Size size, Offset center) {
    final rise = Curves.easeOutCubic.transform(t.clamp(0, 1));
    final sunY = size.height * 0.78 - rise * size.height * 0.30;
    final sun = Offset(center.dx, sunY);
    _glow(canvas, sun, 54, _morning);
    canvas.drawCircle(sun, 26, Paint()..color = _morning);
    // Horizon line.
    final hy = size.height * 0.80;
    canvas.drawLine(
      Offset(size.width * 0.12, hy),
      Offset(size.width * 0.88, hy),
      Paint()
        ..color = _morning.withValues(alpha: 0.5)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
  }

  // Sun with slowly rotating rays.
  void _paintAfternoon(Canvas canvas, Offset center) {
    _glow(canvas, center, 56, _afternoon);
    final ray = Paint()
      ..color = _afternoon
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const n = 8;
    final angle = t * 2 * math.pi;
    for (var i = 0; i < n; i++) {
      final a = angle + i * (2 * math.pi / n);
      final d = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + d * 30, center + d * 44, ray);
    }
    canvas.drawCircle(center, 20, Paint()..color = _afternoon);
  }

  // Crescent moon with twinkling stars.
  void _paintEvening(Canvas canvas, Size size, Offset center) {
    _glow(canvas, center, 52, _evening);
    // Crescent = full circle minus an offset circle (clear blend).
    final moon = Paint()..color = _evening;
    canvas.saveLayer(Rect.fromCircle(center: center, radius: 30), Paint());
    canvas.drawCircle(center, 24, moon);
    canvas.drawCircle(Offset(center.dx + 11, center.dy - 7), 22,
        Paint()..blendMode = BlendMode.clear);
    canvas.restore();
    // Stars twinkle out of phase.
    const stars = [Offset(-38, -28), Offset(34, 30), Offset(40, -34)];
    for (var i = 0; i < stars.length; i++) {
      final phase = (t * 2 * math.pi) + i * 2.1;
      final a = 0.35 + 0.65 * ((math.sin(phase) + 1) / 2);
      canvas.drawCircle(center + stars[i], 2.6,
          Paint()..color = _evening.withValues(alpha: a));
    }
  }

  @override
  bool shouldRepaint(_GreetingPainter old) =>
      old.t != t || old.period != period;
}
