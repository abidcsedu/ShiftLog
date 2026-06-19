import 'dart:convert';

import 'package:drift/drift.dart'; // Value() for nullable companion fields

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/work_logic.dart';
import 'database.dart';

/// The single data seam. Swap this implementation for a cloud/API client later;
/// the domain logic, providers, and UI stay unchanged.
class Repository {
  final AppDatabase db;
  Repository(this.db);

  // --- mappers: Drift rows <-> framework-free domain models ---
  WorkSession _toSession(TimeLog r) => WorkSession(
        id: r.id,
        dayKey: r.dayKey,
        clockIn: r.clockIn,
        clockOut: r.clockOut,
        mode: WorkModeX.fromDb(r.workMode),
        note: r.note,
      );

  LeaveEntry _toLeave(LeaveLog r) => LeaveEntry(
        id: r.id,
        dayKey: r.dayKey,
        type: LeaveTypeX.fromDb(r.type),
        note: r.note,
      );

  // --- settings ---
  Stream<UserSetting?> watchSettings() => db.watchSettings();

  Future<void> createSettings(Gender gender, {DateTime? now}) async {
    await db.into(db.userSettings).insertOnConflictUpdate(
          UserSettingsCompanion.insert(
            gender: gender.db,
            yearlyHolidayAllocation: allocationFor(gender),
            createdAt: now ?? DateTime.now(),
          ),
        );
  }

  /// Persist the theme preference (true=dark, false=light, null=system).
  Future<void> setDarkMode(bool? dark) async {
    await (db.update(db.userSettings)..where((t) => t.id.equals(1)))
        .write(UserSettingsCompanion(darkMode: Value(dark)));
  }

  /// Update any editable settings field (omitted args are left unchanged).
  Future<void> updateSettings({
    Gender? gender,
    int? yearlyHolidayAllocation,
    int? monthlyWfhLimit,
    int? yearlyWfhLimit,
    int? dailyTargetMinutes,
    String? displayName,
    Set<int>? weekendDays,
  }) async {
    await (db.update(db.userSettings)..where((t) => t.id.equals(1))).write(
      UserSettingsCompanion(
        gender: gender == null ? const Value.absent() : Value(gender.db),
        yearlyHolidayAllocation: yearlyHolidayAllocation == null
            ? const Value.absent()
            : Value(yearlyHolidayAllocation),
        monthlyWfhLimit: monthlyWfhLimit == null
            ? const Value.absent()
            : Value(monthlyWfhLimit),
        yearlyWfhLimit: yearlyWfhLimit == null
            ? const Value.absent()
            : Value(yearlyWfhLimit),
        dailyTargetMinutes: dailyTargetMinutes == null
            ? const Value.absent()
            : Value(dailyTargetMinutes),
        displayName:
            displayName == null ? const Value.absent() : Value(displayName),
        weekendDays: weekendDays == null
            ? const Value.absent()
            : Value((weekendDays.toList()..sort()).join(',')),
      ),
    );
  }

  // --- day-type overrides (swaps / extra holidays) ---
  Stream<Map<String, String>> watchDayOverrides() => db.watchOverrides().map(
      (rows) => {for (final r in rows) r.dayKey: r.type});

  Future<void> setDayOverride(DateTime day, String type) async {
    await db.into(db.dayOverrides).insertOnConflictUpdate(
          DayOverridesCompanion.insert(dayKey: dayKey(day), type: type),
        );
  }

  Future<void> clearDayOverride(DateTime day) async =>
      (db.delete(db.dayOverrides)..where((t) => t.dayKey.equals(dayKey(day))))
          .go();

  // --- streams of domain models ---
  Stream<List<WorkSession>> watchAllSessions() =>
      db.watchAllTimeLogs().map((rows) => rows.map(_toSession).toList());

  Stream<List<WorkSession>> watchSessionsForDay(String key) =>
      db.watchTimeLogsForDay(key).map((rows) => rows.map(_toSession).toList());

  Stream<List<LeaveEntry>> watchAllLeaves() =>
      db.watchAllLeaves().map((rows) => rows.map(_toLeave).toList());

  // --- clock in / out ---
  Future<void> clockIn(WorkMode mode, {DateTime? now}) async {
    final ts = now ?? DateTime.now();
    await db.into(db.timeLogs).insert(
          TimeLogsCompanion.insert(
            dayKey: dayKey(ts),
            clockIn: ts,
            workMode: mode.db,
          ),
        );
  }

  /// Closes the latest open session for today. Returns true if one was closed.
  Future<bool> clockOut({DateTime? now}) async {
    final ts = now ?? DateTime.now();
    final open = await db.openSessionForDay(dayKey(ts));
    if (open == null) return false;
    await (db.update(db.timeLogs)..where((t) => t.id.equals(open.id)))
        .write(TimeLogsCompanion(clockOut: Value(ts)));
    return true;
  }

  /// Add a session with explicit times (manual / backfill entry).
  Future<void> addSession(
    DateTime clockIn,
    DateTime? clockOut,
    WorkMode mode,
  ) async {
    await db.into(db.timeLogs).insert(
          TimeLogsCompanion.insert(
            dayKey: dayKey(clockIn),
            clockIn: clockIn,
            clockOut: Value(clockOut),
            workMode: mode.db,
          ),
        );
  }

  /// Edit an existing session.
  Future<void> updateSession(
    int id, {
    required DateTime clockIn,
    DateTime? clockOut,
    required WorkMode mode,
  }) async {
    await (db.update(db.timeLogs)..where((t) => t.id.equals(id))).write(
      TimeLogsCompanion(
        dayKey: Value(dayKey(clockIn)),
        clockIn: Value(clockIn),
        clockOut: Value(clockOut),
        workMode: Value(mode.db),
      ),
    );
  }

