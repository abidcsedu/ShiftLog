import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Thin wrapper over flutter_local_notifications. All calls are guarded so a
/// platform/permission failure never crashes the app.
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _tzReady = false;

  static const _activeId = 1;
  // Stable IDs for the scheduled reminders.
  static const _remindClockInId = 10;
  static const _remindClockOutId = 11;
  static const _remindWeeklyId = 12;

  static const _activeChannel = AndroidNotificationChannel(
    'active_session',
    'Active session',
    description: 'Ongoing notification while you are clocked in',
    importance: Importance.low,
  );
  static const _statusChannel = AndroidNotificationChannel(
    'status',
    'Status updates',
    description: 'Clock-in / clock-out confirmations',
    importance: Importance.defaultImportance,
  );
  static const _reminderChannel = AndroidNotificationChannel(
    'reminders',
    'Reminders',
    description: 'Scheduled clock-in / clock-out / weekly reminders',
    importance: Importance.high,
  );

  Future<void> init() async {
    try {
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(settings: settings);
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await android?.createNotificationChannel(_activeChannel);
      await android?.createNotificationChannel(_statusChannel);
      await android?.createNotificationChannel(_reminderChannel);
      await android?.requestNotificationsPermission();
      await _initTimezone();
      _ready = true;
    } catch (e) {
      debugPrint('NotificationService init failed: $e');
    }
  }

  Future<void> _initTimezone() async {
    try {
      tzdata.initializeTimeZones();
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      _tzReady = true;
    } catch (e) {
      debugPrint('timezone init failed: $e');
    }
  }

  /// Next occurrence of [hour]:[minute] in local time (today if still ahead,
  /// otherwise tomorrow).
  tz.TZDateTime _nextDaily(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
    return when;
  }

  /// Next occurrence of [weekday] (Mon=1..Sun=7) at [hour]:[minute].
  tz.TZDateTime _nextWeekly(int weekday, int hour, int minute) {
    var when = _nextDaily(hour, minute);
    while (when.weekday != weekday) {
      when = when.add(const Duration(days: 1));
    }
    return when;
  }

  NotificationDetails get _reminderDetails => const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          'Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

  /// Reconcile the three scheduled reminders against the current settings.
  /// [startMin]/[endMin] are office start/end as minutes-from-midnight.
  Future<void> syncReminders({
    required bool clockIn,
    required bool clockOut,
    required bool weekly,
    required int startMin,
    required int endMin,
  }) async {
    if (!_ready || !_tzReady) return;
    await _cancel(_remindClockInId);
    await _cancel(_remindClockOutId);
    await _cancel(_remindWeeklyId);
    try {
      if (clockIn) {
        await _scheduleDaily(_remindClockInId, 'Time to sign in',
            'Start your work day in ShiftLog.', startMin ~/ 60, startMin % 60);
      }
      if (clockOut) {
        await _scheduleDaily(_remindClockOutId, 'Time to sign out',
            'Don’t forget to clock out in ShiftLog.', endMin ~/ 60,
            endMin % 60);
      }
      if (weekly) {
        // Sunday 9:00 AM (start of the Sun–Thu work week).
        await _plugin.zonedSchedule(
          id: _remindWeeklyId,
          title: 'Weekly summary',
          body: 'Review last week’s hours and plan the week ahead.',
          scheduledDate: _nextWeekly(DateTime.sunday, 9, 0),
          notificationDetails: _reminderDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } catch (e) {
      debugPrint('syncReminders failed: $e');
    }
  }

  Future<void> _scheduleDaily(
      int id, String title, String body, int hour, int minute) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextDaily(hour, minute),
      notificationDetails: _reminderDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule a one-off reminder for a due action item. [id] is the item's
  /// stable id, reused as the notification id so it can be cancelled/updated.
  Future<void> scheduleItemReminder(int id, String text, DateTime due) async {
    if (!_ready || !_tzReady || id == 0) return;
    if (!due.isAfter(DateTime.now())) return;
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: 'Task due',
        body: text,
        scheduledDate: tz.TZDateTime.from(due, tz.local),
        notificationDetails: _reminderDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('scheduleItemReminder failed: $e');
    }
  }

  Future<void> cancelItemReminder(int id) async {
    if (id == 0) return;
    await _cancel(id);
  }

  Future<void> _cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (_) {}
  }

  /// Persistent, non-dismissible notification shown while clocked in.
  Future<void> showActiveSession(DateTime since) async {
    if (!_ready) return;
    try {
      final t =
          '${_two(since.hour > 12 ? since.hour - 12 : (since.hour == 0 ? 12 : since.hour))}'
          ':${_two(since.minute)} ${since.hour >= 12 ? 'PM' : 'AM'}';
      await _plugin.show(
        id: _activeId,
        title: 'Clocked in',
        body: 'Working since $t — tap the app to clock out.',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'active_session',
            'Active session',
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            importance: Importance.low,
            priority: Priority.low,
            category: AndroidNotificationCategory.stopwatch,
          ),
        ),
      );
    } catch (e) {
      debugPrint('showActiveSession failed: $e');
    }
  }

  Future<void> clearActiveSession() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _activeId);
    } catch (_) {}
  }

  /// Brief confirmation toast-style notification.
  Future<void> status(String title, String body) async {
    if (!_ready) return;
    try {
      await _plugin.show(
        id: 2,
        title: title,
        body: body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails('status', 'Status updates',
              importance: Importance.defaultImportance),
        ),
      );
    } catch (_) {}
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
