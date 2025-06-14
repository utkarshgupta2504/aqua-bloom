import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:io' show Platform;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle background notification tap
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const String _channelId = 'water_reminder_channel';
  static const String _channelName = 'Water Reminders';
  static const String _channelDescription =
      'Notifications for water intake reminders';

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'water_reminder',
          actions: [
            DarwinNotificationAction.plain('snooze_15', 'Snooze 15m'),
            DarwinNotificationAction.plain('snooze_30', 'Snooze 30m'),
            DarwinNotificationAction.plain('snooze_60', 'Snooze 1h'),
          ],
        ),
      ],
    );
    final macSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'water_reminder',
          actions: [
            DarwinNotificationAction.plain('snooze_15', 'Snooze 15m'),
            DarwinNotificationAction.plain('snooze_30', 'Snooze 30m'),
            DarwinNotificationAction.plain('snooze_60', 'Snooze 1h'),
          ],
        ),
      ],
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request permissions
    if (Platform.isIOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isMacOS) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      sound: const RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      playSound: true,
      enableLights: true,
      color: const Color(0xFF2196F3),
      ledColor: const Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
      actions: [
        const AndroidNotificationAction('snooze_15', 'Snooze 15m'),
        const AndroidNotificationAction('snooze_30', 'Snooze 30m'),
        const AndroidNotificationAction('snooze_60', 'Snooze 1h'),
      ],
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'water_reminder',
    );

    final macDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'water_reminder',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload ?? id.toString(),
    );
  }

  Future<void> snoozeNotification(int id, Duration duration) async {
    final now = DateTime.now();
    final snoozeTime = now.add(duration);
    await scheduleNotification(
      id: id,
      title: 'Time to Hydrate! 💧 (Snoozed)',
      body: 'Your snoozed reminder to stay hydrated!',
      scheduledTime: snoozeTime,
      payload: id.toString(),
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      // sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
      playSound: true,
      enableLights: true,
      color: Color(0xFF2196F3),
      ledColor: Color(0xFF2196F3),
      ledOnMs: 1000,
      ledOffMs: 500,
      actions: [
        AndroidNotificationAction('snooze_15', 'Snooze 15m'),
        AndroidNotificationAction('snooze_30', 'Snooze 30m'),
        AndroidNotificationAction('snooze_60', 'Snooze 1h'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
      categoryIdentifier: 'water_reminder',
    );

    const macDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'water_reminder',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: macDetails,
    );

    await _notifications.show(
      999, // Test notification ID
      'Test Notification 💧',
      'This is a test notification for Aqua Bloom',
      details,
      payload: '999',
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.actionId?.startsWith('snooze_') ?? false) {
      final minutes = int.parse(response.actionId!.split('_')[1]);
      snoozeNotification(
        int.tryParse(response.payload ?? '0') ?? 0,
        Duration(minutes: minutes),
      );
    }
  }
}
