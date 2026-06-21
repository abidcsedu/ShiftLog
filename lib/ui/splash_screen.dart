import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/providers.dart';
import 'widgets/profile_avatar.dart';

/// Time-of-day greeting, optionally personalised with the employee's name.
String greetingFor(DateTime now, String? name) {
  final h = now.hour;
  final part = h < 12
      ? 'Good morning'
      : (h < 17 ? 'Good afternoon' : 'Good evening');
  return name == null ? part : '$part, $name';
}

/// Brief welcome shown when the app opens: avatar + greeting, then routes Home.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1700), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(displayNameProvider);
    final photo = ref.watch(profilePhotoProvider);
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeOutCubic,
          builder: (context, v, child) => Opacity(
            opacity: v.clamp(0, 1),
            child: Transform.translate(
                offset: Offset(0, (1 - v) * 14), child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileAvatar(radius: 44, photoPath: photo, name: name),
              const SizedBox(height: 22),
              Text(
                greetingFor(DateTime.now(), name),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
