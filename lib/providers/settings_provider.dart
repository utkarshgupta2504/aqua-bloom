import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage;
  final NotificationService _notificationService;

  int _reminderFrequency = 60; // Default 60 minutes
  String _startTime = '08:00';
  String _endTime = '22:00';
  bool _remindersEnabled = true;
  bool _notificationSound = true;
  bool _vibration = true;

  SettingsProvider(this._storage, this._notificationService) {
    _loadSettings();
  }

  int get reminderFrequency => _reminderFrequency;
  String get startTime => _startTime;
  String get endTime => _endTime;
  bool get remindersEnabled => _remindersEnabled;
  bool get notificationSound => _notificationSound;
  bool get vibration => _vibration;

  Future<void> _loadSettings() async {
    _reminderFrequency = _storage.getReminderFrequency();
    _startTime = _storage.getStartTime();
    _endTime = _storage.getEndTime();
    _remindersEnabled = _storage.getRemindersEnabled();
    _notificationSound = _storage.getNotificationSound();
    _vibration = _storage.getVibration();
    notifyListeners();
  }

  Future<void> setReminderFrequency(int minutes) async {
    _reminderFrequency = minutes;
    await _storage.saveReminderFrequency(minutes);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> setStartTime(String time) async {
    _startTime = time;
    await _storage.saveStartTime(time);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> setEndTime(String time) async {
    _endTime = time;
    await _storage.saveEndTime(time);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> setRemindersEnabled(bool enabled) async {
    _remindersEnabled = enabled;
    await _storage.saveRemindersEnabled(enabled);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> setNotificationSound(bool enabled) async {
    _notificationSound = enabled;
    await _storage.saveNotificationSound(enabled);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> setVibration(bool enabled) async {
    _vibration = enabled;
    await _storage.saveVibration(enabled);
    await _updateNotifications();
    notifyListeners();
  }

  Future<void> _updateNotifications() async {
    if (_remindersEnabled) {
      await _notificationService.scheduleNotifications(
        frequencyMinutes: _reminderFrequency,
        startTime: _startTime,
        endTime: _endTime,
        soundEnabled: _notificationSound,
        vibrationEnabled: _vibration,
      );
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }
}
