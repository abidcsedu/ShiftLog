import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../domain/work_logic.dart';
import '../services/notification_service.dart';
import '../state/providers.dart';
import 'theme.dart';
import 'widgets/folder_picker.dart';

/// Full-screen editor for a daily/meeting note with a folder, editable
/// action-item checklist, and a seamless title + body writing surface.
class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? existing;
  final int? initialFolderId;
  const NoteEditorScreen({super.key, this.existing, this.initialFolderId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

/// One editable checklist row: text controller + id / done / due / priority,
/// plus an optional one level of subtasks.
class _ChecklistEntry {
  final int id;
  final TextEditingController controller;
  bool done;
  DateTime? due;
  int priority;
  String? recurrence;
  final List<_ChecklistEntry> children;
  _ChecklistEntry(String text,
      {required this.id,
      this.done = false,
      this.due,
      this.priority = 0,
      this.recurrence,
      List<_ChecklistEntry>? children})
      : controller = TextEditingController(text: text),
        children = children ?? [];
  void dispose() {
    controller.dispose();
    for (final c in children) {
      c.dispose();
    }
  }
}

/// A positive 31-bit id (also usable as an Android notification id).
int _newItemId() =>
    DateTime.now().microsecondsSinceEpoch & 0x7FFFFFFF;

const _priorityColors = [
  null, // 0 none
  Color(0xFF3B82F6), // 1 low — blue
  Color(0xFFF59E0B), // 2 medium — amber
  Color(0xFFDC2626), // 3 high — red
];
const _priorityLabels = ['None', 'Low', 'Medium', 'High'];

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen>
    with WidgetsBindingObserver {
  late String _kind;
  late DateTime _date;
  late int? _folderId;
  int? _id; // tracks the saved row so re-saves update instead of duplicating
  late final TextEditingController _title;
  late final TextEditingController _body;
  String _prevBody = '';
  late List<_ChecklistEntry> _items;
  late bool _pinned;
  final _newItem = TextEditingController();
  final _newItemFocus = FocusNode();
  // Item ids we've scheduled/seen, so stale reminders get cancelled on save.
  final Set<int> _seenItemIds = {};
  bool _addingTask = false; // reveals the task section on demand

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final e = widget.existing;
    _id = e?.id;
    _kind = e?.kind ?? kNoteDaily;
    _date = e?.date ?? DateTime.now();
    _folderId = e?.folderId ?? widget.initialFolderId;
    _title = TextEditingController(text: e?.title ?? '');
    _body = TextEditingController(text: e?.body ?? '');
    _prevBody = _body.text;
    _body.addListener(_onBodyChanged);
    _items = [
      for (final c in (e?.checklist ?? const <ChecklistItem>[]))
        _entryFrom(c),
    ];
    for (final it in _items) {
      _seenItemIds.add(it.id);
      _seenItemIds.addAll(it.children.map((c) => c.id));
    }
    _pinned = e?.pinned ?? false;
  }

  /// Builds an editable entry (and its subtasks) from a stored item, assigning
  /// fresh ids to any legacy items that lack one.
  _ChecklistEntry _entryFrom(ChecklistItem c) => _ChecklistEntry(
        c.text,
        id: c.id == 0 ? _newItemId() : c.id,
        done: c.done,
        due: c.due,
        priority: c.priority,
        recurrence: c.recurrence,
        children: [for (final sc in c.children) _entryFrom(sc)],
      );

  /// Toggle done — but completing a recurring item with a due date rolls it
  /// forward to the next occurrence instead of just checking it off.
  void _toggleEntry(_ChecklistEntry e) {
    setState(() {
      if (!e.done && e.recurrence != null && e.due != null) {
        e.due = nextDue(e.due!, e.recurrence!);
      } else {
        e.done = !e.done;
      }
    });
  }

  /// Wraps a task row: swipe right to complete, swipe left to delete.
  Widget _swipeRow(_ChecklistEntry e, VoidCallback onDelete, Widget child) {
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey('dz-${e.id}'),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 22),
        color: const Color(0xFF16A34A),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        color: scheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          _toggleEntry(e);
          return false; // complete, but keep the row
        }
        return true; // swipe-left → delete
      },
      onDismissed: (_) => onDelete(),
      child: child,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _title.dispose();
    _body.dispose();
    _newItem.dispose();
    _newItemFocus.dispose();
    for (final it in _items) {
      it.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Persist if the app is backgrounded/closed while editing, so nothing
    // (including just-added/edited action items) is lost.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _persist();
    }
  }

  /// Moves any text still sitting in the "add action item" field into the list.
  void _flushPendingItem() {
    final t = _newItem.text.trim();
    if (t.isEmpty) return;
    _items.add(_ChecklistEntry(t, id: _newItemId()));
    _newItem.clear();
  }

  /// Current non-empty checklist items, read live from their controllers.
  ChecklistItem _collect(_ChecklistEntry it, {bool withChildren = true}) =>
      ChecklistItem(it.controller.text.trim(),
          id: it.id,
          done: it.done,
          due: it.due,
          priority: it.priority,
          recurrence: it.recurrence,
          children: withChildren
              ? [
                  for (final c in it.children)
                    if (c.controller.text.trim().isNotEmpty) _collect(c)
                ]
              : const []);

  List<ChecklistItem> _collectItems() => [
        for (final it in _items)
          if (it.controller.text.trim().isNotEmpty) _collect(it),
      ];

  /// (Re)schedule due reminders for the current items (and subtasks); cancel
  /// any that were removed, completed, cleared, or moved to the past.
  Future<void> _syncItemReminders(List<ChecklistItem> items) async {
    final notif = NotificationService();
    for (final id in _seenItemIds) {
      await notif.cancelItemReminder(id);
    }
    Future<void> schedule(ChecklistItem it) async {
      _seenItemIds.add(it.id);
      if (!it.done && it.due != null) {
        await notif.scheduleItemReminder(it.id, it.text, it.due!);
      }
      for (final c in it.children) {
        await schedule(c);
      }
    }

    for (final it in items) {
      await schedule(it);
    }
  }

  /// Writes the note to the database without navigating. Safe to call on back,
  /// on app background, etc. Deletes the row if the note is now empty.
  Future<void> _persist() async {
    _flushPendingItem();
    final items = _collectItems();
    final repo = ref.read(repositoryProvider);
    final empty = _title.text.trim().isEmpty &&
        _body.text.trim().isEmpty &&
        items.isEmpty;
    if (empty) {
      if (_id != null) {
        await repo.deleteNote(_id!);
        _id = null;
      }
      await _syncItemReminders(const []); // cancel any scheduled reminders
      return;
    }
    final id = await repo.saveNote(NoteModel(
      id: _id,
      kind: _kind,
      date: _date,
      title: _title.text.trim(),
      body: _body.text.trim(),
      checklist: items,
      pinned: _pinned,
      folderId: _folderId,
      updatedAt: DateTime.now(),
    ));
    _id = id; // keep editing the same row on subsequent saves
    await _syncItemReminders(items);
  }

  Future<void> _save() async {
    await _persist();
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (_id != null) await ref.read(repositoryProvider).deleteNote(_id!);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickFolder() async {
    final result = await showFolderPicker(context, ref, selected: _folderId);
    if (result != null) setState(() => _folderId = result.id);
  }

  /// Choose the note type — built-ins, any custom types, or add a new one.
  Future<void> _pickType() async {
    final custom = ref.read(noteTypesProvider).value ?? const [];
    final types = [kNoteDaily, kNoteMeeting, ...custom];
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in types)
              ListTile(
                leading: Icon(noteTypeVisual(t).icon,
                    color: noteTypeVisual(t).color),
                title: Text(noteTypeLabel(t)),
                trailing: _kind == t ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, t),
              ),
            ListTile(
              leading: Icon(Icons.add,
                  color: Theme.of(ctx).colorScheme.primary),
              title: Text('New type',
                  style:
                      TextStyle(color: Theme.of(ctx).colorScheme.primary)),
              onTap: () async {
                final name = await promptFolderName(ctx, title: 'New note type');
                if (name == null) return;
                await ref.read(repositoryProvider).createNoteType(name);
                if (ctx.mounted) Navigator.pop(ctx, name);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _kind = result);
  }

  void _addItem() {
    final t = _newItem.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _items.add(_ChecklistEntry(t, id: _newItemId()));
      _newItem.clear();
    });
    // Keep the field focused so the keyboard stays up for the next task.
    _newItemFocus.requestFocus();
  }

  Future<void> _pickItemDue(_ChecklistEntry it) async {
    final d = await showDatePicker(
      context: context,
      initialDate: it.due ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Due date',
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: it.due == null
          ? const TimeOfDay(hour: 9, minute: 0)
          : TimeOfDay.fromDateTime(it.due!),
      helpText: 'Due time',
    );
    setState(() => it.due = DateTime(
        d.year, d.month, d.day, t?.hour ?? 9, t?.minute ?? 0));
  }

  /// Per-item options: priority, due date/time, optional add-subtask, delete.
  void _itemOptions(_ChecklistEntry it,
      {VoidCallback? onAddSubtask, required VoidCallback onDelete}) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Priority',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var p = 0; p < 4; p++)
                      ChoiceChip(
                        label: Text(_priorityLabels[p]),
                        selected: it.priority == p,
                        showCheckmark: false,
                        avatar: p == 0
                            ? null
                            : Icon(Icons.flag,
                                size: 16, color: _priorityColors[p]),
                        onSelected: (_) {
                          setSheet(() {});
                          setState(() => it.priority = p);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Repeat',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final r in const [
                      null,
                      'daily',
                      'weekday',
                      'weekly',
                      'monthly'
                    ])
                      ChoiceChip(
                        label: Text(recurrenceLabel(r)),
                        selected: it.recurrence == r,
                        showCheckmark: false,
                        onSelected: (_) {
                          setSheet(() {});
                          setState(() => it.recurrence = r);
                        },
                      ),
                  ],
                ),
                const Divider(height: 24),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_outlined),
                  title: Text(it.due == null ? 'Set due date' : _dueLabel(it.due!)),
                  trailing: it.due == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setSheet(() {});
                            setState(() => it.due = null);
                          },
                        ),
                  onTap: () async {
                    await _pickItemDue(it);
                    setSheet(() {});
                  },
                ),
                if (onAddSubtask != null)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Add subtask'),
                    onTap: () {
                      Navigator.pop(ctx);
                      onAddSubtask();
                    },
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.delete_outline,
                      color: Theme.of(ctx).colorScheme.error),
                  title: Text('Delete item',
                      style:
                          TextStyle(color: Theme.of(ctx).colorScheme.error)),
                  onTap: () {
                    Navigator.pop(ctx);
                    onDelete();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final _numbered = RegExp(r'^(\d+)\. ');

  /// Body change handler: inline markdown shortcuts + list auto-continue.
  void _onBodyChanged() {
    final text = _body.text;
    final sel = _body.selection;
    if (text.length == _prevBody.length + 1 && sel.isCollapsed && sel.start > 0) {
      final ch = text[sel.start - 1];
      if (ch == '\n') {
        _handleNewline(text, sel.start);
      } else if (ch == ' ') {
        _handleSpaceShortcut(text, sel.start);
      }
    }
    _prevBody = _body.text;
  }

  /// "- " or "* " at the start of a line becomes a "• " bullet (Notion-style).
  void _handleSpaceShortcut(String text, int caret) {
    final lineStart = text.lastIndexOf('\n', caret - 2) + 1;
    final token = text.substring(lineStart, caret); // includes the space
    if (token == '- ' || token == '* ') {
      final updated = text.replaceRange(lineStart, caret, '• ');
      _body.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: lineStart + 2),
      );
    }
  }

  /// Enter on a bullet/numbered line continues the list (or ends it if empty).
  void _handleNewline(String text, int caret) {
    final lineStart = text.lastIndexOf('\n', caret - 2) + 1;
    final line = text.substring(lineStart, caret - 1);
    final bullet = line.startsWith('• ');
    final num = _numbered.firstMatch(line);
    if (!bullet && num == null) return;
    final content =
        bullet ? line.substring(2) : line.substring(num!.group(0)!.length);
    String updated;
    int offset;
    if (content.trim().isEmpty) {
      updated = text.replaceRange(lineStart, caret, '');
      offset = lineStart;
    } else {
      final marker = bullet ? '• ' : '${int.parse(num!.group(1)!) + 1}. ';
      updated = text.replaceRange(caret, caret, marker);
      offset = caret + marker.length;
    }
    _body.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final folders = ref.watch(foldersProvider).value ?? const [];
    final folderName = _folderId == null
        ? 'Unfiled'
        : folders
            .firstWhere((f) => f.id == _folderId,
                orElse: () => const FolderModel(name: 'Unfiled'))
            .name;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _save();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _save,
          ),
          title: Text(_isEdit ? 'Edit note' : 'New note'),
          actions: [
            IconButton(
              tooltip: _pinned ? 'Unpin' : 'Pin',
              icon: Icon(_pinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: _pinned ? scheme.primary : null),
              onPressed: () => setState(() => _pinned = !_pinned),
            ),
            if (_isEdit)
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: _delete,
              ),
            const SizedBox(width: 4),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            // Meta row: kind · date · folder, as quiet chips.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(
                  icon: noteTypeVisual(_kind).icon,
                  label: noteTypeLabel(_kind),
                  onTap: _pickType,
                ),
                _MetaChip(
                  icon: Icons.event_outlined,
                  label: _pretty(_date),
                  onTap: _pickDate,
                ),
                _MetaChip(
                  icon: Icons.folder_outlined,
                  label: folderName,
                  onTap: _pickFolder,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Seamless writing surface — title flows straight into the body.
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
              decoration: _bare(context, 'Title'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _body,
              maxLines: null,
              minLines: 6,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.5, color: scheme.onSurfaceVariant),
              decoration: _bare(context, 'Start writing…'),
            ),
            const SizedBox(height: 16),
            // Tasks — shown only when there are tasks or you add one. Type
            // "- " in the body for a bullet; tasks are the interactive to-dos.
            if (_items.isNotEmpty || _addingTask) ...[
              _SectionLabel('Tasks', scheme: scheme),
              const SizedBox(height: 4),
              for (var i = 0; i < _items.length; i++) ...[
                _swipeRow(
                  _items[i],
                  () => setState(() => _items.removeAt(i).dispose()),
                  _ChecklistRow(
                    entry: _items[i],
                    onToggle: () => _toggleEntry(_items[i]),
                    onOptions: () => _itemOptions(
                      _items[i],
                      onAddSubtask: () => setState(() => _items[i]
                          .children
                          .add(_ChecklistEntry('', id: _newItemId()))),
                      onDelete: () =>
                          setState(() => _items.removeAt(i).dispose()),
                    ),
                  ),
                ),
                for (var c = 0; c < _items[i].children.length; c++)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: _swipeRow(
                      _items[i].children[c],
                      () => setState(
                          () => _items[i].children.removeAt(c).dispose()),
                      _ChecklistRow(
                        entry: _items[i].children[c],
                        onToggle: () => _toggleEntry(_items[i].children[c]),
                        onOptions: () => _itemOptions(
                          _items[i].children[c],
                          onDelete: () => setState(
                              () => _items[i].children.removeAt(c).dispose()),
                        ),
                      ),
                    ),
                  ),
              ],
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newItem,
                      focusNode: _newItemFocus,
                      autofocus: _items.isEmpty,
                      textInputAction: TextInputAction.next,
                      decoration: _bare(context, 'Add a task'),
                      onSubmitted: (_) => _addItem(),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Add task',
                    icon: Icon(Icons.add_circle, color: scheme.primary),
                    onPressed: _addItem,
                  ),
                ],
              ),
            ] else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _addingTask = true),
                  icon: const Icon(Icons.add_task, size: 18),
                  label: const Text('Add task'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Borderless, unfilled field decoration for a seamless writing surface.
InputDecoration _bare(BuildContext context, String hint) => InputDecoration(
      hintText: hint,
      filled: false,
      isCollapsed: true,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      hintStyle: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .onSurfaceVariant
              .withValues(alpha: 0.6)),
    );

