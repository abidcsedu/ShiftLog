import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Single-row settings (id always = 1).
class UserSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get gender => text()(); // 'male' | 'female'
  IntColumn get yearlyHolidayAllocation => integer()(); // 25 or 30
  IntColumn get yearlyWfhLimit => integer().withDefault(const Constant(12))();
  IntColumn get monthlyWfhLimit => integer().withDefault(const Constant(2))();
  DateTimeColumn get createdAt => dateTime()();
  // null => follow the system theme; true => dark; false => light.
  BoolColumn get darkMode => boolean().nullable()();
  TextColumn get displayName => text().nullable()();
  // Required average per worked day, in minutes (default 8h 30m = 510).
  IntColumn get dailyTargetMinutes =>
      integer().withDefault(const Constant(510))();
  // Weekend weekdays as a CSV of DateTime weekday numbers (Mon=1..Sun=7).
  // Default '5,6' = Friday + Saturday.
  TextColumn get weekendDays =>
      text().withDefault(const Constant('5,6'))();
  // Office hours as minutes-from-midnight; the daily target = end - start.
  IntColumn get officeStartMin =>
      integer().withDefault(const Constant(570))(); // 9:30
  IntColumn get officeEndMin =>
      integer().withDefault(const Constant(1080))(); // 18:00
  // Ramadan alternate schedule (a shorter target while enabled).
  BoolColumn get ramadanEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get ramadanStartMin =>
      integer().withDefault(const Constant(570))(); // 9:30
  IntColumn get ramadanEndMin =>
      integer().withDefault(const Constant(930))(); // 15:30 (6h)
  // Join date (for pro-rata leave entitlement + tenure).
  DateTimeColumn get joinDate => dateTime().nullable()();
  // Employee profile fields.
  DateTimeColumn get dob => dateTime().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get officeId => text().nullable()();
  TextColumn get companyName => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  // Require device biometric/PIN to open the app.
  BoolColumn get biometricLock =>
      boolean().withDefault(const Constant(false))();
  // Scheduled reminders.
  BoolColumn get remindClockIn =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get remindClockOut =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get remindWeekly =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// One row per clock-in/out SESSION. A day = many sessions.
class TimeLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayKey => text()(); // 'yyyy-MM-dd' (local)
  DateTimeColumn get clockIn => dateTime()();
  DateTimeColumn get clockOut => dateTime().nullable()(); // null = active
  TextColumn get workMode => text()(); // 'office' | 'wfh' | 'outside'
  TextColumn get note => text().nullable()();
  TextColumn get project => text().nullable()(); // project / client / ticket
}

// One row per leave taken.
class LeaveLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayKey => text()(); // 'yyyy-MM-dd'
  TextColumn get type => text()(); // 'half' | 'full'
  TextColumn get note => text().nullable()();
}

// Typed leave records (casual / sick / maternity / parental) with date ranges.
class LeaveRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get leaveType => text()(); // 'casual'|'sick'|'maternity'|'parental'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get duration => text()(); // 'full' | 'half'
  RealColumn get daysConsumed => real()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get appliedOn => dateTime()();
}

// User-defined note types (in addition to the built-in 'daily'/'meeting').
class NoteTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// Folders (and subfolders via parentId) that organise notes.
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get parentId => integer().nullable()(); // null = top level
  DateTimeColumn get createdAt => dateTime()();
}

// Work-contextual notes: a daily journal entry or a meeting note.
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()(); // 'daily' | 'meeting'
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant(''))(); // CSV
  // Action items as a JSON array of {"text":..,"done":bool}.
  TextColumn get checklist => text().withDefault(const Constant('[]'))();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  IntColumn get folderId => integer().nullable()(); // null = unfiled
  DateTimeColumn get updatedAt => dateTime()();
}

// Per-date working-day overrides for swaps/extra holidays.
// type: 'off' (a normal working day given as holiday) |
//       'work' (a weekend day designated as a working day).
class DayOverrides extends Table {
  TextColumn get dayKey => text()(); // 'yyyy-MM-dd'
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {dayKey};
}

