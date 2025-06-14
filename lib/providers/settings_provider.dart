import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storage;
  final NotificationService _notificationService;
  bool _notificationsEnabled = true;
  int _frequencyMinutes = 60;
  String _startTime = '09:00';
  String _endTime = '21:00';
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  SettingsProvider(this._storage, this._notificationService) {
    _loadSettings();
  }

  bool get notificationsEnabled => _notificationsEnabled;
  int get frequencyMinutes => _frequencyMinutes;
  String get startTime => _startTime;
  String get endTime => _endTime;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  Future<void> _loadSettings() async {
    _notificationsEnabled = await _storage.getNotificationsEnabled();
    _frequencyMinutes = await _storage.getFrequencyMinutes();
    _startTime = await _storage.getStartTime();
    _endTime = await _storage.getEndTime();
    _soundEnabled = await _storage.getSoundEnabled();
    _vibrationEnabled = await _storage.getVibrationEnabled();
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.saveNotificationsEnabled(value);
    if (value) {
      await _scheduleNotifications();
    } else {
      await _notificationService.cancelAllNotifications();
    }
    notifyListeners();
  }

  Future<void> setFrequencyMinutes(int minutes) async {
    _frequencyMinutes = minutes;
    await _storage.saveFrequencyMinutes(minutes);
    if (_notificationsEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setStartTime(String time) async {
    _startTime = time;
    await _storage.saveStartTime(time);
    if (_notificationsEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setEndTime(String time) async {
    _endTime = time;
    await _storage.saveEndTime(time);
    if (_notificationsEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _storage.saveSoundEnabled(value);
    if (_notificationsEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setVibrationEnabled(bool value) async {
    _vibrationEnabled = value;
    await _storage.saveVibrationEnabled(value);
    if (_notificationsEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> _scheduleNotifications() async {
    // Cancel existing notifications
    await _notificationService.cancelAllNotifications();

    // Parse start and end times
    final startParts = _startTime.split(':');
    final endParts = _endTime.split(':');

    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);

    // Calculate number of notifications
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;
    final totalMinutes = endMinutes - startMinutes;
    final numNotifications = (totalMinutes / _frequencyMinutes).floor();

    // Schedule notifications
    for (var i = 0; i < numNotifications; i++) {
      final notificationTime = startMinutes + (i * _frequencyMinutes);
      final hour = (notificationTime ~/ 60) % 24;
      final minute = notificationTime % 60;

      final now = DateTime.now();
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notificationService.scheduleNotification(
        id: i,
        title: 'Time to Hydrate! 💧',
        body: _getRandomMessage(),
        scheduledTime: scheduledDate,
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
}
