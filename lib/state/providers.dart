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

// Effective per-day target (office hours, or Ramadan hours when enabled).
final dailyTargetProvider = Provider<Duration>((ref) {
  final s = ref.watch(settingsProvider).value;
  if (s == null) return const Duration(hours: 8, minutes: 30);
  return effectiveTarget(
    officeStartMin: s.officeStartMin,
    officeEndMin: s.officeEndMin,
    ramadanEnabled: s.ramadanEnabled,
    ramadanStartMin: s.ramadanStartMin,
    ramadanEndMin: s.ramadanEndMin,
  );
});

final displayNameProvider = Provider<String?>((ref) {
  final n = ref.watch(settingsProvider).value?.displayName;
  return (n == null || n.trim().isEmpty) ? null : n.trim();
});

final joinDateProvider = Provider<DateTime?>(
    (ref) => ref.watch(settingsProvider).value?.joinDate);

final profilePhotoProvider = Provider<String?>((ref) {
  final p = ref.watch(settingsProvider).value?.photoPath;
  return (p == null || p.isEmpty) ? null : p;
});

final companyNameProvider = Provider<String?>((ref) {
  final c = ref.watch(settingsProvider).value?.companyName;
  return (c == null || c.trim().isEmpty) ? null : c.trim();
});

final biometricLockProvider = Provider<bool>(
    (ref) => ref.watch(settingsProvider).value?.biometricLock ?? false);

// Weekend weekdays (DateTime weekday numbers), default Fri+Sat.
final weekendProvider = Provider<Set<int>>((ref) =>
    parseWeekend(ref.watch(settingsProvider).value?.weekendDays));

// Per-date working-day overrides: { 'yyyy-MM-dd' : 'off' | 'work' }.
final dayOverridesProvider = StreamProvider<Map<String, String>>(
    (ref) => ref.watch(repositoryProvider).watchDayOverrides());

// --- raw data streams ---
final allSessionsProvider = StreamProvider<List<WorkSession>>(
    (ref) => ref.watch(repositoryProvider).watchAllSessions());

final todaySessionsProvider = StreamProvider<List<WorkSession>>(
    (ref) => ref.watch(repositoryProvider).watchSessionsForDay(dayKey(DateTime.now())));

final leaveRecordsProvider = StreamProvider<List<LeaveRecordModel>>(
    (ref) => ref.watch(repositoryProvider).watchLeaveRecords());

final notesProvider = StreamProvider<List<NoteModel>>(
    (ref) => ref.watch(repositoryProvider).watchNotes());

final foldersProvider = StreamProvider<List<FolderModel>>(
    (ref) => ref.watch(repositoryProvider).watchFolders());

// Day → leave duration map (full/half), expanded from leave records. Used for
// expected-day reduction and calendar markers.
final leaveDaysMapProvider = Provider<Map<String, LeaveType>>((ref) {
  final records = ref.watch(leaveRecordsProvider).value ?? const [];
  final map = <String, LeaveType>{};
  for (final r in records) {
    if (r.duration == LeaveType.half) {
      map[dayKey(r.startDate)] = LeaveType.half;
    } else {
      var d = DateTime(r.startDate.year, r.startDate.month, r.startDate.day);
      final last = DateTime(r.endDate.year, r.endDate.month, r.endDate.day);
      while (!d.isAfter(last)) {
        map[dayKey(d)] = LeaveType.full;
        d = d.add(const Duration(days: 1));
      }
    }
  }
  return map;
});

// --- selected work mode for the NEXT clock-in ---
final selectedModeProvider =
    StateProvider<WorkMode>((ref) => WorkMode.office);

// Bumped whenever the Home tab is (re)selected, so the progress ring replays
// its fill animation each time you land on Home.
final homeRevealProvider = StateProvider<int>((ref) => 0);

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

// Total leave days remaining across all eligible categories this year.
final totalLeaveRemainingProvider = Provider<double>((ref) {
  final g = ref.watch(genderProvider);
  final records = ref.watch(leaveRecordsProvider).value ?? const [];
  final join = ref.watch(joinDateProvider);
  if (g == null) return 0;
  final year = DateTime.now().year;
  return eligibleLeave(g).fold<double>(
      0, (sum, c) => sum + leaveRemaining(records, c, g, join, year));
});

final isClockedInProvider = Provider<bool>((ref) {
  final today = ref.watch(todaySessionsProvider).value ?? const [];
  return today.any((s) => s.isOpen);
});
