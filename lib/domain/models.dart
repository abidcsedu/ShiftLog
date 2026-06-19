import 'enums.dart';

/// Plain, framework-free value types the business logic and UI operate on.
/// The repository maps Drift rows to/from these, keeping `work_logic` pure.
class WorkSession {
  final int? id;
  final String dayKey; // 'yyyy-MM-dd'
  final DateTime clockIn;
  final DateTime? clockOut; // null => currently active
  final WorkMode mode;
  final String? note;

  const WorkSession({
    this.id,
    required this.dayKey,
    required this.clockIn,
    this.clockOut,
    required this.mode,
    this.note,
  });

  bool get isOpen => clockOut == null;
}

/// A typed leave (casual/sick/…) over a date range.
class LeaveRecordModel {
  final int? id;
  final LeaveCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveType duration; // half | full
  final double daysConsumed;
  final String? reason;
  final DateTime appliedOn;

  const LeaveRecordModel({
    this.id,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.daysConsumed,
    this.reason,
    required this.appliedOn,
  });

  int get year => startDate.year;
}
