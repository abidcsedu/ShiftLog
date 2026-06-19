import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/enums.dart';
import '../domain/work_logic.dart';
import '../state/providers.dart';
import 'backup_actions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider).value;
    final repo = ref.read(repositoryProvider);
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final gender = GenderX.fromDb(settings.gender);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _section(context, 'Profile'),
          _Tile(
            icon: Icons.person_outline,
            title: 'Display name',
            value: settings.displayName?.isNotEmpty == true
                ? settings.displayName!
                : 'Not set',
            onTap: () => _editName(context, repo, settings.displayName),
          ),
          _Tile(
            icon: Icons.wc,
            title: 'Gender',
            value: gender.label,
            onTap: () => _editGender(context, repo, gender),
          ),

          _section(context, 'Targets'),
          _StepperTile(
            icon: Icons.schedule,
            title: 'Daily hours target',
            value: formatDuration(Duration(minutes: settings.dailyTargetMinutes)),
            onMinus: settings.dailyTargetMinutes > 30
                ? () => repo.updateSettings(
                    dailyTargetMinutes: settings.dailyTargetMinutes - 15)
                : null,
            onPlus: settings.dailyTargetMinutes < 24 * 60
                ? () => repo.updateSettings(
                    dailyTargetMinutes: settings.dailyTargetMinutes + 15)
                : null,
          ),
          _StepperTile(
            icon: Icons.beach_access,
            title: 'Yearly holidays',
            value: '${settings.yearlyHolidayAllocation}',
            onMinus: settings.yearlyHolidayAllocation > 0
                ? () => repo.updateSettings(
                    yearlyHolidayAllocation:
                        settings.yearlyHolidayAllocation - 1)
                : null,
            onPlus: () => repo.updateSettings(
                yearlyHolidayAllocation: settings.yearlyHolidayAllocation + 1),
          ),
          _StepperTile(
            icon: Icons.home_work,
            title: 'WFH days / month',
            value: '${settings.monthlyWfhLimit}',
            onMinus: settings.monthlyWfhLimit > 0
                ? () => repo.updateSettings(
                    monthlyWfhLimit: settings.monthlyWfhLimit - 1)
                : null,
            onPlus: () => repo.updateSettings(
                monthlyWfhLimit: settings.monthlyWfhLimit + 1),
          ),
          _StepperTile(
            icon: Icons.calendar_today,
            title: 'WFH days / year',
            value: '${settings.yearlyWfhLimit}',
            onMinus: settings.yearlyWfhLimit > 0
                ? () => repo.updateSettings(
                    yearlyWfhLimit: settings.yearlyWfhLimit - 1)
                : null,
            onPlus: () => repo.updateSettings(
                yearlyWfhLimit: settings.yearlyWfhLimit + 1),
          ),

          _section(context, 'Work week'),
          _Tile(
            icon: Icons.weekend,
            title: 'Weekend days',
            value: _weekendLabel(parseWeekend(settings.weekendDays)),
            onTap: () =>
                _editWeekend(context, repo, parseWeekend(settings.weekendDays)),
          ),

          _section(context, 'Appearance'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                    icon: Icon(Icons.brightness_auto)),
                ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode)),
                ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode)),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) => repo.setDarkMode(switch (s.first) {
                ThemeMode.system => null,
                ThemeMode.light => false,
                ThemeMode.dark => true,
              }),
            ),
          ),

          _section(context, 'Data'),
          _Tile(
            icon: Icons.backup_outlined,
            title: 'Export backup',
            value: 'for a new phone',
            onTap: () => exportBackup(context, ref),
          ),
          _Tile(
            icon: Icons.restore,
            title: 'Import backup',
            value: 'replaces data',
            onTap: () => _confirmImport(context, ref),
          ),
          _Tile(
            icon: Icons.table_view,
            title: 'Export as CSV',
            value: 'spreadsheet',
            onTap: () => _exportCsv(context, ref),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('ShiftLog • local-only',
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
        child: Text(title.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 1,
            )),
      );

  Future<void> _editName(
      BuildContext context, repo, String? current) async {
    final controller = TextEditingController(text: current ?? '');
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Display name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Your name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
    if (name != null) await repo.updateSettings(displayName: name);
  }

  Future<void> _editGender(BuildContext context, repo, Gender current) async {
    final g = await showDialog<Gender>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Gender'),
        children: [
          for (final g in Gender.values)
            ListTile(
              leading: Icon(g == current
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off),
              title: Text('${g.label} • ${allocationFor(g)} holidays/yr'),
              onTap: () => Navigator.pop(dialogContext, g),
            ),
        ],
      ),
    );
    if (g != null) {
      // Switching gender resets the holiday allocation to its default.
      await repo.updateSettings(
          gender: g, yearlyHolidayAllocation: allocationFor(g));
    }
  }

  Future<void> _editWeekend(
      BuildContext context, repo, Set<int> current) async {
    final selected = {...current};
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final result = await showDialog<Set<int>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Weekend days'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var wd = 1; wd <= 7; wd++)
                CheckboxListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  value: selected.contains(wd),
                  title: Text(names[wd - 1]),
                  onChanged: (v) => setLocal(() =>
                      v == true ? selected.add(wd) : selected.remove(wd)),
                ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(dialogContext, selected),
                child: const Text('Save')),
          ],
        ),
      ),
    );
    if (result != null && result.isNotEmpty) {
      await repo.updateSettings(weekendDays: result);
    }
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final csv = await ref.read(repositoryProvider).exportCsv();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/shiftlog_export.csv');
      await file.writeAsString(csv);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: 'ShiftLog export'),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _confirmImport(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Import backup?'),
        content: const Text(
            'This replaces all current data on this device with the contents '
            'of the backup file. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Import')),
        ],
      ),
    );
    if (ok == true && context.mounted) await importBackup(context, ref);
  }
}

String _weekendLabel(Set<int> weekend) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final ordered = weekend.toList()..sort();
  return ordered.isEmpty
      ? 'None'
      : ordered.map((w) => names[w - 1]).join(', ');
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  const _Tile(
      {required this.icon,
      required this.title,
      required this.value,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: scheme.surfaceContainerHigh,
      child: ListTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _StepperTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  const _StepperTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            IconButton.filledTonal(
              onPressed: onMinus,
              icon: const Icon(Icons.remove),
              visualDensity: VisualDensity.compact,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 64),
              alignment: Alignment.center,
              child: Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                      fontSize: 16)),
            ),
            IconButton.filledTonal(
              onPressed: onPlus,
              icon: const Icon(Icons.add),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
