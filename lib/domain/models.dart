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

class ChecklistItem {
  final String text;
  final bool done;
  final DateTime? due; // optional due date/time
  final int priority; // 0 none, 1 low, 2 medium, 3 high
  const ChecklistItem(this.text,
      {this.done = false, this.due, this.priority = 0});

  ChecklistItem copyWith({String? text, bool? done, DateTime? due, int? priority}) =>
      ChecklistItem(text ?? this.text,
          done: done ?? this.done,
          due: due ?? this.due,
          priority: priority ?? this.priority);

  Map<String, dynamic> toJson() => {
        'text': text,
        'done': done,
        if (due != null) 'due': due!.toIso8601String(),
        if (priority != 0) 'priority': priority,
      };
  static ChecklistItem fromJson(Map<String, dynamic> j) => ChecklistItem(
        j['text'] as String? ?? '',
        done: j['done'] as bool? ?? false,
        due: j['due'] == null ? null : DateTime.tryParse(j['due'] as String),
        priority: j['priority'] as int? ?? 0,
      );
}

/// A note folder (subfolders link via [parentId]; null = top level).
class FolderModel {
  final int? id;
  final String name;
  final int? parentId;
  const FolderModel({this.id, required this.name, this.parentId});
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
  final int? folderId; // null = unfiled
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
    this.folderId,
    required this.updatedAt,
  });
}
