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

  LeaveRecordModel _toLeaveRecord(LeaveRecord r) => LeaveRecordModel(
        id: r.id,
        category: LeaveCategoryX.fromDb(r.leaveType),
        startDate: r.startDate,
        endDate: r.endDate,
        duration: LeaveTypeX.fromDb(r.duration),
        daysConsumed: r.daysConsumed,
        reason: r.reason,
        appliedOn: r.appliedOn,
      );

  // --- settings ---
  Stream<UserSetting?> watchSettings() => db.watchSettings();

  Future<void> createSettings(Gender gender,
      {DateTime? now, DateTime? joinDate}) async {
    await db.into(db.userSettings).insertOnConflictUpdate(
          UserSettingsCompanion.insert(
            gender: gender.db,
            yearlyHolidayAllocation: 0, // legacy column, unused
            createdAt: now ?? DateTime.now(),
            joinDate: Value(joinDate),
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
    int? monthlyWfhLimit,
    int? yearlyWfhLimit,
    String? displayName,
    Set<int>? weekendDays,
    int? officeStartMin,
    int? officeEndMin,
    bool? ramadanEnabled,
    int? ramadanStartMin,
    int? ramadanEndMin,
    DateTime? joinDate,
    bool clearJoinDate = false,
    bool? biometricLock,
  }) async {
    await (db.update(db.userSettings)..where((t) => t.id.equals(1))).write(
      UserSettingsCompanion(
        gender: gender == null ? const Value.absent() : Value(gender.db),
        monthlyWfhLimit: monthlyWfhLimit == null
            ? const Value.absent()
            : Value(monthlyWfhLimit),
        yearlyWfhLimit: yearlyWfhLimit == null
            ? const Value.absent()
            : Value(yearlyWfhLimit),
        displayName:
            displayName == null ? const Value.absent() : Value(displayName),
        weekendDays: weekendDays == null
            ? const Value.absent()
            : Value((weekendDays.toList()..sort()).join(',')),
        officeStartMin: officeStartMin == null
            ? const Value.absent()
            : Value(officeStartMin),
        officeEndMin:
            officeEndMin == null ? const Value.absent() : Value(officeEndMin),
        ramadanEnabled: ramadanEnabled == null
            ? const Value.absent()
            : Value(ramadanEnabled),
        ramadanStartMin: ramadanStartMin == null
            ? const Value.absent()
            : Value(ramadanStartMin),
        ramadanEndMin: ramadanEndMin == null
            ? const Value.absent()
            : Value(ramadanEndMin),
        joinDate: clearJoinDate
            ? const Value(null)
            : (joinDate == null ? const Value.absent() : Value(joinDate)),
        biometricLock: biometricLock == null
            ? const Value.absent()
            : Value(biometricLock),
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

  Stream<List<LeaveRecordModel>> watchLeaveRecords() =>
      db.watchLeaveRecords().map((rows) => rows.map(_toLeaveRecord).toList());

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

  /// Close a specific (possibly overdue) session at an explicit time.
  Future<void> closeSessionAt(int id, DateTime at) async {
    await (db.update(db.timeLogs)..where((t) => t.id.equals(id)))
        .write(TimeLogsCompanion(clockOut: Value(at)));
  }

  /// Add a session with explicit times (manual / backfill entry).
  Future<void> addSession(
    DateTime clockIn,
    DateTime? clockOut,
    WorkMode mode, {
    String? note,
  }) async {
    await db.into(db.timeLogs).insert(
          TimeLogsCompanion.insert(
            dayKey: dayKey(clockIn),
            clockIn: clockIn,
            clockOut: Value(clockOut),
            workMode: mode.db,
            note: Value(note),
          ),
        );
  }

  /// Edit an existing session.
  Future<void> updateSession(
    int id, {
    required DateTime clockIn,
    DateTime? clockOut,
    required WorkMode mode,
    String? note,
  }) async {
    await (db.update(db.timeLogs)..where((t) => t.id.equals(id))).write(
      TimeLogsCompanion(
        dayKey: Value(dayKey(clockIn)),
        clockIn: Value(clockIn),
        clockOut: Value(clockOut),
        workMode: Value(mode.db),
        note: Value(note),
      ),
    );
  }

  Future<void> deleteSession(int id) async =>
      (db.delete(db.timeLogs)..where((t) => t.id.equals(id))).go();

  // --- leave (typed records) ---
  Future<void> addLeaveRecord({
    required LeaveCategory category,
    required DateTime startDate,
    required DateTime endDate,
    required LeaveType duration,
    required double daysConsumed,
    String? reason,
    DateTime? appliedOn,
  }) async {
    await db.into(db.leaveRecords).insert(
          LeaveRecordsCompanion.insert(
            leaveType: category.db,
            startDate: startDate,
            endDate: endDate,
            duration: duration.db,
            daysConsumed: daysConsumed,
            reason: Value(reason),
            appliedOn: appliedOn ?? DateTime.now(),
          ),
        );
  }

  Future<void> deleteLeaveRecord(int id) async =>
      (db.delete(db.leaveRecords)..where((t) => t.id.equals(id))).go();

  // --- notes ---
  NoteModel _toNote(Note r) => NoteModel(
        id: r.id,
        kind: NoteKindX.fromDb(r.kind),
        date: r.date,
        title: r.title,
        body: r.body,
        tags: r.tags.isEmpty
            ? const []
            : r.tags.split(',').map((e) => e.trim()).toList(),
        checklist: (jsonDecode(r.checklist) as List)
            .map((e) => ChecklistItem.fromJson((e as Map).cast()))
            .toList(),
        pinned: r.pinned,
        updatedAt: r.updatedAt,
      );

  Stream<List<NoteModel>> watchNotes() =>
      db.watchNotes().map((rows) => rows.map(_toNote).toList());

  Future<void> saveNote(NoteModel n) async {
    final companion = NotesCompanion(
      id: n.id == null ? const Value.absent() : Value(n.id!),
      kind: Value(n.kind.db),
      date: Value(n.date),
      title: Value(n.title),
      body: Value(n.body),
      tags: Value(n.tags.join(',')),
      checklist: Value(jsonEncode(n.checklist.map((e) => e.toJson()).toList())),
      pinned: Value(n.pinned),
      updatedAt: Value(DateTime.now()),
    );
    if (n.id == null) {
      await db.into(db.notes).insert(companion);
    } else {
      await (db.update(db.notes)..where((t) => t.id.equals(n.id!)))
          .write(companion);
    }
  }

  Future<void> deleteNote(int id) async =>
      (db.delete(db.notes)..where((t) => t.id.equals(id))).go();

  // --- full backup (JSON) — round-trips every field for phone transfer ---
  /// Serializes settings + all sessions + leaves to a JSON backup string.
  Future<String> exportJson() async {
    final s = await db.settingsOnce();
    final sessions = await db.allTimeLogsOnce();
    final records = await db.leaveRecordsOnce();
    final map = {
      'app': 'ShiftLog',
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': s == null
          ? null
          : {
              'gender': s.gender,
              'yearlyWfhLimit': s.yearlyWfhLimit,
              'monthlyWfhLimit': s.monthlyWfhLimit,
              'displayName': s.displayName,
              'darkMode': s.darkMode,
              'weekendDays': s.weekendDays,
              'officeStartMin': s.officeStartMin,
              'officeEndMin': s.officeEndMin,
              'ramadanEnabled': s.ramadanEnabled,
              'ramadanStartMin': s.ramadanStartMin,
              'ramadanEndMin': s.ramadanEndMin,
              'joinDate': s.joinDate?.toIso8601String(),
              'biometricLock': s.biometricLock,
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
      'leaveRecords': [
        for (final r in records)
          {
            'leaveType': r.leaveType,
            'startDate': r.startDate.toIso8601String(),
            'endDate': r.endDate.toIso8601String(),
            'duration': r.duration,
            'daysConsumed': r.daysConsumed,
            'reason': r.reason,
            'appliedOn': r.appliedOn.toIso8601String(),
          },
      ],
      'overrides': [
        for (final r in await db.overridesOnce())
          {'dayKey': r.dayKey, 'type': r.type},
      ],
      'notes': [
        for (final r in await db.notesOnce())
          {
            'kind': r.kind,
            'date': r.date.toIso8601String(),
            'title': r.title,
            'body': r.body,
            'tags': r.tags,
            'checklist': r.checklist,
            'pinned': r.pinned,
            'updatedAt': r.updatedAt.toIso8601String(),
          },
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
      await db.delete(db.leaveRecords).go();
      await db.delete(db.dayOverrides).go();
      await db.delete(db.notes).go();

      final s = map['settings'] as Map<String, dynamic>?;
      if (s != null) {
        await db.into(db.userSettings).insertOnConflictUpdate(
              UserSettingsCompanion.insert(
                gender: s['gender'] as String,
                yearlyHolidayAllocation: 0,
                createdAt: DateTime.parse(s['createdAt'] as String),
                yearlyWfhLimit: Value(s['yearlyWfhLimit'] as int? ?? 12),
                monthlyWfhLimit: Value(s['monthlyWfhLimit'] as int? ?? 2),
                displayName: Value(s['displayName'] as String?),
                darkMode: Value(s['darkMode'] as bool?),
                weekendDays: Value((s['weekendDays'] as String?) ?? '5,6'),
                officeStartMin: Value(s['officeStartMin'] as int? ?? 570),
                officeEndMin: Value(s['officeEndMin'] as int? ?? 1080),
                ramadanEnabled: Value(s['ramadanEnabled'] as bool? ?? false),
                ramadanStartMin: Value(s['ramadanStartMin'] as int? ?? 570),
                ramadanEndMin: Value(s['ramadanEndMin'] as int? ?? 930),
                joinDate: Value(s['joinDate'] == null
                    ? null
                    : DateTime.parse(s['joinDate'] as String)),
                biometricLock: Value(s['biometricLock'] as bool? ?? false),
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
      for (final j in ((map['leaveRecords'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()) {
        await db.into(db.leaveRecords).insert(
              LeaveRecordsCompanion.insert(
                leaveType: j['leaveType'] as String,
                startDate: DateTime.parse(j['startDate'] as String),
                endDate: DateTime.parse(j['endDate'] as String),
                duration: j['duration'] as String,
                daysConsumed: (j['daysConsumed'] as num).toDouble(),
                reason: Value(j['reason'] as String?),
                appliedOn: DateTime.parse(j['appliedOn'] as String),
              ),
            );
      }
      for (final j in ((map['notes'] as List?) ?? const [])
          .cast<Map<String, dynamic>>()) {
        await db.into(db.notes).insert(
              NotesCompanion(
                kind: Value(j['kind'] as String? ?? 'daily'),
                date: Value(DateTime.parse(j['date'] as String)),
                title: Value(j['title'] as String? ?? ''),
                body: Value(j['body'] as String? ?? ''),
                tags: Value(j['tags'] as String? ?? ''),
                checklist: Value(j['checklist'] as String? ?? '[]'),
                pinned: Value(j['pinned'] as bool? ?? false),
                updatedAt: Value(DateTime.parse(j['updatedAt'] as String)),
              ),
            );
      }
    });
  }

  // --- export ---
  /// Builds a CSV dump of all sessions and leaves for backup/sharing.
  Future<String> exportCsv() async {
    final sessions = await db.allTimeLogsOnce();
    final records = await db.leaveRecordsOnce();
    final b = StringBuffer();
    b.writeln('record_type,date,start,end,detail,minutes_or_days');
    for (final s in sessions) {
      final mins = (s.clockOut ?? s.clockIn).difference(s.clockIn).inMinutes;
      b.writeln('session,${s.dayKey},${s.clockIn.toIso8601String()},'
          '${s.clockOut?.toIso8601String() ?? ''},${s.workMode},$mins');
    }
    for (final l in records) {
      b.writeln('leave,${l.startDate.toIso8601String().substring(0, 10)},'
          '${l.startDate.toIso8601String()},${l.endDate.toIso8601String()},'
          '${l.leaveType},${l.daysConsumed}');
    }
    return b.toString();
  }
}
