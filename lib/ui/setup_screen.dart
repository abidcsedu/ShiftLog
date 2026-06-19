import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/enums.dart';
import '../domain/work_logic.dart';
import '../state/providers.dart';
import 'backup_actions.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  Gender _gender = Gender.male;

  Future<void> _finish() async {
    await ref.read(repositoryProvider).createSettings(_gender);
    if (mounted) context.go('/home');
  }

  Future<void> _restore() async {
    final ok = await importBackup(context, ref);
    if (ok && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.schedule,
                    size: 34, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(height: 20),
              Text('Welcome to ShiftLog',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'Track your attendance, work-from-home days and leave — all on your device.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 32),
              Text('Select your gender',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('This sets your yearly holiday allocation.',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              for (final g in Gender.values) ...[
                _GenderCard(
                  gender: g,
                  selected: _gender == g,
                  onTap: () => setState(() => _gender = g),
                ),
                const SizedBox(height: 12),
              ],
              const Spacer(),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  onPressed: _finish,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _restore,
                icon: const Icon(Icons.restore, size: 18),
                label: const Text('Restore from a backup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final Gender gender;
  final bool selected;
  final VoidCallback onTap;
  const _GenderCard(
      {required this.gender, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = gender == Gender.female ? Icons.woman : Icons.man;
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(gender.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  Text('${allocationFor(gender)} holidays / year',
                      style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ),
              const Spacer(),
              if (selected)
                Icon(Icons.check_circle, color: scheme.primary)
              else
                Icon(Icons.circle_outlined, color: scheme.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }
}
