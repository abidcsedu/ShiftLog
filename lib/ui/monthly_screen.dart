import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/work_logic.dart';
import '../state/providers.dart';
import 'widgets/counter_card.dart';

class MonthlyScreen extends ConsumerStatefulWidget {
  const MonthlyScreen({super.key});

  @override
  ConsumerState<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends ConsumerState<MonthlyScreen> {
  // Selected month as a 'yyyy-MM' key; defaults to the current month.
  late String _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(allSessionsProvider).value ?? const [];

    // Months with data + always the current month, newest first.
    final now = DateTime.now();
    final months = {
      for (final m in monthsWithData(sessions))
        '${m.year.toString().padLeft(4, '0')}-${m.month.toString().padLeft(2, '0')}',
      _selected,
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}',
    }.toList()
      ..sort((a, b) => b.compareTo(a));

    final target = ref.watch(dailyTargetProvider);
    final parts = _selected.split('-');
    final stats = monthlyStats(
      sessions,
      int.parse(parts[0]),
      int.parse(parts[1]),
      requiredAvg: target,
      weekend: ref.watch(weekendProvider),
      overrides: ref.watch(dayOverridesProvider).value ?? const {},
      leaves: ref.watch(leaveDaysMapProvider),
    );

    final ok = stats.meetsTarget;
    final accent = stats.daysWorked == 0
        ? Colors.grey
        : (ok ? Colors.green.shade600 : Colors.red.shade600);

    final days = stats.daily.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Month switcher
          DropdownButtonFormField<String>(
            initialValue: _selected,
            decoration: const InputDecoration(
              labelText: 'Month',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_month),
            ),
            items: [
              for (final k in months)
                DropdownMenuItem(
                  value: k,
                  child: Text(monthLabel(
                      int.parse(k.split('-')[0]), int.parse(k.split('-')[1]))),
                ),
            ],
            onChanged: (v) => setState(() => _selected = v!),
          ),
          const SizedBox(height: 20),

          // Hero: average per worked day vs the 8h 30m target
          Card(
            color: accent.withValues(alpha: 0.12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Average / worked day',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    formatDuration(stats.average),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        stats.daysWorked == 0
                            ? Icons.info_outline
                            : (ok ? Icons.check_circle : Icons.warning_amber),
                        size: 18,
                        color: accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        stats.daysWorked == 0
                            ? 'No work logged this month'
                            : (ok
                                ? 'On track for ${formatDuration(stats.requiredAvg)} / working day'
                                : 'Below ${formatDuration(stats.requiredAvg)} / working day'),
                        style: TextStyle(color: accent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Stat cards
          Row(
            children: [
              Expanded(
                child: CounterCard(
                  title: 'Total worked',
                  value: formatDuration(stats.total),
                  subtitle:
                      '${stats.daysWorked} of ${_days(stats.expectedDays)} days',
                  color: const Color(0xFF4F46E5),
                  icon: Icons.timer_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CounterCard(
                  title: 'Required',
                  value: formatDuration(stats.target),
                  subtitle: '${_days(stats.expectedDays)} working days',
                  color: Colors.blueGrey,
                  icon: Icons.flag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CounterCard(
                  title: stats.delta.isNegative ? 'Shortfall' : 'Surplus',
                  value: formatSignedDuration(stats.delta),
                  subtitle: 'vs target',
                  color: stats.delta.isNegative
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF16A34A),
                  icon: stats.delta.isNegative
                      ? Icons.trending_down
                      : Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CounterCard(
                  title: 'WFH days',
                  value: '${stats.wfhDays}',
                  subtitle: 'this month',
                  color: const Color(0xFF0D9488),
                  icon: Icons.home_work,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (stats.daysWorked > 0) ...[
            Text('Daily hours',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            _HoursChart(stats: stats, targetHours: target.inMinutes / 60.0),
            const SizedBox(height: 20),
          ],

          Text('Daily breakdown',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (days.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('No days worked in this month.'),
            )
          else
            ...days.map((k) {
              final dur = stats.daily[k]!;
              final met = dur >= stats.requiredAvg;
              return Card(
                child: ListTile(
                  leading: Icon(
                    met ? Icons.check_circle : Icons.remove_circle_outline,
                    color: met ? Colors.green : Colors.orange,
                  ),
                  title: Text(k),
                  trailing: Text(
                    formatDuration(dur),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

/// Formats an expected-days count: whole numbers plain, halves with one decimal.
String _days(double v) =>
    v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

/// Bar chart of worked hours per day for the month, with a target line.
class _HoursChart extends StatelessWidget {
  final MonthlyStats stats;
  final double targetHours;
  const _HoursChart({required this.stats, required this.targetHours});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final days = stats.daily.keys.toList()..sort();
    final maxHours = days
        .map((k) => stats.daily[k]!.inMinutes / 60.0)
        .fold(targetHours, (a, b) => a > b ? a : b);
    final maxY = (maxHours + 1).ceilToDouble();

    final bars = <BarChartGroupData>[];
    for (var i = 0; i < days.length; i++) {
      final hours = stats.daily[days[i]]!.inMinutes / 60.0;
      final met = hours >= targetHours;
      bars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: hours,
          width: 14,
          borderRadius: BorderRadius.circular(4),
          color: met ? const Color(0xFF16A34A) : scheme.primary,
        ),
      ]));
    }

    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 20, 16, 8),
        child: SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              barGroups: bars,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: scheme.outlineVariant, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(show: false),
              extraLinesData: ExtraLinesData(horizontalLines: [
                HorizontalLine(
                  y: targetHours,
                  color: const Color(0xFFEA580C),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    style: const TextStyle(
                        color: Color(0xFFEA580C),
                        fontSize: 10,
                        fontWeight: FontWeight.w700),
                    labelResolver: (_) => 'target',
                  ),
                ),
              ]),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (maxY / 4).ceilToDouble(),
                    getTitlesWidget: (v, _) => Text('${v.toInt()}h',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 10)),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i < 0 || i >= days.length) return const SizedBox();
                      // Show day-of-month, thinned out if many days.
                      if (days.length > 12 && i % 3 != 0) {
                        return const SizedBox();
                      }
                      final dom = int.parse(days[i].split('-')[2]);
                      return Text('$dom',
                          style: TextStyle(
                              color: scheme.onSurfaceVariant, fontSize: 10));
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
