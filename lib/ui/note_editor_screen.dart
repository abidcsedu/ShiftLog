import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../state/providers.dart';

/// Full-screen editor for a daily/meeting note with action-item checklist.
class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? existing;
  const NoteEditorScreen({super.key, this.existing});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late NoteKind _kind;
  late DateTime _date;
  late final TextEditingController _title;
  late final TextEditingController _body;
  late final TextEditingController _tags;
  late List<ChecklistItem> _checklist;
  late bool _pinned;
  final _newItem = TextEditingController();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _kind = e?.kind ?? NoteKind.daily;
    _date = e?.date ?? DateTime.now();
    _title = TextEditingController(text: e?.title ?? '');
    _body = TextEditingController(text: e?.body ?? '');
    _tags = TextEditingController(text: e?.tags.join(', ') ?? '');
    _checklist = [...?e?.checklist];
    _pinned = e?.pinned ?? false;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tags.dispose();
    _newItem.dispose();
    super.dispose();
  }

  bool get _isEmpty =>
      _title.text.trim().isEmpty &&
      _body.text.trim().isEmpty &&
      _checklist.isEmpty;

  Future<void> _save() async {
    if (_isEmpty) {
      // Nothing to save; if editing an existing empty note, delete it.
      if (_isEdit) await ref.read(repositoryProvider).deleteNote(widget.existing!.id!);
      if (mounted) Navigator.pop(context);
      return;
    }
    final tags = _tags.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    await ref.read(repositoryProvider).saveNote(NoteModel(
          id: widget.existing?.id,
          kind: _kind,
          date: _date,
          title: _title.text.trim(),
          body: _body.text.trim(),
          tags: tags,
          checklist: _checklist,
          pinned: _pinned,
          updatedAt: DateTime.now(),
        ));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await ref.read(repositoryProvider).deleteNote(widget.existing!.id!);
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

  void _addItem() {
    final t = _newItem.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _checklist = [..._checklist, ChecklistItem(t)];
      _newItem.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _save();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit note' : 'New note'),
          actions: [
            IconButton(
              tooltip: 'Pin',
              icon: Icon(_pinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () => setState(() => _pinned = !_pinned),
            ),
            if (_isEdit)
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: _delete,
              ),
            IconButton(
                tooltip: 'Save',
                icon: const Icon(Icons.check),
                onPressed: _save),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<NoteKind>(
                    segments: const [
                      ButtonSegment(
                          value: NoteKind.daily,
                          label: Text('Daily'),
                          icon: Icon(Icons.today)),
                      ButtonSegment(
                          value: NoteKind.meeting,
                          label: Text('Meeting'),
                          icon: Icon(Icons.groups)),
                    ],
                    selected: {_kind},
                    onSelectionChanged: (s) => setState(() => _kind = s.first),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ActionChip(
              avatar: const Icon(Icons.event, size: 18),
              label: Text(_pretty(_date)),
              onPressed: _pickDate,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                  hintText: 'Title', border: InputBorder.none),
            ),
            TextField(
              controller: _body,
              maxLines: null,
              minLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  hintText: 'Write your note…', border: InputBorder.none),
            ),
            const Divider(height: 28),
            Text('Action items',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: scheme.onSurfaceVariant)),
            for (var i = 0; i < _checklist.length; i++)
              _ChecklistRow(
                item: _checklist[i],
                onToggle: () => setState(() => _checklist[i] =
                    _checklist[i].copyWith(done: !_checklist[i].done)),
                onDelete: () =>
                    setState(() => _checklist = [..._checklist]..removeAt(i)),
              ),
            Row(
              children: [
                const Icon(Icons.add, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _newItem,
                    decoration: const InputDecoration(
                        hintText: 'Add an action item',
                        border: InputBorder.none),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
              ],
            ),
            const Divider(height: 28),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _ChecklistRow(
      {required this.item, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Checkbox(value: item.done, onChanged: (_) => onToggle()),
        Expanded(
          child: Text(
            item.text,
            style: TextStyle(
              decoration: item.done ? TextDecoration.lineThrough : null,
              color: item.done ? scheme.onSurfaceVariant : scheme.onSurface,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, size: 18, color: scheme.onSurfaceVariant),
          onPressed: onDelete,
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
