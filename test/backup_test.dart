import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiftlog/data/database.dart';
import 'package:shiftlog/data/repository.dart';
import 'package:shiftlog/domain/enums.dart';
import 'package:shiftlog/domain/work_logic.dart';

void main() {
  test('JSON backup round-trips settings, sessions and leaves', () async {
    // Source device with some data.
    final srcDb = AppDatabase(NativeDatabase.memory());
    final src = Repository(srcDb);
    await src.createSettings(Gender.female);
    await src.updateSettings(displayName: 'Abid', officeEndMin: 1110);
    await src.addSession(
      DateTime(2026, 6, 1, 9),
      DateTime(2026, 6, 1, 17),
      WorkMode.wfh,
    );
    await src.addSession(
      DateTime(2026, 6, 2, 9),
      DateTime(2026, 6, 2, 18),
      WorkMode.office,
    );
    await src.addLeaveRecord(
      category: LeaveCategory.casual,
      startDate: DateTime(2026, 6, 3),
      endDate: DateTime(2026, 6, 3),
      duration: LeaveType.full,
      daysConsumed: 1,
    );

    final json = await src.exportJson();

    // Fresh "new phone" device imports the backup.
    final dstDb = AppDatabase(NativeDatabase.memory());
    final dst = Repository(dstDb);
    await dst.importJson(json);

    final sessions = await dst.watchAllSessions().first;
    final leaves = await dst.watchLeaveRecords().first;
    final settings = await dstDb.settingsOnce();

    expect(sessions.length, 2);
    expect(leaves.length, 1);
    expect(leaves.first.category, LeaveCategory.casual);
    expect(wfhDaysInMonth(sessions, 2026, 6), 1);
    expect(settings!.displayName, 'Abid');
    expect(settings.gender, 'female');
    expect(settings.officeEndMin, 1110);
    // A WFH session preserved its mode and times.
    final wfh = sessions.firstWhere((s) => s.mode == WorkMode.wfh);
    expect(wfh.clockIn, DateTime(2026, 6, 1, 9));
    expect(wfh.clockOut, DateTime(2026, 6, 1, 17));

    await srcDb.close();
    await dstDb.close();
  });

  test('importJson rejects a non-ShiftLog file', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final repo = Repository(db);
    expect(() => repo.importJson('{"app":"SomethingElse"}'),
        throwsA(isA<FormatException>()));
    await db.close();
  });
}
