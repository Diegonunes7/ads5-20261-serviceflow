import '../base/base.schedule.dart';

class ScheduleManager {
  ScheduleManager._internal();

  static final ScheduleManager _instance = ScheduleManager._internal();

  factory ScheduleManager() => _instance;

  final Map<String, BaseSchedule<dynamic, dynamic, dynamic>> _schedules = {};

  void register(BaseSchedule<dynamic, dynamic, dynamic> schedule) {
    _schedules[schedule.featureName] = schedule;
  }

  void unregister(String featureName) {
    final schedule = _schedules.remove(featureName);
    schedule?.stop();
  }

  List<String> getRegisteredFeatures() {
    return _schedules.keys.toList(growable: false);
  }

  Future<Map<String, int>> forceSyncAll() async {
    final result = <String, int>{};
    for (final entry in _schedules.entries) {
      try {
        result[entry.key] = await entry.value.syncNow();
      } catch (_) {
        result[entry.key] = 0;
      }
    }
    return result;
  }

  Future<int> syncFeature(String featureName) async {
    final schedule = _schedules[featureName];
    if (schedule == null) return 0;

    try {
      return await schedule.syncNow();
    } catch (_) {
      return 0;
    }
  }

  void startAll() {
    for (final schedule in _schedules.values) {
      schedule.start();
    }
  }

  void stopAll() {
    for (final schedule in _schedules.values) {
      schedule.stop();
    }
  }

  Map<String, dynamic> getStatus() {
    final running = _schedules.values.where((item) => item.isRunning).length;
    return {
      'registered_features': getRegisteredFeatures(),
      'registered_count': _schedules.length,
      'running_count': running,
    };
  }
}
