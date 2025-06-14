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
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _frequencyMinutesKey = 'frequency_minutes';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Hydration Data
  Future<void> saveCurrentIntake(double value) async {
    await _prefs.setDouble(_currentIntakeKey, value);
  }

  Future<double> getCurrentIntake() async {
    return _prefs.getDouble(_currentIntakeKey) ?? 0.0;
  }

  Future<void> saveTargetIntake(double value) async {
    await _prefs.setDouble(_targetIntakeKey, value);
  }

  Future<double> getTargetIntake() async {
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

  Future<String> getStartTime() async {
    return _prefs.getString(_startTimeKey) ?? '09:00';
  }

  Future<void> saveEndTime(String time) async {
    await _prefs.setString(_endTimeKey, time);
  }

  Future<String> getEndTime() async {
    return _prefs.getString(_endTimeKey) ?? '21:00';
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

  // Notification settings methods
  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<int> getFrequencyMinutes() async {
    return _prefs.getInt(_frequencyMinutesKey) ?? 60;
  }

  Future<void> saveFrequencyMinutes(int minutes) async {
    await _prefs.setInt(_frequencyMinutesKey, minutes);
  }

  Future<bool> getSoundEnabled() async {
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> saveSoundEnabled(bool enabled) async {
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  Future<bool> getVibrationEnabled() async {
    return _prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> saveVibrationEnabled(bool enabled) async {
    await _prefs.setBool(_vibrationEnabledKey, enabled);
  }
}
