import 'enums.dart';
import 'models.dart';

/// Pure business logic. No Flutter / Drift imports — directly unit-testable.

/// Stable local-date key used to group sessions/leaves by calendar day.
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

int yearOf(String key) => int.parse(key.split('-')[0]);
int monthOf(String key) => int.parse(key.split('-')[1]);

// --- A. Cumulative hours for a single day (sums all sessions) ---
Duration totalForDay(List<WorkSession> sessions, {DateTime? now}) {
  final ref = now ?? DateTime.now();
  return sessions.fold(Duration.zero, (sum, s) {
    final end = s.clockOut ?? ref; // open session counts up to 'now'
    return sum + end.difference(s.clockIn);
  });
}

/// Formats a duration as e.g. "8h 05m".
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  return '${h}h ${m.toString().padLeft(2, '0')}m';
}

/// Formats a duration with seconds, e.g. "8h 05m 09s" (used for the live timer).
String formatDurationHms(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  return '${h}h ${m.toString().padLeft(2, '0')}m ${s.toString().padLeft(2, '0')}s';
}

/// Formats a duration with a +/- sign, e.g. "+5h 30m" / "-3h 00m".
String formatSignedDuration(Duration d) =>
    '${d.isNegative ? '-' : '+'}${formatDuration(d.abs())}';

/// Formats a timestamp in 12-hour clock, e.g. "3:08 PM".
String formatTime(DateTime d) {
  final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final ampm = d.hour < 12 ? 'AM' : 'PM';
  return '$hour12:${d.minute.toString().padLeft(2, '0')} $ampm';
}

// --- B. WFH limits (day-level: a day with ANY wfh session = 1 WFH day) ---
Set<String> wfhDays(List<WorkSession> logs) => logs
    .where((l) => l.mode == WorkMode.wfh)
    .map((l) => l.dayKey)
    .toSet();

int wfhDaysInMonth(List<WorkSession> logs, int year, int month) => wfhDays(logs)
    .where((k) => yearOf(k) == year && monthOf(k) == month)
    .length;

int wfhDaysInYear(List<WorkSession> logs, int year) =>
    wfhDays(logs).where((k) => yearOf(k) == year).length;

int wfhRemainingMonth(List<WorkSession> logs, DateTime now, int monthlyLimit) =>
    monthlyLimit - wfhDaysInMonth(logs, now.year, now.month);

int wfhRemainingYear(List<WorkSession> logs, DateTime now, int yearlyLimit) =>
    yearlyLimit - wfhDaysInYear(logs, now.year);

/// Call BEFORE marking a new day as WFH. Returns null if allowed, else reason.
String? canMarkWfh(
  List<WorkSession> logs,
  DateTime day,
  int monthlyLimit,
  int yearlyLimit,
) {
  if (wfhDays(logs).contains(dayKey(day))) return null; // already counted, no-op
  if (wfhDaysInMonth(logs, day.year, day.month) >= monthlyLimit) {
    return 'Monthly WFH limit ($monthlyLimit) reached.';
  }
  if (wfhDaysInYear(logs, day.year) >= yearlyLimit) {
    return 'Yearly WFH limit ($yearlyLimit) reached.';
  }
  return null;
}

// --- C. Holiday balance (gender allocation − leaves taken this calendar year) ---
int allocationFor(Gender g) => g == Gender.female ? 30 : 25;

double leaveTakenInYear(List<LeaveEntry> leaves, int year) => leaves
    .where((l) => yearOf(l.dayKey) == year)
    .fold(0.0, (sum, l) => sum + l.type.deduction);

double holidayRemaining(List<LeaveEntry> leaves, Gender g, int year) =>
    allocationFor(g) - leaveTakenInYear(leaves, year);

// --- D. Monthly working-hours target (8h 30m average per worked day) ---

/// Required average per worked day, accumulated month-wise.
const Duration requiredDailyAverage = Duration(hours: 8, minutes: 30);

/// Per-day worked totals for one month: { 'yyyy-MM-dd' : Duration }.
Map<String, Duration> dailyTotalsInMonth(
  List<WorkSession> logs,
  int year,
  int month, {
  DateTime? now,
}) {
  final byDay = <String, List<WorkSession>>{};
  for (final s in logs) {
    if (yearOf(s.dayKey) == year && monthOf(s.dayKey) == month) {
      byDay.putIfAbsent(s.dayKey, () => []).add(s);
    }
  }
  return byDay.map((k, v) => MapEntry(k, totalForDay(v, now: now)));
}

/// Default weekend (DateTime weekdays): Friday(5) + Saturday(6).
const Set<int> defaultWeekend = {5, 6};

bool isWeekend(DateTime d, Set<int> weekend) => weekend.contains(d.weekday);

/// Parses a '5,6' CSV of weekday numbers into a set; falls back to Fri+Sat.
Set<int> parseWeekend(String? csv) {
  if (csv == null || csv.trim().isEmpty) return defaultWeekend;
  final s = csv
      .split(',')
      .map((e) => int.tryParse(e.trim()))
      .whereType<int>()
      .where((e) => e >= 1 && e <= 7)
      .toSet();
  return s.isEmpty ? defaultWeekend : s;
}

