import 'package:flutter_test/flutter_test.dart';
import 'package:shiftlog/domain/enums.dart';
import 'package:shiftlog/domain/models.dart';
import 'package:shiftlog/domain/work_logic.dart';

WorkSession session(String day, int h1, int m1, int? h2, int? m2,
    {WorkMode mode = WorkMode.office}) {
  final parts = day.split('-').map(int.parse).toList();
  final d = DateTime(parts[0], parts[1], parts[2]);
  return WorkSession(
    dayKey: day,
    clockIn: d.add(Duration(hours: h1, minutes: m1)),
    clockOut: h2 == null ? null : d.add(Duration(hours: h2, minutes: m2!)),
    mode: mode,
  );
}

LeaveEntry leave(String day, LeaveType t) => LeaveEntry(dayKey: day, type: t);

void main() {
  group('totalForDay', () {
    test('sums multiple sessions (6h + 2h = 8h)', () {
      final s = [
        session('2026-06-19', 9, 0, 15, 0), // 6h
        session('2026-06-19', 17, 0, 19, 0), // 2h
      ];
      expect(totalForDay(s).inHours, 8);
    });

    test('open session counts up to now', () {
      final now = DateTime(2026, 6, 19, 12, 0);
      final s = [session('2026-06-19', 9, 0, null, null)]; // open at 09:00
      expect(totalForDay(s, now: now).inHours, 3);
    });
  });

  group('WFH limits (day-level)', () {
    final base = [
      session('2026-06-01', 9, 0, 17, 0, mode: WorkMode.wfh),
      session('2026-06-10', 9, 0, 17, 0, mode: WorkMode.wfh),
    ];

    test('3rd WFH day in a month is blocked', () {
      final r = canMarkWfh(base, DateTime(2026, 6, 15), 2, 12);
      expect(r, contains('Monthly'));
    });

    test('re-marking an already-WFH day is a no-op (allowed)', () {
      final r = canMarkWfh(base, DateTime(2026, 6, 10), 2, 12);
      expect(r, isNull);
    });

    test('13th WFH day in a year is blocked', () {
      final logs = [
        for (var m = 1; m <= 12; m++)
          session('2026-${m.toString().padLeft(2, '0')}-05', 9, 0, 17, 0,
              mode: WorkMode.wfh),
      ];
      final r = canMarkWfh(logs, DateTime(2026, 12, 20), 2, 12);
      expect(r, contains('Yearly'));
    });

    test('outside-office sessions do not count', () {
      final logs = [
        session('2026-06-01', 9, 0, 17, 0, mode: WorkMode.outside),
        session('2026-06-02', 9, 0, 17, 0, mode: WorkMode.outside),
      ];
      expect(wfhDaysInMonth(logs, 2026, 6), 0);
    });
  });

  group('holidayRemaining', () {
    test('female start 30; one full + one half => 28.5', () {
      final leaves = [
        leave('2026-03-01', LeaveType.full),
        leave('2026-04-01', LeaveType.half),
      ];
      expect(holidayRemaining(leaves, Gender.female, 2026), 28.5);
    });

    test('male starts at 25', () {
      expect(holidayRemaining([], Gender.male, 2026), 25);
    });

    test('prior-year leaves do not reduce current-year balance', () {
      final leaves = [leave('2025-12-31', LeaveType.full)];
      expect(holidayRemaining(leaves, Gender.male, 2026), 25);
    });
  });

  group('expectedWorkingDays (Sun–Thu, Fri+Sat weekend)', () {
    // June 2026: 1st = Monday; 5th = Friday; 6th = Saturday; 7th = Sunday.
    const weekend = {5, 6}; // Fri, Sat

    test('counts weekdays up to today only', () {
      final n = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {}, workedDays: const {},
        today: DateTime(2026, 6, 2), // Tue
      );
      expect(n, 2.0); // Mon 1 + Tue 2
    });

    test('weekend counts only if actually worked', () {
      final notWorked = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {}, workedDays: const {},
        today: DateTime(2026, 6, 6), // Sat
      );
      expect(notWorked, 4.0); // Mon–Thu only; Fri & Sat weekend, unworked
      final workedSat = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {}, workedDays: const {'2026-06-06'},
        today: DateTime(2026, 6, 6),
      );
      expect(workedSat, 5.0); // + the worked Saturday
    });

    test("'off' override removes a weekday; 'work' adds a weekend", () {
      final off = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {'2026-06-01': 'off'}, workedDays: const {},
        today: DateTime(2026, 6, 2),
      );
      expect(off, 1.0); // Mon 1 off, Tue 2 working
      final work = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {'2026-06-05': 'work'}, workedDays: const {},
        today: DateTime(2026, 6, 5), // Fri
      );
      expect(work, 5.0); // Mon–Thu (4) + designated Fri
    });

    test('leaves reduce expected days (full=−1, half=−0.5)', () {
      final n = expectedWorkingDays(
        year: 2026, month: 6, weekend: weekend,
        overrides: const {}, workedDays: const {},
        leaves: const {'2026-06-01': LeaveType.full, '2026-06-02': LeaveType.half},
        today: DateTime(2026, 6, 2),
      );
      expect(n, 0.5); // Mon full leave (0) + Tue half leave (0.5)
    });
  });

  group('monthlyStats (target = expected days × 8.5h)', () {
    test('surplus when hours exceed expected-day target', () {
      final logs = [
        session('2026-06-01', 9, 0, 18, 0), // Mon 9h
        session('2026-06-02', 9, 0, 18, 0), // Tue 9h
      ];
      final s = monthlyStats(logs, 2026, 6, now: DateTime(2026, 6, 2));
      expect(s.daysWorked, 2);
      expect(s.expectedDays, 2.0);
      expect(s.total, const Duration(hours: 18));
      expect(s.target, const Duration(hours: 17)); // 2 × 8.5h
      expect(s.delta, const Duration(hours: 1));
      expect(s.meetsTarget, isTrue);
    });

    test('marking a day off lowers the required hours', () {
      final logs = [session('2026-06-02', 9, 0, 17, 30)]; // Tue 8.5h
      final s = monthlyStats(logs, 2026, 6,
          now: DateTime(2026, 6, 2),
          overrides: const {'2026-06-01': 'off'});
      expect(s.expectedDays, 1.0); // Mon off, only Tue expected
      expect(s.target, const Duration(hours: 8, minutes: 30));
      expect(s.meetsTarget, isTrue);
    });

    test('monthsWithData lists distinct months newest-first', () {
      final logs = [
        session('2026-06-01', 9, 0, 10, 0),
        session('2026-04-15', 9, 0, 10, 0),
        session('2026-06-20', 9, 0, 10, 0),
      ];
      expect(monthsWithData(logs),
          [(year: 2026, month: 6), (year: 2026, month: 4)]);
    });
  });

  group('formatters', () {
    test('formatDurationHms includes seconds', () {
      expect(formatDurationHms(const Duration(hours: 1, minutes: 2, seconds: 9)),
          '1h 02m 09s');
    });
    test('formatSignedDuration prefixes sign', () {
      expect(formatSignedDuration(const Duration(hours: 5, minutes: 30)),
          '+5h 30m');
      expect(formatSignedDuration(const Duration(hours: -3)), '-3h 00m');
    });
    test('formatTime uses 12-hour clock', () {
      expect(formatTime(DateTime(2026, 6, 19, 15, 8)), '3:08 PM');
      expect(formatTime(DateTime(2026, 6, 19, 0, 5)), '12:05 AM');
    });
  });
}
