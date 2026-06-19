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

class LeaveEntry {
  final int? id;
  final String dayKey; // 'yyyy-MM-dd'
  final LeaveType type;
  final String? note;

  const LeaveEntry({
    this.id,
    required this.dayKey,
    required this.type,
    this.note,
  });
}
