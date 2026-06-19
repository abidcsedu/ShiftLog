import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'app/router.dart';
import 'services/notification_service.dart';
import 'state/providers.dart';
import 'ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const ProviderScope(child: ShiftLogApp()));
}

class ShiftLogApp extends ConsumerWidget {
  const ShiftLogApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'ShiftLog',
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeModeProvider),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      builder: (context, child) => _LockGate(child: child ?? const SizedBox()),
    );
  }
}

/// Shows a lock screen requiring device biometric/PIN when "App lock" is on.
class _LockGate extends ConsumerStatefulWidget {
  final Widget child;
  const _LockGate({required this.child});

  @override
  ConsumerState<_LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<_LockGate> {
  bool _unlocked = false;
  bool _authing = false;

  Future<void> _auth() async {
    if (_authing) return;
    _authing = true;
    try {
      final ok = await LocalAuthentication().authenticate(
        localizedReason: 'Unlock ShiftLog',
        persistAcrossBackgrounding: true,
      );
      if (ok && mounted) setState(() => _unlocked = true);
    } catch (_) {
      // No biometrics/PIN enrolled, or platform error → don't hard-lock out.
      if (mounted) setState(() => _unlocked = true);
    } finally {
      _authing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = ref.watch(biometricLockProvider);
    if (!locked || _unlocked) return widget.child;

    // Trigger the prompt once the lock screen is shown.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_unlocked) _auth();
    });

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            const Text('ShiftLog is locked',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _auth,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
