import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/work_logic.dart';
import '../state/providers.dart';
import 'theme.dart';
import 'widgets/mode_chip.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          bottom: const TabBar(tabs: [Tab(text: 'Days'), Tab(text: 'Leaves')]),
        ),
        body: const TabBarView(children: [_DaysTab(), _LeavesTab()]),
      ),
    );
  }
}

class _DaysTab extends ConsumerStatefulWidget {
  const _DaysTab();
  @override
  ConsumerState<_DaysTab> createState() => _DaysTabState();
}

class _DaysTabState extends ConsumerState<_DaysTab> {
  bool _calendar = true;
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    _month = DateTime(n.year, n.month);
  }

  void _shiftMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  /// Tap a calendar day. A regular day can be marked a Holiday; a weekend day
  /// can be marked a Working day. An existing override can be cleared.
  Future<void> _editDay(DateTime day) async {
    final repo = ref.read(repositoryProvider);
    final weekend = ref.read(weekendProvider);
    final current = (ref.read(dayOverridesProvider).value ?? const {})[
        dayKey(day)];
    final weekendDay = isWeekend(day, weekend);
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(day.toString().split(' ').first,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(weekendDay ? 'Weekend day' : 'Working day'),
            ),
            if (!weekendDay && current != 'off')
              ListTile(
                leading: const Icon(Icons.beach_access),
                title: const Text('Mark as holiday'),
                subtitle: const Text('Office closed — excluded from target'),
                onTap: () => Navigator.pop(ctx, 'off'),
              ),
            if (weekendDay && current != 'work')
              ListTile(
                leading: const Icon(Icons.work_outline),
                title: const Text('Mark as working day'),
                subtitle: const Text('You worked this weekend (a swap)'),
                onTap: () => Navigator.pop(ctx, 'work'),
              ),
            if (current != null)
              ListTile(
                leading: const Icon(Icons.undo),
                title: Text(current == 'off'
                    ? 'Remove holiday'
                    : 'Remove working-day mark'),
                onTap: () => Navigator.pop(ctx, 'clear'),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (action == null) return;
    if (action == 'clear') {
      await repo.clearDayOverride(day);
    } else {
      await repo.setDayOverride(day, action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(allSessionsProvider).value ?? const [];
    final leaves = ref.watch(allLeavesProvider).value ?? const [];
    if (sessions.isEmpty && leaves.isEmpty) {
      return const _Empty(Icons.event_busy, 'No work logged yet.');
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                  value: true,
                  label: Text('Calendar'),
                  icon: Icon(Icons.calendar_view_month)),
              ButtonSegment(
                  value: false,
                  label: Text('List'),
                  icon: Icon(Icons.view_list)),
            ],
            selected: {_calendar},
            onSelectionChanged: (s) => setState(() => _calendar = s.first),
          ),
        ),
        Expanded(
          child: _calendar
              ? _CalendarView(
                  month: _month,
                  sessions: sessions,
                  leaves: leaves,
                  target: ref.watch(dailyTargetProvider),
                  weekend: ref.watch(weekendProvider),
                  overrides: ref.watch(dayOverridesProvider).value ?? const {},
                  onPrev: () => _shiftMonth(-1),
                  onNext: () => _shiftMonth(1),
                  onDayTap: _editDay,
                )
              : _DaysList(sessions: sessions),
        ),
      ],
    );
  }
}

