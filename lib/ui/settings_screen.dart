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
            icon: Icons.business_outlined,
            title: 'Company',
            value: settings.companyName?.isNotEmpty == true
                ? settings.companyName!
                : 'Not set',
            onTap: () => _editText(context, repo, 'Company',
                settings.companyName, (v) => repo.updateSettings(companyName: v)),
          ),
          _Tile(
            icon: Icons.badge_outlined,
            title: 'Office ID',
            value: settings.officeId?.isNotEmpty == true
                ? settings.officeId!
                : 'Not set',
            onTap: () => _editText(context, repo, 'Office ID', settings.officeId,
                (v) => repo.updateSettings(officeId: v)),
          ),
          _Tile(
            icon: Icons.wc,
            title: 'Gender',
            value: gender.label,
            onTap: () => _editGender(context, repo, gender),
          ),
          _Tile(
            icon: Icons.cake_outlined,
            title: 'Date of birth',
            value:
                settings.dob == null ? 'Not set' : _ymd(settings.dob!),
            onTap: () => _editDob(context, repo, settings.dob),
          ),
          _Tile(
            icon: Icons.phone_outlined,
            title: 'Phone number',
            value: settings.phone?.isNotEmpty == true
                ? settings.phone!
                : 'Not set',
            onTap: () => _editText(context, repo, 'Phone number',
                settings.phone, (v) => repo.updateSettings(phone: v),
                keyboard: TextInputType.phone),
          ),
          _Tile(
            icon: Icons.event_available,
            title: 'Joining date',
            value: settings.joinDate == null
                ? 'Not set'
                : _ymd(settings.joinDate!),
            onTap: () => _editJoinDate(context, repo, settings.joinDate),
          ),
          _InfoTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Time at company',
            value: settings.joinDate == null
                ? 'Set joining date'
                : formatTenure(tenure(settings.joinDate!, DateTime.now())),
          ),

          _section(context, 'Office hours'),
          _Tile(
            icon: Icons.login,
            title: 'Start time',
            value: _hm(settings.officeStartMin),
            onTap: () => _pickMinutes(context, settings.officeStartMin,
                (m) => repo.updateSettings(officeStartMin: m)),
          ),
          _Tile(
            icon: Icons.logout,
            title: 'End time',
            value: _hm(settings.officeEndMin),
            onTap: () => _pickMinutes(context, settings.officeEndMin,
                (m) => repo.updateSettings(officeEndMin: m)),
          ),
          _InfoTile(
            icon: Icons.timelapse,
            // The effective target — Ramadan hours override office hours while
            // Ramadan mode is on, so show (and label) what's actually in force.
            title: settings.ramadanEnabled
                ? 'Daily target · Ramadan'
                : 'Daily target',
            value: formatDuration(effectiveTarget(
              officeStartMin: settings.officeStartMin,
              officeEndMin: settings.officeEndMin,
              ramadanEnabled: settings.ramadanEnabled,
              ramadanStartMin: settings.ramadanStartMin,
              ramadanEndMin: settings.ramadanEndMin,
            )),
          ),

          _section(context, 'Ramadan schedule'),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: scheme.surfaceContainerHigh,
            child: SwitchListTile(
              secondary: Icon(Icons.nightlight_round, color: scheme.primary),
              title: const Text('Ramadan mode',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Use shorter hours while enabled'),
              value: settings.ramadanEnabled,
              onChanged: (v) => repo.updateSettings(ramadanEnabled: v),
            ),
          ),
          if (settings.ramadanEnabled) ...[
            _Tile(
              icon: Icons.login,
              title: 'Ramadan start',
              value: _hm(settings.ramadanStartMin),
              onTap: () => _pickMinutes(context, settings.ramadanStartMin,
                  (m) => repo.updateSettings(ramadanStartMin: m)),
            ),
            _Tile(
              icon: Icons.logout,
              title: 'Ramadan end',
              value: _hm(settings.ramadanEndMin),
              onTap: () => _pickMinutes(context, settings.ramadanEndMin,
                  (m) => repo.updateSettings(ramadanEndMin: m)),
            ),
          ],

          _section(context, 'Work week & limits'),
          _Tile(
            icon: Icons.weekend,
            title: 'Weekend days',
            value: _weekendLabel(parseWeekend(settings.weekendDays)),
            onTap: () =>
                _editWeekend(context, repo, parseWeekend(settings.weekendDays)),
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

          _section(context, 'Security'),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: scheme.surfaceContainerHigh,
            child: SwitchListTile(
              secondary: Icon(Icons.fingerprint, color: scheme.primary),
              title: const Text('App lock',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Require device unlock to open ShiftLog'),
              value: settings.biometricLock,
              onChanged: (v) => repo.updateSettings(biometricLock: v),
            ),
          ),

          _section(context, 'Reminders'),
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: scheme.surfaceContainerHigh,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.login, color: scheme.primary),
                  title: const Text('Sign-in reminder',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      'Daily at ${_hm(settings.officeStartMin)}'),
                  value: settings.remindClockIn,
                  onChanged: (v) => repo.updateSettings(remindClockIn: v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(Icons.logout, color: scheme.primary),
                  title: const Text('Sign-out reminder',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle:
                      Text('Daily at ${_hm(settings.officeEndMin)}'),
                  value: settings.remindClockOut,
                  onChanged: (v) => repo.updateSettings(remindClockOut: v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(Icons.summarize, color: scheme.primary),
                  title: const Text('Weekly summary',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Sunday at 9:00 AM'),
                  value: settings.remindWeekly,
                  onChanged: (v) => repo.updateSettings(remindWeekly: v),
                ),
              ],
            ),
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

  /// Generic single-field text editor; calls [onSave] with the trimmed value
  /// ('' clears the field). Used for company, office ID, phone.
  Future<void> _editText(BuildContext context, repo, String label,
      String? current, Future<void> Function(String) onSave,
      {TextInputType? keyboard}) async {
    final controller = TextEditingController(text: current ?? '');
    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboard,
          decoration: InputDecoration(hintText: label),
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
    if (value != null) await onSave(value);
  }

  Future<void> _editDob(BuildContext context, repo, DateTime? current) async {
    final d = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Date of birth',
    );
    if (d != null) await repo.updateSettings(dob: d);
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
              title: Text(g.label),
              onTap: () => Navigator.pop(dialogContext, g),
            ),
        ],
      ),
    );
    if (g != null) await repo.updateSettings(gender: g);
  }

  Future<void> _editJoinDate(BuildContext context, repo, DateTime? current) async {
    final d = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Date you joined',
    );
    if (d != null) await repo.updateSettings(joinDate: d);
  }

  Future<void> _pickMinutes(
      BuildContext context, int current, void Function(int) onSet) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (t != null) onSet(t.hour * 60 + t.minute);
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

String _hm(int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  final period = h >= 12 ? 'PM' : 'AM';
  final hour12 = h % 12 == 0 ? 12 : h % 12;
  return '$hour12:${m.toString().padLeft(2, '0')} $period';
}

String _ymd(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// A non-interactive info row (e.g. computed values).
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoTile(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: scheme.surfaceContainerHigh,
      child: ListTile(
        leading: Icon(icon, color: scheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(value,
            style:
                TextStyle(color: scheme.primary, fontWeight: FontWeight.w800)),
      ),
    );
  }
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