@DriftDatabase(tables: [
  UserSettings,
  TimeLogs,
  LeaveLogs,
  DayOverrides,
  LeaveRecords,
  Notes,
  Folders,
  NoteTypes
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'shiftlog'));

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(userSettings, userSettings.darkMode);
          }
          if (from < 3) {
            await m.addColumn(userSettings, userSettings.displayName);
            await m.addColumn(userSettings, userSettings.dailyTargetMinutes);
          }
          if (from < 4) {
            await m.addColumn(userSettings, userSettings.weekendDays);
            await m.createTable(dayOverrides);
          }
          if (from < 5) {
            await m.addColumn(userSettings, userSettings.officeStartMin);
            await m.addColumn(userSettings, userSettings.officeEndMin);
            await m.addColumn(userSettings, userSettings.ramadanEnabled);
            await m.addColumn(userSettings, userSettings.ramadanStartMin);
            await m.addColumn(userSettings, userSettings.ramadanEndMin);
            await m.addColumn(userSettings, userSettings.joinDate);
            await m.addColumn(userSettings, userSettings.biometricLock);
            await m.createTable(leaveRecords);
          }
          if (from < 6) {
            await m.createTable(notes);
          }
          if (from < 7) {
            await m.addColumn(timeLogs, timeLogs.project);
          }
          if (from < 8) {
            await m.addColumn(userSettings, userSettings.remindClockIn);
            await m.addColumn(userSettings, userSettings.remindClockOut);
            await m.addColumn(userSettings, userSettings.remindWeekly);
          }
          if (from < 9) {
            await m.createTable(folders);
            await m.addColumn(notes, notes.folderId);
          }
          if (from < 10) {
            await m.addColumn(userSettings, userSettings.dob);
            await m.addColumn(userSettings, userSettings.phone);
            await m.addColumn(userSettings, userSettings.officeId);
            await m.addColumn(userSettings, userSettings.companyName);
            await m.addColumn(userSettings, userSettings.photoPath);
          }
          if (from < 11) {
            await m.createTable(noteTypes);
          }
        },
      );

  // Reactive streams used by the UI.
  Stream<UserSetting?> watchSettings() =>
      (select(userSettings)..where((t) => t.id.equals(1)))
          .watchSingleOrNull();

  Stream<List<TimeLog>> watchAllTimeLogs() =>
      (select(timeLogs)..orderBy([(t) => OrderingTerm.desc(t.clockIn)]))
          .watch();

  Stream<List<TimeLog>> watchTimeLogsForDay(String dayKey) =>
      (select(timeLogs)
            ..where((t) => t.dayKey.equals(dayKey))
            ..orderBy([(t) => OrderingTerm.asc(t.clockIn)]))
          .watch();

  Stream<List<LeaveLog>> watchAllLeaves() =>
      (select(leaveLogs)..orderBy([(t) => OrderingTerm.desc(t.dayKey)]))
          .watch();

  Future<TimeLog?> openSessionForDay(String dayKey) =>
      (select(timeLogs)
            ..where((t) => t.dayKey.equals(dayKey) & t.clockOut.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.clockIn)])
            ..limit(1))
          .getSingleOrNull();

  // One-shot fetches (CSV / JSON export).
  Future<List<TimeLog>> allTimeLogsOnce() =>
      (select(timeLogs)..orderBy([(t) => OrderingTerm.asc(t.clockIn)])).get();

  Future<List<LeaveLog>> allLeavesOnce() =>
      (select(leaveLogs)..orderBy([(t) => OrderingTerm.asc(t.dayKey)])).get();

  Future<UserSetting?> settingsOnce() =>
      (select(userSettings)..where((t) => t.id.equals(1))).getSingleOrNull();

  Stream<List<DayOverride>> watchOverrides() => select(dayOverrides).watch();
  Future<List<DayOverride>> overridesOnce() => select(dayOverrides).get();

  Stream<List<LeaveRecord>> watchLeaveRecords() =>
      (select(leaveRecords)..orderBy([(t) => OrderingTerm.desc(t.appliedOn)]))
          .watch();
  Future<List<LeaveRecord>> leaveRecordsOnce() => select(leaveRecords).get();

  Stream<List<Note>> watchNotes() => (select(notes)
        ..orderBy([
          (t) => OrderingTerm.desc(t.pinned),
          (t) => OrderingTerm.desc(t.date),
        ]))
      .watch();
  Future<List<Note>> notesOnce() => select(notes).get();

  Stream<List<Folder>> watchFolders() =>
      (select(folders)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  Future<List<Folder>> foldersOnce() => select(folders).get();

  Stream<List<NoteType>> watchNoteTypes() =>
      (select(noteTypes)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();
  Future<List<NoteType>> noteTypesOnce() => select(noteTypes).get();
}
