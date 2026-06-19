import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';

import '../data/database.dart';
import '../data/repository.dart';
import '../domain/enums.dart';
import '../domain/work_logic.dart';

/// Bridges app state to the Android home-screen widget and handles its
/// "Sign In/Out" button taps (which run in a background isolate).
class WidgetService {
  static const _androidName = 'ShiftLogWidget';
  static const _qualified = 'tech.innospace.shiftlog.ShiftLogWidget';

  /// Push the current day's total + clock state to the widget.
  static Future<void> sync(Repository repo) async {
    try {
      final today =
          await repo.watchSessionsForDay(dayKey(DateTime.now())).first;
      final clockedIn = today.any((s) => s.isOpen);
      final total = totalForDay(today);
      await HomeWidget.saveWidgetData<String>('duration', formatDuration(total));
      await HomeWidget.saveWidgetData<String>(
          'status', clockedIn ? 'Clocked in' : 'Not clocked in');
      await HomeWidget.saveWidgetData<String>(
          'button', clockedIn ? 'Sign Out' : 'Sign In');
      await HomeWidget.updateWidget(
          androidName: _androidName, qualifiedAndroidName: _qualified);
    } catch (_) {
      // Widget not added / platform unsupported — ignore.
    }
  }
}

/// Background callback for the widget button. Runs without the app UI.
@pragma('vm:entry-point')
Future<void> widgetInteractiveCallback(Uri? uri) async {
  if (uri?.host != 'toggle') return;
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  final repo = Repository(db);
  try {
    final open = await db.openSessionForDay(dayKey(DateTime.now()));
    if (open != null) {
      await repo.clockOut();
    } else {
      await repo.clockIn(WorkMode.office); // widget sign-in defaults to Office
    }
    await WidgetService.sync(repo);
  } finally {
    await db.close();
  }
}
