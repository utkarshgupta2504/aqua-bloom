import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _currentIntakeKey = 'current_intake';
  static const String _targetIntakeKey = 'target_intake';
  static const String _lastLogDateKey = 'last_log_date';
  static const String _reminderFrequencyKey = 'reminder_frequency';
  static const String _startTimeKey = 'start_time';
  static const String _endTimeKey = 'end_time';
  static const String _remindersEnabledKey = 'reminders_enabled';
  static const String _notificationSoundKey = 'notification_sound';
  static const String _vibrationKey = 'vibration';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Hydration Data
  Future<void> saveCurrentIntake(double value) async {
    await _prefs.setDouble(_currentIntakeKey, value);
  }

  double getCurrentIntake() {
    return _prefs.getDouble(_currentIntakeKey) ?? 0.0;
  }

  Future<void> saveTargetIntake(double value) async {
    await _prefs.setDouble(_targetIntakeKey, value);
  }

  double getTargetIntake() {
    return _prefs.getDouble(_targetIntakeKey) ?? 2500.0; // Default 2.5L
  }

  Future<void> saveLastLogDate(String date) async {
    await _prefs.setString(_lastLogDateKey, date);
  }

  String? getLastLogDate() {
    return _prefs.getString(_lastLogDateKey);
  }

  // Settings Data
  Future<void> saveReminderFrequency(int minutes) async {
    await _prefs.setInt(_reminderFrequencyKey, minutes);
  }

  int getReminderFrequency() {
    return _prefs.getInt(_reminderFrequencyKey) ?? 60; // Default 60 minutes
  }

  Future<void> saveStartTime(String time) async {
    await _prefs.setString(_startTimeKey, time);
  }

  String getStartTime() {
    return _prefs.getString(_startTimeKey) ?? '08:00'; // Default 8 AM
  }

  Future<void> saveEndTime(String time) async {
    await _prefs.setString(_endTimeKey, time);
  }

  String getEndTime() {
    return _prefs.getString(_endTimeKey) ?? '22:00'; // Default 10 PM
  }

  Future<void> saveRemindersEnabled(bool enabled) async {
    await _prefs.setBool(_remindersEnabledKey, enabled);
  }

  bool getRemindersEnabled() {
    return _prefs.getBool(_remindersEnabledKey) ?? true;
  }

  Future<void> saveNotificationSound(bool enabled) async {
    await _prefs.setBool(_notificationSoundKey, enabled);
  }

  bool getNotificationSound() {
    return _prefs.getBool(_notificationSoundKey) ?? true;
  }

  Future<void> saveVibration(bool enabled) async {
    await _prefs.setBool(_vibrationKey, enabled);
  }

  bool getVibration() {
    return _prefs.getBool(_vibrationKey) ?? true;
  }
}
