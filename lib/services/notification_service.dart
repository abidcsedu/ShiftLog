import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Thin wrapper over flutter_local_notifications. All calls are guarded so a
/// platform/permission failure never crashes the app.
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _activeId = 1;
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
      await android?.requestNotificationsPermission();
      _ready = true;
    } catch (e) {
      debugPrint('NotificationService init failed: $e');
    }
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