  Future<void> deleteSession(int id) async =>
      (db.delete(db.timeLogs)..where((t) => t.id.equals(id))).go();

  // --- leave ---
  Future<void> logLeave(LeaveType type, DateTime day, {String? note}) async {
    await db.into(db.leaveLogs).insert(
          LeaveLogsCompanion.insert(
            dayKey: dayKey(day),
            type: type.db,
            note: Value(note),
          ),
        );
  }

  Future<void> deleteLeave(int id) async =>
      (db.delete(db.leaveLogs)..where((t) => t.id.equals(id))).go();

  // --- full backup (JSON) — round-trips every field for phone transfer ---
  /// Serializes settings + all sessions + leaves to a JSON backup string.
  Future<String> exportJson() async {
    final s = await db.settingsOnce();
    final sessions = await db.allTimeLogsOnce();
    final leaves = await db.allLeavesOnce();
    final map = {
      'app': 'ShiftLog',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': s == null
          ? null
          : {
              'gender': s.gender,
              'yearlyHolidayAllocation': s.yearlyHolidayAllocation,
              'yearlyWfhLimit': s.yearlyWfhLimit,
              'monthlyWfhLimit': s.monthlyWfhLimit,
              'dailyTargetMinutes': s.dailyTargetMinutes,
              'displayName': s.displayName,
              'darkMode': s.darkMode,
              'weekendDays': s.weekendDays,
              'createdAt': s.createdAt.toIso8601String(),
            },
      'sessions': [
        for (final r in sessions)
          {
            'dayKey': r.dayKey,
            'clockIn': r.clockIn.toIso8601String(),
            'clockOut': r.clockOut?.toIso8601String(),
            'workMode': r.workMode,
            'note': r.note,
          },
      ],
      'leaves': [
        for (final r in leaves)
          {'dayKey': r.dayKey, 'type': r.type, 'note': r.note},
      ],
      'overrides': [
        for (final r in await db.overridesOnce())
          {'dayKey': r.dayKey, 'type': r.type},
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Replaces ALL local data with the contents of a JSON backup.
  /// Throws [FormatException] if the file isn't a valid ShiftLog backup.
  Future<void> importJson(String text) async {
    final dynamic parsed = jsonDecode(text);
    if (parsed is! Map || parsed['app'] != 'ShiftLog') {
      throw const FormatException('Not a ShiftLog backup file.');
    }
    final map = parsed.cast<String, dynamic>();
    await db.transaction(() async {
      await db.delete(db.timeLogs).go();
      await db.delete(db.leaveLogs).go();
      await db.delete(db.dayOverrides).go();

      final s = map['settings'] as Map<String, dynamic>?;
      if (s != null) {
        await db.into(db.userSettings).insertOnConflictUpdate(
              UserSettingsCompanion.insert(
                gender: s['gender'] as String,
                yearlyHolidayAllocation: s['yearlyHolidayAllocation'] as int,
                createdAt: DateTime.parse(s['createdAt'] as String),
                yearlyWfhLimit: Value(s['yearlyWfhLimit'] as int),
                monthlyWfhLimit: Value(s['monthlyWfhLimit'] as int),
                dailyTargetMinutes: Value(s['dailyTargetMinutes'] as int),
                displayName: Value(s['displayName'] as String?),
                darkMode: Value(s['darkMode'] as bool?),
                weekendDays: Value(
                    (s['weekendDays'] as String?) ?? '5,6'),
              ),
            );
      }
      for (final j in ((map['overrides'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()) {
        await db.into(db.dayOverrides).insert(
              DayOverridesCompanion.insert(
                dayKey: j['dayKey'] as String,
                type: j['type'] as String,
              ),
            );
      }
      for (final j in (map['sessions'] as List).cast<Map<String, dynamic>>()) {
        await db.into(db.timeLogs).insert(
              TimeLogsCompanion.insert(
                dayKey: j['dayKey'] as String,
                clockIn: DateTime.parse(j['clockIn'] as String),
                clockOut: Value(j['clockOut'] == null
                    ? null
                    : DateTime.parse(j['clockOut'] as String)),
                workMode: j['workMode'] as String,
                note: Value(j['note'] as String?),
              ),
            );
      }
      for (final j in (map['leaves'] as List).cast<Map<String, dynamic>>()) {
        await db.into(db.leaveLogs).insert(
              LeaveLogsCompanion.insert(
                dayKey: j['dayKey'] as String,
                type: j['type'] as String,
                note: Value(j['note'] as String?),
              ),
            );
      }
    });
  }

  // --- export ---
  /// Builds a CSV dump of all sessions and leaves for backup/sharing.
  Future<String> exportCsv() async {
    final sessions = await db.allTimeLogsOnce();
    final leaves = await db.allLeavesOnce();
    final b = StringBuffer();
    b.writeln('record_type,date,start,end,mode_or_type,minutes');
    for (final s in sessions) {
      final mins = (s.clockOut ?? s.clockIn).difference(s.clockIn).inMinutes;
      b.writeln('session,${s.dayKey},${s.clockIn.toIso8601String()},'
          '${s.clockOut?.toIso8601String() ?? ''},${s.workMode},$mins');
    }
    for (final l in leaves) {
      b.writeln('leave,${l.dayKey},,,${l.type},');
    }
    return b.toString();
  }
}
