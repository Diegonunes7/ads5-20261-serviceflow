import '../helpers/app.config.dart';
import '../../modules/clientes/data/cliente.schedule.dart';
import '../../modules/usuarios/data/usuario.schedule.dart';
import 'schedule_manager.dart';

class SyncSystemInitializer {
  SyncSystemInitializer._();

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    final manager = ScheduleManager();
    manager.register(ClienteSchedule());
    manager.register(UsuarioSchedule());

    if (_hasValidRemoteConfig()) {
      manager.startAll();
    }

    _initialized = true;
  }

  static Future<Map<String, int>> forceSyncAll() {
    return ScheduleManager().forceSyncAll();
  }

  static Future<int> syncFeature(String featureName) {
    return ScheduleManager().syncFeature(featureName);
  }

  static bool _hasValidRemoteConfig() {
    return !AppConfig.apiBaseUrl.contains('your-supabase-url');
  }
}
