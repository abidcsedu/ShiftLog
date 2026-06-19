import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (moved to legacy in Riverpod 3.x)

import '../data/database.dart';
import '../data/repository.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/work_logic.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider = Provider<Repository>(
    (ref) => Repository(ref.watch(databaseProvider)));

// --- settings ---
final settingsProvider = StreamProvider<UserSetting?>(
    (ref) => ref.watch(repositoryProvider).watchSettings());

final genderProvider = Provider<Gender?>((ref) {
  final s = ref.watch(settingsProvider).value;
  return s == null ? null : GenderX.fromDb(s.gender);
});

// Theme: null darkMode => follow system; true => dark; false => light.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final dark = ref.watch(settingsProvider).value?.darkMode;
  return switch (dark) {
    true => ThemeMode.dark,
    false => ThemeMode.light,
    null => ThemeMode.system,
  };
});

// Required average per worked day (defaults to 8h 30m).
final dailyTargetProvider = Provider<Duration>((ref) {
  final mins = ref.watch(settingsProvider).value?.dailyTargetMinutes ?? 510;
  return Duration(minutes: mins);
});

final displayNameProvider = Provider<String?>((ref) {
  final n = ref.watch(settingsProvider).value?.displayName;
  return (n == null || n.trim().isEmpty) ? null : n.trim();
});

// Weekend weekdays (DateTime weekday numbers), default Fri+Sat.
final weekendProvider = Provider<Set<int>>((ref) =>
    parseWeekend(ref.watch(settingsProvider).value?.weekendDays));

// Per-date working-day overrides: { 'yyyy-MM-dd' : 'off' | 'work' }.
final dayOverridesProvider = StreamProvider<Map<String, String>>(
    (ref) => ref.watch(repositoryProvider).watchDayOverrides());

// Leaves indexed by day for quick lookup.
final leavesByDayProvider = Provider<Map<String, LeaveType>>((ref) {
  final leaves = ref.watch(allLeavesProvider).value ?? const [];
  return {for (final l in leaves) l.dayKey: l.type};
});

// --- raw data streams ---
final allSessionsProvider = StreamProvider<List<WorkSession>>(
    (ref) => ref.watch(repositoryProvider).watchAllSessions());

final todaySessionsProvider = StreamProvider<List<WorkSession>>(
    (ref) => ref.watch(repositoryProvider).watchSessionsForDay(dayKey(DateTime.now())));

final allLeavesProvider = StreamProvider<List<LeaveEntry>>(
    (ref) => ref.watch(repositoryProvider).watchAllLeaves());

// --- selected work mode for the NEXT clock-in ---
final selectedModeProvider =
    StateProvider<WorkMode>((ref) => WorkMode.office);

// --- derived counters (computed via pure work_logic) ---
class WfhStatus {
  final int monthUsed, monthLimit, yearUsed, yearLimit;
  const WfhStatus(this.monthUsed, this.monthLimit, this.yearUsed, this.yearLimit);
  int get monthRemaining => monthLimit - monthUsed;
  int get yearRemaining => yearLimit - yearUsed;
}

final wfhStatusProvider = Provider<WfhStatus>((ref) {
  final logs = ref.watch(allSessionsProvider).value ?? const [];
  final s = ref.watch(settingsProvider).value;
  final now = DateTime.now();
  final monthLimit = s?.monthlyWfhLimit ?? 2;
  final yearLimit = s?.yearlyWfhLimit ?? 12;
  return WfhStatus(
    wfhDaysInMonth(logs, now.year, now.month),
    monthLimit,
    wfhDaysInYear(logs, now.year),
    yearLimit,
  );
});

final holidayRemainingProvider = Provider<double?>((ref) {
  final g = ref.watch(genderProvider);
  final leaves = ref.watch(allLeavesProvider).value ?? const [];
  if (g == null) return null;
  return holidayRemaining(leaves, g, DateTime.now().year);
});

final isClockedInProvider = Provider<bool>((ref) {
  final today = ref.watch(todaySessionsProvider).value ?? const [];
  return today.any((s) => s.isOpen);
});