class _SectionLabel extends StatelessWidget {
  final String text;
  final ColorScheme scheme;
  const _SectionLabel(this.text, {required this.scheme});

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 1.0,
        ),
      );
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MetaChip(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

/// An editable checklist row: tick to mark done, type to edit, options for
/// priority / due date / delete; shows a priority flag and a due chip.
class _ChecklistRow extends StatelessWidget {
  final _ChecklistEntry entry;
  final VoidCallback onToggle;
  final VoidCallback onOptions;
  const _ChecklistRow(
      {required this.entry, required this.onToggle, required this.onOptions});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overdue = entry.due != null &&
        !entry.done &&
        entry.due!.isBefore(DateTime.now());
    final dueColor = overdue ? scheme.error : scheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox + text on one line, vertically centered.
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 28,
              child: Checkbox(
                value: entry.done,
                onChanged: (_) => onToggle(),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: entry.controller,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  decoration: entry.done ? TextDecoration.lineThrough : null,
                  color:
                      entry.done ? scheme.onSurfaceVariant : scheme.onSurface,
                ),
                decoration: _bare(context, 'Item'),
              ),
            ),
            if (entry.priority > 0)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Icon(Icons.flag,
                    size: 16, color: _priorityColors[entry.priority]),
              ),
            IconButton(
              icon: Icon(Icons.more_vert,
                  size: 18, color: scheme.onSurfaceVariant),
              onPressed: onOptions,
            ),
          ],
        ),
        // Due chip, aligned under the text.
        if (entry.due != null)
          Padding(
            padding: const EdgeInsets.only(left: 36, bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, size: 13, color: dueColor),
                const SizedBox(width: 4),
                Text(_dueLabel(entry.due!),
                    style: TextStyle(
                        color: dueColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                if (entry.recurrence != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.repeat, size: 13, color: dueColor),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

String _pretty(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${m[d.month - 1]} ${d.day}, ${d.year}';
}

/// Friendly due label: "Today 5:00 PM", "Tomorrow 9:00 AM", "Jun 25, 9:00 AM".
String _dueLabel(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final now = DateTime.now();
  final day = DateTime(d.year, d.month, d.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = day.difference(today).inDays;
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final time =
      '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
  final datePart = diff == 0
      ? 'Today'
      : diff == 1
          ? 'Tomorrow'
          : diff == -1
              ? 'Yesterday'
              : '${m[d.month - 1]} ${d.day}';
  return '$datePart  $time';
}
