import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../state/providers.dart';
import 'widgets/folder_picker.dart';

/// Full-screen editor for a daily/meeting note with a folder, action-item
/// checklist, and a seamless title + body writing surface.
class NoteEditorScreen extends ConsumerStatefulWidget {
  final NoteModel? existing;
  final int? initialFolderId;
  const NoteEditorScreen({super.key, this.existing, this.initialFolderId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late NoteKind _kind;
  late DateTime _date;
  late int? _folderId;
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
    _folderId = e?.folderId ?? widget.initialFolderId;
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
      if (_isEdit) {
        await ref.read(repositoryProvider).deleteNote(widget.existing!.id!);
      }
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
          folderId: _folderId,
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

  Future<void> _pickFolder() async {
    final result = await showFolderPicker(context, ref, selected: _folderId);
    if (result != null) setState(() => _folderId = result.id);
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
            const SizedBox(height: 24),
            _SectionLabel('Action items', scheme: scheme),
            const SizedBox(height: 4),
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
                Icon(Icons.add_circle_outline,
                    size: 20, color: scheme.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _newItem,
                    decoration: _bare(context, 'Add an action item'),
                    onSubmitted: (_) => _addItem(),
                  ),
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
        SizedBox(
          width: 28,
          child: Checkbox(
            value: item.done,
            onChanged: (_) => onToggle(),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
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
