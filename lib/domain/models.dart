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
  final int id; // stable id (also used as the reminder notification id); 0 = none
  final String text;
  final bool done;
  final DateTime? due; // optional due date/time
  final int priority; // 0 none, 1 low, 2 medium, 3 high
  final String? recurrence; // null | 'daily' | 'weekday' | 'weekly' | 'monthly'
  final List<ChecklistItem> children; // one level of subtasks
  const ChecklistItem(this.text,
      {this.id = 0,
      this.done = false,
      this.due,
      this.priority = 0,
      this.recurrence,
      this.children = const []});

  Map<String, dynamic> toJson() => {
        if (id != 0) 'id': id,
        'text': text,
        'done': done,
        if (due != null) 'due': due!.toIso8601String(),
        if (priority != 0) 'priority': priority,
        if (recurrence != null) 'recurrence': recurrence,
        if (children.isNotEmpty)
          'children': children.map((c) => c.toJson()).toList(),
      };
  static ChecklistItem fromJson(Map<String, dynamic> j) => ChecklistItem(
        j['text'] as String? ?? '',
        id: j['id'] as int? ?? 0,
        done: j['done'] as bool? ?? false,
        due: j['due'] == null ? null : DateTime.tryParse(j['due'] as String),
        priority: j['priority'] as int? ?? 0,
        recurrence: j['recurrence'] as String?,
        children: ((j['children'] as List?) ?? const [])
            .map((e) => ChecklistItem.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
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
  final String kind; // 'daily' | 'meeting' | a custom type name
  final DateTime date;
  final String title;
  final String body;
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
    this.checklist = const [],
    this.pinned = false,
    this.folderId,
    required this.updatedAt,
  });
}
