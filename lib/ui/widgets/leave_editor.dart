import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums.dart';
import '../../domain/work_logic.dart';
import '../../state/providers.dart';

/// Opens the "apply leave" sheet (pick category, dates, half/full, reason).
Future<void> showLeaveEditor(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: const _LeaveEditor(),
    ),
  );
}

class _LeaveEditor extends ConsumerStatefulWidget {
  const _LeaveEditor();
  @override
  ConsumerState<_LeaveEditor> createState() => _LeaveEditorState();
}

class _LeaveEditorState extends ConsumerState<_LeaveEditor> {
  late LeaveCategory _category;
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  LeaveType _duration = LeaveType.full;
  final _reason = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final gender = ref.read(genderProvider) ?? Gender.male;
    _category = eligibleLeave(gender).first;
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  double get _days {
    if (_duration == LeaveType.half) return 0.5;
    return workingDaysBetween(_start, _end, ref.read(weekendProvider))
        .toDouble();
  }

  Future<void> _pick(bool isStart) async {
    final d = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : _end,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() {
      if (isStart) {
        _start = d;
        if (_end.isBefore(_start)) _end = d;
      } else {
        _end = d;
        if (_start.isAfter(_end)) _start = d;
      }
    });
  }

  Future<void> _save() async {
    final gender = ref.read(genderProvider) ?? Gender.male;
    final records = ref.read(leaveRecordsProvider).value ?? const [];
    final join = ref.read(joinDateProvider);
    final year = DateTime.now().year;

    if (_duration == LeaveType.half &&
        !(_start.year == _end.year &&
            _start.month == _end.month &&
            _start.day == _end.day)) {
      setState(() => _error = 'Half-day leave must be a single day.');
      return;
    }
    final days = _days;
    final remaining = leaveRemaining(records, _category, gender, join, year);
    if (remaining < days) {
      setState(() => _error =
          'Not enough ${_category.label} balance — ${_fmt(remaining)} left, '
          '${_fmt(days)} requested.');
      return;
    }
    await ref.read(repositoryProvider).addLeaveRecord(
          category: _category,
          startDate: _start,
          endDate: _end,
          duration: _duration,
          daysConsumed: days,
          reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gender = ref.watch(genderProvider) ?? Gender.male;
    final records = ref.watch(leaveRecordsProvider).value ?? const [];
    final join = ref.watch(joinDateProvider);
    final year = DateTime.now().year;
    final remaining =
        leaveRemaining(records, _category, gender, join, year);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Apply for leave',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            DropdownButtonFormField<LeaveCategory>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Leave type'),
              items: [
                for (final c in eligibleLeave(gender))
                  DropdownMenuItem(value: c, child: Text('${c.label} leave')),
              ],
              onChanged: (c) => setState(() => _category = c!),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text('${_fmt(remaining)} remaining this year',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                      label: 'From',
                      value: _pretty(_start),
                      onTap: () => _pick(true)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DateField(
                      label: 'To',
                      value: _pretty(_end),
                      enabled: _duration == LeaveType.full,
                      onTap: () => _pick(false)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<LeaveType>(
              segments: const [
                ButtonSegment(value: LeaveType.full, label: Text('Full day(s)')),
                ButtonSegment(value: LeaveType.half, label: Text('Half day')),
              ],
              selected: {_duration},
              onSelectionChanged: (s) => setState(() {
                _duration = s.first;
                if (_duration == LeaveType.half) _end = _start;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reason,
              decoration: const InputDecoration(
                  labelText: 'Reason (optional)', border: OutlineInputBorder()),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text('Apply  •  ${_fmt(_days)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _fmt(double d) =>
    d == d.roundToDouble() ? '${d.toInt()} day${d == 1 ? '' : 's'}' : '$d days';

String _pretty(DateTime d) {
  const m = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return '${m[d.month - 1]} ${d.day}';
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final bool enabled;
  final VoidCallback onTap;
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: scheme.onSurfaceVariant, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: enabled
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}
