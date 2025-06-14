import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';

class HydrationProvider with ChangeNotifier {
  final StorageService _storage;
  double _currentIntake = 0.0;
  double _targetIntake = 2500.0; // Default 2.5L
  double? _lastIntake; // Track the last water intake for undo
  String? _lastLogDate;

  HydrationProvider(this._storage) {
    _loadData();
  }

  double get currentIntake => _currentIntake;
  double get targetIntake => _targetIntake;
  double? get lastIntake => _lastIntake;
  double get progress => _currentIntake / _targetIntake;
  String get formattedCurrentIntake => '${_currentIntake.toStringAsFixed(0)}';
  String get formattedTargetIntake => '${_targetIntake.toStringAsFixed(0)}';
  String get progressPercentage => '${(progress * 100).toStringAsFixed(0)}%';

  Future<void> _loadData() async {
    _currentIntake = await _storage.getCurrentIntake();
    _targetIntake = await _storage.getTargetIntake();
    _lastLogDate = await _storage.getLastLogDate();
    _checkAndResetDaily();
    notifyListeners();
  }

  void _checkAndResetDaily() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (_lastLogDate != today) {
      _currentIntake = 0.0;
      _storage.saveCurrentIntake(0.0);
      _storage.saveLastLogDate(today);
    }
  }

  Future<void> logWater(double amount) async {
    _lastIntake = amount; // Store the last intake amount
    _currentIntake = (_currentIntake + amount).clamp(0.0, double.infinity);
    await _storage.saveCurrentIntake(_currentIntake);
    notifyListeners();
  }

  Future<void> setTargetIntake(double target) async {
    _targetIntake = target;
    await _storage.saveTargetIntake(target);
    notifyListeners();
  }

  Future<void> resetDaily() async {
    _currentIntake = 0.0;
    _lastIntake = null;
    await _storage.saveCurrentIntake(0.0);
    notifyListeners();
  }

  Future<void> undoLastIntake() async {
    if (_lastIntake != null) {
      _currentIntake =
          (_currentIntake - _lastIntake!).clamp(0.0, double.infinity);
      await _storage.saveCurrentIntake(_currentIntake);
      _lastIntake = null; // Clear the last intake after undoing
      notifyListeners();
    }
  }
}
