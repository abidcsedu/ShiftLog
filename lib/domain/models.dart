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
  final String? project;

  const WorkSession({
    this.id,
    required this.dayKey,
    required this.clockIn,
    this.clockOut,
    required this.mode,
    this.note,
    this.project,
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

class ChecklistItem {
  final String text;
  final bool done;
  const ChecklistItem(this.text, {this.done = false});

  ChecklistItem copyWith({String? text, bool? done}) =>
      ChecklistItem(text ?? this.text, done: done ?? this.done);

  Map<String, dynamic> toJson() => {'text': text, 'done': done};
  static ChecklistItem fromJson(Map<String, dynamic> j) =>
      ChecklistItem(j['text'] as String? ?? '', done: j['done'] as bool? ?? false);
}

/// A work note — daily journal or meeting note — with optional action items.
class NoteModel {
  final int? id;
  final NoteKind kind;
  final DateTime date;
  final String title;
  final String body;
  final List<String> tags;
  final List<ChecklistItem> checklist;
  final bool pinned;
  final DateTime updatedAt;

  const NoteModel({
    this.id,
    required this.kind,
    required this.date,
    required this.title,
    required this.body,
    this.tags = const [],
    this.checklist = const [],
    this.pinned = false,
    required this.updatedAt,
  });
}
