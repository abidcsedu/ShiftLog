import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
import '../state/providers.dart';
import 'note_editor_screen.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  String _query = '';
  NoteKind? _filter; // null = all

  void _open(NoteModel? note) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => NoteEditorScreen(existing: note),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final all = ref.watch(notesProvider).value ?? const [];
    final q = _query.trim().toLowerCase();
    final notes = all.where((n) {
      if (_filter != null && n.kind != _filter) return false;
      if (q.isEmpty) return true;
      return n.title.toLowerCase().contains(q) ||
          n.body.toLowerCase().contains(q) ||
          n.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(null),
        icon: const Icon(Icons.edit_note),
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
                hintText: 'Search notes',
                isDense: true,
                filled: true,
                fillColor: scheme.surfaceContainerHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _filterChip('All', null),
                const SizedBox(width: 8),
                _filterChip('Daily', NoteKind.daily),
                const SizedBox(width: 8),
                _filterChip('Meeting', NoteKind.meeting),
              ],
            ),
          ),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sticky_note_2_outlined,
                            size: 44, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                            all.isEmpty
                                ? 'No notes yet.\nTap “New note” to start.'
                                : 'No matching notes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
                    itemCount: notes.length,
                    itemBuilder: (_, i) =>
                        _NoteCard(note: notes[i], onTap: () => _open(notes[i])),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, NoteKind? kind) => ChoiceChip(
        label: Text(label),
        selected: _filter == kind,
        onSelected: (_) => setState(() => _filter = kind),
      );
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
    final isMeeting = note.kind == NoteKind.meeting;
    final accent = isMeeting ? const Color(0xFF0D9488) : scheme.primary;
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isMeeting ? Icons.groups : Icons.today,
                            size: 13, color: accent),
                        const SizedBox(width: 4),
                        Text(note.kind.label,
                            style: TextStyle(
                                color: accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (note.pinned)
                    Icon(Icons.push_pin, size: 14, color: scheme.onSurfaceVariant),
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
                    Icon(Icons.checklist, size: 16, color: scheme.onSurfaceVariant),
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