/// Expected working days in a month, counting only up to today.
/// Rules per date:
///  - override 'work' => counts (1.0); override 'off' => excluded.
///  - otherwise a non-weekend day counts (1.0); a weekend day counts only if
///    it was actually worked (a swapped Saturday).
///  - a full-day leave on a counted day removes it; a half-day leave => 0.5.
double expectedWorkingDays({
  required int year,
  required int month,
  required Set<int> weekend,
  required Map<String, String> overrides,
  required Set<String> workedDays,
  Map<String, LeaveType> leaves = const {},
  DateTime? today,
}) {
  final now = today ?? DateTime.now();
  final todayDate = DateTime(now.year, now.month, now.day);
  final lastDay = DateTime(year, month + 1, 0).day;
  var total = 0.0;
  for (var d = 1; d <= lastDay; d++) {
    final date = DateTime(year, month, d);
    if (date.isAfter(todayDate)) break; // don't count future days
    final key = dayKey(date);
    final ov = overrides[key];
    bool working;
    if (ov == 'work') {
      working = true;
    } else if (ov == 'off') {
      working = false;
    } else if (!isWeekend(date, weekend)) {
      working = true;
    } else {
      working = workedDays.contains(key); // worked weekend (swap)
    }
    if (!working) continue;
    final lv = leaves[key];
    if (lv == LeaveType.full) continue; // on leave: hours not owed
    total += (lv == LeaveType.half) ? 0.5 : 1.0;
  }
  return total;
}

/// Distinct months (newest first) that have any logged session.
List<({int year, int month})> monthsWithData(List<WorkSession> logs) {
  final keys = logs.map((s) => s.dayKey.substring(0, 7)).toSet().toList()
    ..sort((a, b) => b.compareTo(a)); // 'yyyy-MM' desc
  return keys.map((k) {
    final p = k.split('-');
    return (year: int.parse(p[0]), month: int.parse(p[1]));
  }).toList();
}

/// Aggregated month-wise stats vs the target hours for expected working days.
class MonthlyStats {
  final int year;
  final int month;
  final Duration total; // sum of all worked time this month
  final int daysWorked; // distinct days with at least one session
  final double expectedDays; // expected working days (Sun–Thu ± swaps/leaves)
  final Duration target; // expectedDays * requiredDailyAverage
  final Duration average; // total / daysWorked (zero if none)
  final Duration delta; // total - target (positive => ahead)
  final int wfhDays;
  final Map<String, Duration> daily; // per-day breakdown
  final Duration requiredAvg; // target average per working day

  const MonthlyStats({
    required this.year,
    required this.month,
    required this.total,
    required this.daysWorked,
    required this.expectedDays,
    required this.target,
    required this.average,
    required this.delta,
    required this.wfhDays,
    required this.daily,
    this.requiredAvg = requiredDailyAverage,
  });

  bool get meetsTarget => expectedDays > 0 && total >= target;
}

MonthlyStats monthlyStats(
  List<WorkSession> logs,
  int year,
  int month, {
  DateTime? now,
  Duration requiredAvg = requiredDailyAverage,
  Set<int> weekend = defaultWeekend,
  Map<String, String> overrides = const {},
  Map<String, LeaveType> leaves = const {},
}) {
  final daily = dailyTotalsInMonth(logs, year, month, now: now);
  final daysWorked = daily.length;
  final total = daily.values.fold(Duration.zero, (a, b) => a + b);
  final expectedDays = expectedWorkingDays(
    year: year,
    month: month,
    weekend: weekend,
    overrides: overrides,
    workedDays: daily.keys.toSet(),
    leaves: leaves,
    today: now,
  );
  final target =
      Duration(microseconds: (requiredAvg.inMicroseconds * expectedDays).round());
  final average = daysWorked == 0
      ? Duration.zero
      : Duration(microseconds: total.inMicroseconds ~/ daysWorked);
  return MonthlyStats(
    year: year,
    month: month,
    total: total,
    daysWorked: daysWorked,
    expectedDays: expectedDays,
    target: target,
    average: average,
    delta: total - target,
    wfhDays: wfhDaysInMonth(logs, year, month),
    daily: daily,
    requiredAvg: requiredAvg,
  );
}

/// One bar of the daily chart.
class DayBar {
  final DateTime date;
  final Duration total;
  const DayBar(this.date, this.total);
  double get hours => total.inMinutes / 60.0;
}

/// Worked totals for the last [count] days ending on [end] (oldest first).
/// Days with no sessions appear as zero so the chart keeps a continuous axis.
List<DayBar> lastNDays(List<WorkSession> logs, DateTime end, int count) {
  final byDay = <String, Duration>{};
  for (final s in logs) {
    final end0 = s.clockOut ?? end;
    byDay[s.dayKey] = (byDay[s.dayKey] ?? Duration.zero) +
        end0.difference(s.clockIn);
  }
  final out = <DayBar>[];
  for (var i = count - 1; i >= 0; i--) {
    final d = DateTime(end.year, end.month, end.day).subtract(Duration(days: i));
    out.add(DayBar(d, byDay[dayKey(d)] ?? Duration.zero));
  }
  return out;
}

/// Today's progress toward the daily target as a 0..1+ fraction.
double dayProgress(Duration total, Duration target) =>
    target.inSeconds == 0 ? 0 : total.inSeconds / target.inSeconds;

const List<String> monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

String monthLabel(int year, int month) => '${monthNames[month - 1]} $year';
