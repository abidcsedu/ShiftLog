import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../state/providers.dart';

String _two(int n) => n.toString().padLeft(2, '0');

/// Exports a full JSON backup to a temp file and opens the share sheet so the
/// user can save it (Drive, email, files, SD card…).
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final json = await ref.read(repositoryProvider).exportJson();
    final dir = await getTemporaryDirectory();
    final now = DateTime.now();
    final stamp = '${now.year}${_two(now.month)}${_two(now.day)}';
    final file = File('${dir.path}/shiftlog_backup_$stamp.json');
    await file.writeAsString(json);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: 'ShiftLog backup'),
    );
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
  }
}

/// Lets the user pick a backup file and replaces all local data with it.
/// Returns true on success. Caller is responsible for any confirmation prompt.
Future<bool> importBackup(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  final result = await FilePicker.platform.pickFiles(type: FileType.any);
  final path = result?.files.single.path;
  if (path == null) return false;
  try {
    final text = await File(path).readAsString();
    await ref.read(repositoryProvider).importJson(text);
    messenger.showSnackBar(
        const SnackBar(content: Text('Backup imported successfully.')));
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Import failed: $e')));
    return false;
  }
}