class _DaysList extends StatelessWidget {
  final List<WorkSession> sessions;
  const _DaysList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (sessions.isEmpty) {
      return const _Empty(Icons.event_busy, 'No work logged yet.');
    }
    final byDay = <String, List<WorkSession>>{};
    for (final s in sessions) {
      byDay.putIfAbsent(s.dayKey, () => []).add(s);
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: days.length,
      itemBuilder: (_, i) {
        final key = days[i];
        final daySessions = byDay[key]!;
        final total = totalForDay(daySessions);
        final modes = daySessions.map((s) => s.mode).toSet();
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          color: scheme.surfaceContainerHigh,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: const Border(),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(key,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      modes.map((m) => ModeChip(m, compact: true)).toList(),
                ),
              ),
              trailing: Text(formatDuration(total),
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: scheme.primary)),
              children: daySessions
                  .map((s) => ListTile(
                        dense: true,
                        leading: Icon(Icons.schedule,
                            color: scheme.onSurfaceVariant, size: 20),
                        title: Text(
                            '${formatTime(s.clockIn)} → ${s.clockOut == null ? 'open' : formatTime(s.clockOut!)}'),
                        trailing: ModeChip(s.mode, compact: true),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Month calendar where each day is tinted by hours worked (heat-map), with
/// WFH and leave markers.
class _CalendarView extends StatelessWidget {
  final DateTime month;
  final List<WorkSession> sessions;
  final List<LeaveEntry> leaves;
  final Duration target;
  final Set<int> weekend;
  final Map<String, String> overrides;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final void Function(DateTime) onDayTap;

  const _CalendarView({
    required this.month,
    required this.sessions,
    required this.leaves,
    required this.target,
    required this.weekend,
    required this.overrides,
    required this.onPrev,
    required this.onNext,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final y = month.year, m = month.month;
    final daily = dailyTotalsInMonth(sessions, y, m);
    // Dominant work mode per day (the mode with the most minutes) → its color
    // tints the whole cell so WFH/Office/Outside read at a glance.
    final dayModeMinutes = <String, Map<WorkMode, int>>{};
    for (final s in sessions) {
      if (yearOf(s.dayKey) != y || monthOf(s.dayKey) != m) continue;
      final mins = (s.clockOut ?? s.clockIn).difference(s.clockIn).inMinutes;
      (dayModeMinutes[s.dayKey] ??= {})
          .update(s.mode, (v) => v + mins, ifAbsent: () => mins);
    }
    WorkMode? dominantMode(String key) {
      final m = dayModeMinutes[key];
      if (m == null || m.isEmpty) return null;
      return m.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    final leaveDays = {
      for (final l in leaves)
        if (yearOf(l.dayKey) == y && monthOf(l.dayKey) == m) l.dayKey
    };

    final daysInMonth = DateTime(y, m + 1, 0).day;
    // Sunday-first grid: Sun(7)->col 0, Mon(1)->col 1 … Sat(6)->col 6.
    final lead = DateTime(y, m, 1).weekday % 7;
    final targetMin = target.inMinutes == 0 ? 510 : target.inMinutes;

    final cells = <Widget>[];
    for (var i = 0; i < lead; i++) {
      cells.add(const SizedBox());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(y, m, d);
      final key = dayKey(date);
      final dur = daily[key] ?? Duration.zero;
      final intensity = (dur.inMinutes / targetMin).clamp(0.0, 1.0);
      final mode = dominantMode(key);
      cells.add(_DayCell(
        day: d,
        intensity: intensity,
        hasWork: dur > Duration.zero,
        workColor: mode == null ? null : modeVisual(mode).color,
        isLeave: leaveDays.contains(key),
        isWeekend: isWeekend(date, weekend),
        dayOverride: overrides[key],
        onTap: () => onDayTap(date),
      ));
    }

    const wkLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S']; // Sunday-first

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            IconButton(
                onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
            Expanded(
              child: Text(monthLabel(y, m),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            IconButton(
                onPressed: onNext, icon: const Icon(Icons.chevron_right)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (final w in wkLabels)
              Expanded(
                child: Center(
                  child: Text(w,
                      style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          children: cells,
        ),
        const SizedBox(height: 20),
        _Legend(),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final double intensity;
  final bool hasWork;
  final Color? workColor; // dominant work-mode color for the day
  final bool isLeave;
  final bool isWeekend;
  final String? dayOverride; // 'off' | 'work' | null
  final VoidCallback onTap;
  const _DayCell({
    required this.day,
    required this.intensity,
    required this.hasWork,
    required this.workColor,
    required this.isLeave,
    required this.isWeekend,
    required this.dayOverride,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // A worked day is filled with its work-mode color (WFH teal / Office indigo
    // / Outside amber), saturation by hours — overriding everything. Otherwise
    // a marked holiday is rose, a weekend is gold, a normal day is neutral.
    final isHoliday = dayOverride == 'off';
    final isWeekendRest = isWeekend && dayOverride != 'work';
    const weekendColor = Color(0xFFF59E0B); // gold
    const holidayColor = Color(0xFFF43F5E); // rose
    final Color bg;
    if (hasWork) {
      bg = Color.lerp(scheme.surfaceContainerHigh,
          workColor ?? scheme.primary, 0.35 + intensity * 0.65)!;
    } else if (isHoliday) {
      bg = Color.lerp(scheme.surfaceContainerHigh, holidayColor, 0.30)!;
    } else if (isWeekendRest) {
      bg = Color.lerp(scheme.surfaceContainerHigh, weekendColor, 0.30)!;
    } else {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.45);
    }
    final fg = hasWork && intensity > 0.45 ? Colors.white : scheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          // A designated (not-yet-worked) weekend working day gets an outline.
          border: !hasWork && dayOverride == 'work'
              ? Border.all(color: scheme.primary, width: 1.5)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text('$day',
                  style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ),
            if (isLeave)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: Color(0xFF9333EA), shape: BoxShape.circle),
                ),
              ),
            // Marked office holiday gets a small icon (it's also rose-tinted).
            if (isHoliday)
              const Positioned(
                left: 4,
                top: 4,
                child: Icon(Icons.event_busy, size: 11, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = TextStyle(
        color: scheme.onSurfaceVariant,
        fontSize: 13,
        fontWeight: FontWeight.w500);
    Color tint(Color c) => Color.lerp(scheme.surfaceContainerHigh, c, 0.55)!;
    return Column(
      children: [
        // Worked-day colors (the cell fill reflects the day's work mode).
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 18,
          runSpacing: 10,
          children: [
            for (final m in WorkMode.values)
              _LegendKey(color: tint(modeVisual(m).color), label: m.label),
          ],
        ),
        const SizedBox(height: 12),
        // Non-working days + markers.
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 18,
          runSpacing: 10,
          children: [
            _LegendKey(color: tint(const Color(0xFFF59E0B)), label: 'Weekend'),
            _LegendKey(color: tint(const Color(0xFFF43F5E)), label: 'Holiday'),
            _LegendKey(color: const Color(0xFF9333EA), label: 'Leave'),
          ],
        ),
        const SizedBox(height: 14),
        // Hours intensity ramp (deeper = more hours).
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Less', style: labelStyle),
            const SizedBox(width: 8),
            for (final t in [0.15, 0.35, 0.55, 0.75, 1.0])
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Color.lerp(
                      scheme.surfaceContainerHigh, scheme.primary, t),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            const SizedBox(width: 8),
            Text('More', style: labelStyle),
          ],
        ),
      ],
    );
  }
}

class _LegendKey extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendKey({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 7),
        Text(label,
            style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _LeavesTab extends ConsumerWidget {
  const _LeavesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final leaves = ref.watch(allLeavesProvider).value ?? const [];
    final g = ref.watch(genderProvider);
    final year = DateTime.now().year;
    final taken = leaveTakenInYear(leaves, year);
    final alloc = g == null ? 0 : allocationFor(g);
    final remaining = alloc - taken;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$year leave balance',
                      style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Taken $taken  •  Allocation $alloc',
                      style: TextStyle(
                          color: scheme.onPrimaryContainer
                              .withValues(alpha: 0.75))),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(_trim(remaining),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w800)),
                  Text('left',
                      style: TextStyle(color: scheme.onPrimaryContainer)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: leaves.isEmpty
              ? const _Empty(Icons.beach_access, 'No leaves taken.')
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: leaves
                      .map((l) => Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: scheme.surfaceContainerHigh,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF9333EA)
                                    .withValues(alpha: 0.14),
                                child: const Icon(Icons.beach_access,
                                    color: Color(0xFF9333EA)),
                              ),
                              title: Text(l.dayKey,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(l.type.label),
                              trailing: Text('-${l.type.deduction}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF9333EA))),
                            ),
                          ))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

String _trim(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toString();

class _Empty extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Empty(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: scheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(text, style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
