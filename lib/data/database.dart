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
}

// One row per leave taken.
class LeaveLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayKey => text()(); // 'yyyy-MM-dd'
  TextColumn get type => text()(); // 'half' | 'full'
  TextColumn get note => text().nullable()();
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

@DriftDatabase(tables: [UserSettings, TimeLogs, LeaveLogs, DayOverrides])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'shiftlog'));

  @override
  int get schemaVersion => 4;

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
}
