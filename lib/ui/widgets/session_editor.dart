import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../../state/providers.dart';
import '../theme.dart';

/// Opens the add/edit session sheet. Pass [existing] to edit, null to add.
Future<void> showSessionEditor(BuildContext context, {WorkSession? existing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _SessionEditor(existing: existing),
    ),
  );
}

class _SessionEditor extends ConsumerStatefulWidget {
  final WorkSession? existing;
  const _SessionEditor({this.existing});

  @override
  ConsumerState<_SessionEditor> createState() => _SessionEditorState();
}

class _SessionEditorState extends ConsumerState<_SessionEditor> {
  late DateTime _date;
  late TimeOfDay _start;
  TimeOfDay? _end;
  late WorkMode _mode;
  final _note = TextEditingController();
  final _project = TextEditingController();
  final _projectFocus = FocusNode();
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final now = DateTime.now();
    _date = e?.clockIn ?? now;
    _start = TimeOfDay.fromDateTime(e?.clockIn ?? now);
    _end = e?.clockOut == null ? null : TimeOfDay.fromDateTime(e!.clockOut!);
    _mode = e?.mode ?? WorkMode.office;
    _note.text = e?.note ?? '';
    _project.text = e?.project ?? '';
  }

  @override
  void dispose() {
    _note.dispose();
    _project.dispose();
    _projectFocus.dispose();
    super.dispose();
  }

  DateTime _compose(TimeOfDay t) =>
      DateTime(_date.year, _date.month, _date.day, t.hour, t.minute);

  Future<void> _save() async {
    final clockIn = _compose(_start);
    final clockOut = _end == null ? null : _compose(_end!);
    if (clockOut != null && !clockOut.isAfter(clockIn)) {
      setState(() => _error = 'End time must be after the start time.');
      return;
    }
    final repo = ref.read(repositoryProvider);
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    final project =
        _project.text.trim().isEmpty ? null : _project.text.trim();
    if (_isEdit) {
      await repo.updateSession(widget.existing!.id!,
          clockIn: clockIn,
          clockOut: clockOut,
          mode: _mode,
          note: note,
          project: project);
    } else {
      await repo.addSession(clockIn, clockOut, _mode,
          note: note, project: project);
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    await ref.read(repositoryProvider).deleteSession(widget.existing!.id!);
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

  Future<void> _pickStart() async {
    final t = await showTimePicker(context: context, initialTime: _start);
    if (t != null) setState(() => _start = t);
  }

  Future<void> _pickEnd() async {
    final t = await showTimePicker(
        context: context, initialTime: _end ?? _start);
    if (t != null) setState(() => _end = t);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_isEdit ? 'Edit session' : 'Add session',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _Field(
              icon: Icons.event,
              label: 'Date',
              value: _prettyDate(_date),
              onTap: _pickDate,
            ),
            const SizedBox(height: 10),
            _Field(
              icon: Icons.login,
              label: 'Start',
              value: _start.format(context),
              onTap: _pickStart,
            ),
            const SizedBox(height: 10),
            _Field(
              icon: Icons.logout,
              label: 'End',
              value: _end == null ? 'Ongoing' : _end!.format(context),
              onTap: _pickEnd,
              trailing: _end == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Mark ongoing',
                      onPressed: () => setState(() => _end = null),
                    ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkMode>(
              initialValue: _mode,
              decoration: const InputDecoration(labelText: 'Work mode'),
              items: [
                for (final m in WorkMode.values)
                  DropdownMenuItem(
                    value: m,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(modeVisual(m).icon,
                            size: 18, color: modeVisual(m).color),
                        const SizedBox(width: 8),
                        Text(m.label),
                      ],
                    ),
                  ),
              ],
              onChanged: (m) => setState(() => _mode = m!),
            ),
            const SizedBox(height: 12),
            RawAutocomplete<String>(
              textEditingController: _project,
              focusNode: _projectFocus,
              optionsBuilder: (value) {
                final all = ref.read(projectsProvider);
                final q = value.text.trim().toLowerCase();
                if (q.isEmpty) return all;
                return all.where((p) => p.toLowerCase().contains(q));
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onSubmit) => TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Project / ticket (optional)',
                  prefixIcon: Icon(Icons.folder_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              optionsViewBuilder: (context, onSelected, options) => Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        for (final o in options)
                          ListTile(
                            dense: true,
                            title: Text(o),
                            onTap: () => onSelected(o),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                if (_isEdit)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _delete,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.error),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                    ),
                  ),
                if (_isEdit) const SizedBox(width: 12),
                Expanded(
                  flex: _isEdit ? 1 : 1,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;
  const _Field({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: scheme.onSurfaceVariant, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(value,
                  style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600)),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

String _prettyDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}
