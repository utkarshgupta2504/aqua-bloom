import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const macosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> scheduleNotifications({
    required int frequencyMinutes,
    required String startTime,
    required String endTime,
    required bool soundEnabled,
    required bool vibrationEnabled,
  }) async {
    // Cancel existing notifications
    await _notifications.cancelAll();

    // Parse start and end times
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');

    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);

    // Calculate number of notifications
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    final totalMinutes = endMinutes - startMinutes;
    final numNotifications = (totalMinutes / frequencyMinutes).floor();

    // Schedule notifications
    for (var i = 0; i < numNotifications; i++) {
      final notificationTime = startMinutes + (i * frequencyMinutes);
      final hour = (notificationTime ~/ 60) % 24;
      final minute = notificationTime % 60;

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        i,
        'Time to Hydrate! 💧',
        _getRandomMessage(),
        tz.TZDateTime.from(scheduledDate, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'water_reminder_channel',
            'Water Reminders',
            channelDescription: 'Reminders to drink water',
            importance: Importance.high,
            priority: Priority.high,
            sound: soundEnabled
                ? RawResourceAndroidNotificationSound('notification')
                : null,
            enableVibration: vibrationEnabled,
          ),
          iOS: DarwinNotificationDetails(
            sound: soundEnabled ? 'notification.wav' : null,
            presentSound: soundEnabled,
            presentBadge: true,
            presentAlert: true,
          ),
          macOS: DarwinNotificationDetails(
            sound: soundEnabled ? 'notification.wav' : null,
            presentSound: soundEnabled,
            presentBadge: true,
            presentAlert: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  String _getRandomMessage() {
    final messages = [
      'Stay hydrated for better performance! 💪',
      'Time for a refreshing sip! 🌊',
      'Your body needs water! 💧',
      'Keep the momentum going! Stay hydrated! 🚀',
      'Water break time! 💦',
    ];
    return messages[DateTime.now().millisecondsSinceEpoch % messages.length];
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
