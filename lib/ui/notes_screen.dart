import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../state/providers.dart';
import 'note_editor_screen.dart';
import 'theme.dart';
import 'widgets/folder_picker.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _query = '';
  String? _filter; // null = all; else a note-type key
  int? _folderId; // current folder (null = top level)

  Future<void> _newType() async {
    final name = await promptFolderName(context, title: 'New note type');
    if (name == null) return;
    await ref.read(repositoryProvider).createNoteType(name);
  }

  void _openNote(NoteModel? note) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>
          NoteEditorScreen(existing: note, initialFolderId: _folderId),
    ));
  }

  Future<void> _newFolder() async {
    final name = await promptFolderName(context);
    if (name == null) return;
    await ref.read(repositoryProvider).createFolder(name, parentId: _folderId);
  }

  Future<void> _renameFolder(FolderModel f) async {
    final name = await promptFolderName(context, initial: f.name);
    if (name == null) return;
    await ref.read(repositoryProvider).renameFolder(f.id!, name);
  }

  Future<void> _deleteFolder(FolderModel f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete “${f.name}”?'),
        content: const Text(
            'Its notes and subfolders move up one level — nothing is deleted.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) await ref.read(repositoryProvider).deleteFolder(f.id!);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final allNotes = ref.watch(notesProvider).value ?? const [];
    final allFolders = ref.watch(foldersProvider).value ?? const [];
    final customTypes = ref.watch(noteTypesProvider).value ?? const [];
    final searching = _query.trim().isNotEmpty;
    final q = _query.trim().toLowerCase();

    final current =
        _folderId == null ? null : _byId(allFolders, _folderId);
    // If the current folder was deleted elsewhere, fall back to root.
    if (_folderId != null && current == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => mounted ? setState(() => _folderId = null) : null);
    }

    bool matchesQuery(NoteModel n) =>
        n.title.toLowerCase().contains(q) ||
        n.body.toLowerCase().contains(q);

    // When searching, look across every note; otherwise show this folder's.
    final notes = allNotes.where((n) {
      if (_filter != null && n.kind != _filter) return false;
      if (searching) return matchesQuery(n);
      return n.folderId == _folderId;
    }).toList();

    final subfolders = searching
        ? const <FolderModel>[]
        : (allFolders.where((f) => f.parentId == _folderId).toList()
          ..sort((a, b) =>
              a.name.toLowerCase().compareTo(b.name.toLowerCase())));

    return Scaffold(
      appBar: AppBar(
        leading: _folderId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    setState(() => _folderId = current?.parentId),
              )
            : null,
        title: Text(current?.name ?? 'Notes'),
        actions: [
          IconButton(
            tooltip: 'New folder',
            icon: const Icon(Icons.create_new_folder_outlined),
            onPressed: _newFolder,
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNote(null),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('New note'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search all notes',
                isDense: true,
                filled: true,
                fillColor: scheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Type filter — scrolls horizontally as custom types are added.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _filterChip('All', null),
                const SizedBox(width: 8),
                _filterChip('Daily', kNoteDaily),
                const SizedBox(width: 8),
                _filterChip('Meeting', kNoteMeeting),
                for (final t in customTypes) ...[
                  const SizedBox(width: 8),
                  _filterChip(t, t),
                ],
                const SizedBox(width: 8),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Type'),
                  onPressed: _newType,
                ),
              ],
            ),
          ),
          Expanded(
            child: (notes.isEmpty && subfolders.isEmpty)
                ? _empty(scheme, allNotes.isEmpty && allFolders.isEmpty)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                    children: [
                      for (final f in subfolders)
                        _FolderTile(
                          folder: f,
                          count: _countIn(allNotes, allFolders, f.id),
                          onTap: () => setState(() => _folderId = f.id),
                          onRename: () => _renameFolder(f),
                          onDelete: () => _deleteFolder(f),
                        ),
                      if (subfolders.isNotEmpty && notes.isNotEmpty)
                        const SizedBox(height: 4),
                      for (final n in notes)
                        _NoteCard(note: n, onTap: () => _openNote(n)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _empty(ColorScheme scheme, bool totallyEmpty) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sticky_note_2_outlined,
                size: 44, color: scheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
                _query.trim().isNotEmpty
                    ? 'No matching notes.'
                    : (totallyEmpty
                        ? 'No notes yet.\nTap “New note” to start.'
                        : 'This folder is empty.'),
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
        ),
      );

  Widget _filterChip(String label, String? kind) => ChoiceChip(
        label: Text(label),
        selected: _filter == kind,
        showCheckmark: false,
        onSelected: (_) => setState(() => _filter = kind),
      );

  static FolderModel? _byId(List<FolderModel> all, int? id) {
    for (final f in all) {
      if (f.id == id) return f;
    }
    return null;
  }

  /// Notes directly in a folder plus all of its descendants.
  static int _countIn(
      List<NoteModel> notes, List<FolderModel> folders, int? folderId) {
    final ids = <int?>{folderId};
    var added = true;
    while (added) {
      added = false;
      for (final f in folders) {
        if (ids.contains(f.parentId) && !ids.contains(f.id)) {
          ids.add(f.id);
          added = true;
        }
      }
    }
    return notes.where((n) => ids.contains(n.folderId)).length;
  }
}

class _FolderTile extends StatelessWidget {
  final FolderModel folder;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  const _FolderTile({
    required this.folder,
    required this.count,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.folder_rounded,
                    color: scheme.primary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(folder.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              Text('$count',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: scheme.onSurfaceVariant),
                onSelected: (v) => v == 'rename' ? onRename() : onDelete(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  const _NoteCard({required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final done = note.checklist.where((c) => c.done).length;
    final total = note.checklist.length;
    final visual = noteTypeVisual(note.kind);
    final accent = visual.color;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: scheme.surfaceContainerHigh,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(visual.icon, size: 13, color: accent),
                        const SizedBox(width: 4),
                        Text(noteTypeLabel(note.kind),
                            style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (note.pinned)
                    Icon(Icons.push_pin,
                        size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(_pretty(note.date),
                      style: TextStyle(
                          color: scheme.onSurfaceVariant, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              Text(note.title.isEmpty ? 'Untitled' : note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              if (note.body.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(note.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: scheme.onSurfaceVariant)),
              ],
              if (total > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.checklist,
                        size: 16, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text('$done/$total done',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _pretty(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${m[d.month - 1]} ${d.day}';
}
