import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/work_logic.dart';
import '../services/notification_service.dart';
import '../state/providers.dart';
import 'theme.dart';
import 'widgets/counter_card.dart';
import 'widgets/leave_editor.dart';
import 'widgets/mode_chip.dart';
import 'widgets/progress_ring.dart';
import 'widgets/session_editor.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Rebuild every second so the live timer advances while clocked in.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _toggleClock(List<WorkSession> today) async {
    final repo = ref.read(repositoryProvider);
    final notif = NotificationService();
    final clockedIn = today.any((s) => s.isOpen);
    if (clockedIn) {
      await repo.clockOut();
      await notif.clearActiveSession();
      await notif.status('Clocked out', 'Session saved.');
    } else {
      final mode = ref.read(selectedModeProvider);
      if (mode == WorkMode.wfh) {
        final all = ref.read(allSessionsProvider).value ?? const [];
        final s = ref.read(settingsProvider).value;
        final reason = canMarkWfh(all, DateTime.now(),
            s?.monthlyWfhLimit ?? 2, s?.yearlyWfhLimit ?? 12);
        if (reason != null) {
          _snack(reason);
          return;
        }
      }
      await repo.clockIn(mode);
      await notif.showActiveSession(DateTime.now());
    }
  }

  /// Prompt to end a session left open too long (forgot to clock out).
  Future<void> _endOverdue(WorkSession s) async {
    final ok = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.warning_amber, color: Color(0xFFEA580C)),
              title: Text('Still clocked in?'),
              subtitle: Text(
                  'This session has been running over 16 hours. End it now?'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Keep running'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Clock out'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (ok == true) {
      await ref.read(repositoryProvider).clockOut();
      await NotificationService().clearActiveSession();
    }
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));

  /// The "+" menu: choose to add a work session or log a leave.
  Future<void> _showAddMenu() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.more_time),
              title: const Text('Add session'),
              subtitle: const Text('Log a work session (today or past)'),
              onTap: () => Navigator.pop(sheetContext, 'session'),
            ),
            ListTile(
              leading: const Icon(Icons.beach_access),
              title: const Text('Apply for leave'),
              subtitle: const Text('Casual, sick, etc. — by date range'),
              onTap: () => Navigator.pop(sheetContext, 'leave'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'session') {
      await showSessionEditor(context);
    } else if (action == 'leave') {
      await showLeaveEditor(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todaySessionsProvider).value ?? const [];
    final openToday = today.where((s) => s.isOpen).toList();
    final clockedIn = openToday.isNotEmpty;
    final activeSince = clockedIn ? openToday.first.clockIn : null;
    final total = totalForDay(today);
    final wfh = ref.watch(wfhStatusProvider);
    final leaveLeft = ref.watch(totalLeaveRemainingProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final dailyTarget = ref.watch(dailyTargetProvider);
    final name = ref.watch(displayNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(name == null ? 'ShiftLog' : _greeting(name)),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.add),
            tooltip: 'Add session or leave',
            onPressed: _showAddMenu,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Hero: date, live status, progress ring toward daily target ---
          _TimerHero(
            date: _prettyDate(DateTime.now()),
            total: total,
            target: dailyTarget,
            clockedIn: clockedIn,
            activeSince: activeSince,
            breakEven: breakEvenTime(total, dailyTarget, clockedIn, DateTime.now()),
          ),
          if (clockedIn && isOverdue(openToday.first, DateTime.now())) ...[
            const SizedBox(height: 12),
            Material(
              color: const Color(0xFFEA580C).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => _endOverdue(openToday.first),
                borderRadius: BorderRadius.circular(14),
                child: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, color: Color(0xFFEA580C)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                            'Clocked in over 16h — did you forget to clock out?',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      Icon(Icons.chevron_right, color: Color(0xFFEA580C)),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),

          // Work mode selector (applies to the next sign-in). Defaults to Office.
          Row(
            children: [
              Text('Work mode',
                  style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<WorkMode>(
                  value: selectedMode,
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(12),
                  items: [
                    for (final m in WorkMode.values)
                      DropdownMenuItem(
                        value: m,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(modeVisual(m).icon,
                                size: 16, color: modeVisual(m).color),
                            const SizedBox(width: 8),
                            Text(m.label),
                          ],
                        ),
                      ),
                  ],
                  // Locked while a session is open (applies to next sign-in).
                  onChanged: clockedIn
                      ? null
                      : (m) =>
                          ref.read(selectedModeProvider.notifier).state = m!,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Big Sign In / Out button — solid blue to sign in, solid red to sign
          // out, with a soft accent glow while idle.
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: clockedIn
                  ? Theme.of(context).colorScheme.error
                  : const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(18),
              boxShadow: clockedIn
                  ? null
                  : [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.32),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleClock(today),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (c, anim) => FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                          scale: Tween(begin: 0.92, end: 1.0).animate(anim),
                          child: c),
                    ),
                    child: Row(
                      key: ValueKey(clockedIn),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(clockedIn ? Icons.logout : Icons.login,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(clockedIn ? 'Sign Out' : 'Sign In',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Counter cards
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Expanded(
                child: CounterCard(
                  title: 'WFH / mo',
                  value: '${wfh.monthRemaining}',
                  subtitle: 'of ${wfh.monthLimit} left',
                  color: const Color(0xFF0D9488),
                  icon: Icons.home_work,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CounterCard(
                  title: 'WFH / yr',
                  value: '${wfh.yearRemaining}',
                  subtitle: 'of ${wfh.yearLimit} left',
                  color: const Color(0xFF3B82F6),
                  icon: Icons.calendar_today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CounterCard(
                  title: 'Leave',
                  value: _trim(leaveLeft),
                  subtitle: 'days left',
                  color: const Color(0xFFEA580C),
                  icon: Icons.beach_access,
                ),
              ),
            ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Today’s sessions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  )),
          const SizedBox(height: 8),
          if (today.isEmpty)
            _EmptyState(
              icon: Icons.bedtime_outlined,
              text: 'No sessions yet.\nTap Sign In to start your day.',
            )
          else
            ...today.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _SessionTile(session: s),
                )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Calm neutral hero (matches the calendar's surface look): date, live status,
/// and a progress ring with goal-oriented messaging toward the daily target.
class _TimerHero extends StatelessWidget {
  final String date;
  final Duration total;
  final Duration target;
  final bool clockedIn;
  final DateTime? activeSince;
  final DateTime? breakEven;

  const _TimerHero({
    required this.date,
    required this.total,
    required this.target,
    required this.clockedIn,
    this.activeSince,
    this.breakEven,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = dayProgress(total, target);
    final pct = (progress * 100).clamp(0, 999).round();
    final met = total >= target && target > Duration.zero;
    final remaining = target - total;
    const completeColor = Color(0xFF16A34A);
    final ringColor = met ? completeColor : scheme.primary;

    final String caption = met
        ? '🎉  Daily target met'
        : (clockedIn && breakEven != null
            ? 'Leave by ${formatTime(breakEven!)} • ${formatDuration(remaining)} to go'
            : '$pct% of ${formatDuration(target)}');

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.event, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(date,
                  style: TextStyle(
                      color: scheme.onSurface, fontWeight: FontWeight.w600)),
              const Spacer(),
              _StatusPill(clockedIn: clockedIn),
            ],
          ),
          const SizedBox(height: 20),
          ProgressRing(
            progress: progress,
            color: ringColor,
            completeColor: completeColor,
            trackColor: scheme.surfaceContainerHighest,
            gradient: met ? null : AppTheme.brandGradient.colors,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('TODAY’S TOTAL',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 11,
                    )),
                const SizedBox(height: 4),
                Text(
                  formatDurationHms(total),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),
          // Caption sits below the ring so long break-even text never overlaps.
          const SizedBox(height: 14),
          Text(caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          if (clockedIn && activeSince != null) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Active since ${formatTime(activeSince!)}',
                  style: TextStyle(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool clockedIn;
  const _StatusPill({required this.clockedIn});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color =
        clockedIn ? const Color(0xFF16A34A) : scheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(clockedIn ? 'Active' : 'Idle',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 40, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

String _trim(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

String _prettyDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

class _SessionTile extends StatelessWidget {
  final WorkSession session;
  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final end = session.clockOut;
    final dur = totalForDay([session]);
    return Card(
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        onTap: () => showSessionEditor(context, existing: session),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              ModeChip(session.mode),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${formatTime(session.clockIn)}  →  ${end == null ? 'now' : formatTime(end)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(formatDuration(dur),
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  size: 18, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

String _greeting(String name) {
  final h = DateTime.now().hour;
  final part = h < 12
      ? 'Good morning'
      : (h < 17 ? 'Good afternoon' : 'Good evening');
  return '$part, $name';
}
