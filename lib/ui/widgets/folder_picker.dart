import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models.dart';
import '../../state/providers.dart';

/// "Unfiled" selection sentinel (id == null).
const unfiledFolder = FolderModel(name: 'Unfiled');

/// Shows a bottom sheet to choose the folder for a note. Returns the chosen
/// [FolderModel] ([unfiledFolder] for none), or null if dismissed.
Future<FolderModel?> showFolderPicker(
  BuildContext context,
  WidgetRef ref, {
  int? selected,
}) {
  return showModalBottomSheet<FolderModel>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _FolderPickerSheet(ref: ref, selected: selected),
  );
}

class _FolderPickerSheet extends StatelessWidget {
  final WidgetRef ref;
  final int? selected;
  const _FolderPickerSheet({required this.ref, required this.selected});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final folders = ref.watch(foldersProvider).value ?? const [];
    final rows = flattenFolders(folders);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Text('Move to folder',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _row(context,
                      icon: Icons.inbox_outlined,
                      label: 'Unfiled',
                      depth: 0,
                      selected: selected == null,
                      onTap: () => Navigator.pop(context, unfiledFolder)),
                  for (final r in rows)
                    _row(context,
                        icon: Icons.folder_outlined,
                        label: r.folder.name,
                        depth: r.depth,
                        selected: selected == r.folder.id,
                        onTap: () => Navigator.pop(context, r.folder)),
                ],
              ),
            ),
            const Divider(height: 8),
            ListTile(
              leading: Icon(Icons.create_new_folder_outlined,
                  color: scheme.primary),
              title: Text('New folder',
                  style: TextStyle(
                      color: scheme.primary, fontWeight: FontWeight.w600)),
              onTap: () async {
                final name = await promptFolderName(context);
                if (name == null) return;
                final id =
                    await ref.read(repositoryProvider).createFolder(name);
                if (context.mounted) {
                  Navigator.pop(context, FolderModel(id: id, name: name));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context,
      {required IconData icon,
      required String label,
      required int depth,
      required bool selected,
      required VoidCallback onTap}) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + depth * 20, right: 16),
      leading: Icon(icon,
          color: selected ? scheme.primary : scheme.onSurfaceVariant),
      title: Text(label,
          style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? scheme.primary : scheme.onSurface)),
      trailing: selected ? Icon(Icons.check, color: scheme.primary) : null,
      onTap: onTap,
    );
  }
}

/// Depth-tagged folder for indented display.
class FolderRow {
  final FolderModel folder;
  final int depth;
  const FolderRow(this.folder, this.depth);
}

/// Flattens the folder forest into a pre-order list with depth, sorted by name.
List<FolderRow> flattenFolders(List<FolderModel> all) {
  final byParent = <int?, List<FolderModel>>{};
  for (final f in all) {
    byParent.putIfAbsent(f.parentId, () => []).add(f);
  }
  for (final list in byParent.values) {
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
  final out = <FolderRow>[];
  void walk(int? parent, int depth) {
    for (final f in byParent[parent] ?? const []) {
      out.add(FolderRow(f, depth));
      walk(f.id, depth + 1);
    }
  }

  walk(null, 0);
  return out;
}

/// Prompts for a name. Returns the trimmed name, or null if cancelled.
Future<String?> promptFolderName(BuildContext context,
    {String? initial, String? title}) {
  final controller = TextEditingController(text: initial ?? '');
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? (initial == null ? 'New folder' : 'Rename folder')),
      content: TextField(
        controller: controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(hintText: 'Name'),
        onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final v = controller.text.trim();
            if (v.isNotEmpty) Navigator.pop(ctx, v);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
