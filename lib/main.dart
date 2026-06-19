import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'state/providers.dart';
import 'ui/theme.dart';

void main() {
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
    );
  }
}
