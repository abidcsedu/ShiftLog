import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../state/providers.dart';
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

/// One editable checklist row: its own text controller + done flag.
class _ChecklistEntry {
  final TextEditingController controller;
  bool done;
  _ChecklistEntry(String text, {this.done = false})
      : controller = TextEditingController(text: text);
  void dispose() => controller.dispose();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen>
    with WidgetsBindingObserver {
  late NoteKind _kind;
  late DateTime _date;
  late int? _folderId;
  int? _id; // tracks the saved row so re-saves update instead of duplicating
  late final TextEditingController _title;
  late final TextEditingController _body;
  String _prevBody = '';
  late final TextEditingController _tags;
  late List<_ChecklistEntry> _items;
  late bool _pinned;
  final _newItem = TextEditingController();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final e = widget.existing;
    _id = e?.id;
    _kind = e?.kind ?? NoteKind.daily;
    _date = e?.date ?? DateTime.now();
    _folderId = e?.folderId ?? widget.initialFolderId;
    _title = TextEditingController(text: e?.title ?? '');
    _body = TextEditingController(text: e?.body ?? '');
    _prevBody = _body.text;
    _body.addListener(_continueListOnNewline);
    _tags = TextEditingController(text: e?.tags.join(', ') ?? '');
    _items = [
      for (final c in (e?.checklist ?? const <ChecklistItem>[]))
        _ChecklistEntry(c.text, done: c.done),
    ];
    _pinned = e?.pinned ?? false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _title.dispose();
    _body.dispose();
    _tags.dispose();
    _newItem.dispose();
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
    _items.add(_ChecklistEntry(t));
    _newItem.clear();
  }

  /// Current non-empty checklist items, read live from their controllers.
  List<ChecklistItem> _collectItems() => [
        for (final it in _items)
          if (it.controller.text.trim().isNotEmpty)
            ChecklistItem(it.controller.text.trim(), done: it.done),
      ];

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
      return;
    }
    final tags = _tags.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final id = await repo.saveNote(NoteModel(
      id: _id,
      kind: _kind,
      date: _date,
      title: _title.text.trim(),
      body: _body.text.trim(),
      tags: tags,
      checklist: items,
      pinned: _pinned,
      folderId: _folderId,
      updatedAt: DateTime.now(),
    ));
    _id = id; // keep editing the same row on subsequent saves
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

  void _addItem() {
    final t = _newItem.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _items.add(_ChecklistEntry(t));
      _newItem.clear();
    });
  }

  static final _numbered = RegExp(r'^(\d+)\. ');

  /// Toggle a bullet ("• ") or numbered ("1. ") prefix on the body's current
  /// line.
  void _toggleListPrefix(bool numbered) {
    final text = _body.text;
    final caret = _body.selection.baseOffset < 0
        ? text.length
        : _body.selection.baseOffset;
    final lineStart = text.lastIndexOf('\n', caret - 1) + 1;
    var lineEnd = text.indexOf('\n', lineStart);
    if (lineEnd < 0) lineEnd = text.length;
    final line = text.substring(lineStart, lineEnd);

    String newLine;
    final hasBullet = line.startsWith('• ');
    final numMatch = _numbered.firstMatch(line);
    if (hasBullet) {
      newLine = numbered ? '1. ${line.substring(2)}' : line.substring(2);
    } else if (numMatch != null) {
      final rest = line.substring(numMatch.group(0)!.length);
      newLine = numbered ? rest : '• $rest';
    } else {
      newLine = (numbered ? '1. ' : '• ') + line;
    }
    final updated = text.replaceRange(lineStart, lineEnd, newLine);
    final delta = newLine.length - line.length;
    _prevBody = updated;
    _body.value = TextEditingValue(
      text: updated,
      selection: TextSelection.collapsed(offset: caret + delta),
    );
  }

  /// When Enter is pressed on a bullet/numbered line, continue the list (or end
  /// it if the line was empty).
  void _continueListOnNewline() {
    final text = _body.text;
    final sel = _body.selection;
    if (text.length != _prevBody.length + 1 ||
        !sel.isCollapsed ||
        sel.start == 0 ||
        text[sel.start - 1] != '\n') {
      _prevBody = text;
      return;
    }
    final caret = sel.start;
    final lineStart = text.lastIndexOf('\n', caret - 2) + 1;
    final line = text.substring(lineStart, caret - 1);
    final bullet = line.startsWith('• ');
    final num = _numbered.firstMatch(line);
    if (!bullet && num == null) {
      _prevBody = text;
      return;
    }
    final content =
        bullet ? line.substring(2) : line.substring(num!.group(0)!.length);
    String updated;
    int offset;
    if (content.trim().isEmpty) {
      // Empty item → drop the marker and end the list.
      updated = text.replaceRange(lineStart, caret, '');
      offset = lineStart;
    } else {
      final marker =
          bullet ? '• ' : '${int.parse(num!.group(1)!) + 1}. ';
      updated = text.replaceRange(caret, caret, marker);
      offset = caret + marker.length;
    }
    _prevBody = updated;
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
                  icon: _kind == NoteKind.meeting ? Icons.groups : Icons.today,
                  label: _kind.label,
                  onTap: () => setState(() => _kind = _kind == NoteKind.daily
                      ? NoteKind.meeting
                      : NoteKind.daily),
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
            // Formatting toolbar: bullet / numbered list on the current line.
            Row(
              children: [
                IconButton(
                  tooltip: 'Bullet list',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.format_list_bulleted,
                      size: 20, color: scheme.onSurfaceVariant),
                  onPressed: () => _toggleListPrefix(false),
                ),
                IconButton(
                  tooltip: 'Numbered list',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.format_list_numbered,
                      size: 20, color: scheme.onSurfaceVariant),
                  onPressed: () => _toggleListPrefix(true),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SectionLabel('Action items', scheme: scheme),
            const SizedBox(height: 4),
            for (var i = 0; i < _items.length; i++)
              _ChecklistRow(
                key: ObjectKey(_items[i]),
                entry: _items[i],
                onToggle: () =>
                    setState(() => _items[i].done = !_items[i].done),
                onDelete: () => setState(() {
                  _items.removeAt(i).dispose();
                }),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newItem,
                    textInputAction: TextInputAction.done,
                    decoration: _bare(context, 'Add an action item'),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                IconButton(
                  tooltip: 'Add item',
                  icon: Icon(Icons.add_circle, color: scheme.primary),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel('Tags', scheme: scheme),
            const SizedBox(height: 8),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(
                hintText: 'comma, separated, tags',
                prefixIcon: Icon(Icons.tag, size: 18),
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

/// An editable checklist row: tick to mark done, type to edit, X to remove.
class _ChecklistRow extends StatelessWidget {
  final _ChecklistEntry entry;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _ChecklistRow(
      {super.key,
      required this.entry,
      required this.onToggle,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
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
              color: entry.done ? scheme.onSurfaceVariant : scheme.onSurface,
            ),
            decoration: _bare(context, 'Item'),
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
