import '../helpers/database_helper.dart';

class SyncQueueItem {
  const SyncQueueItem({
    required this.featureKey,
    required this.label,
    required this.tableName,
    required this.pendingCount,
  });

  final String featureKey;
  final String label;
  final String tableName;
  final int pendingCount;
}

class SyncQueueService {
  SyncQueueService({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  static const List<({String key, String label, String table})> _targets = [
    (key: 'clientes', label: 'Clientes', table: 'clientes'),
    (key: 'tecnicos', label: 'Tecnicos', table: 'tecnicos'),
    (key: 'usuarios', label: 'Usuarios', table: 'usuarios'),
    (key: 'ordens_servico', label: 'Ordens de Servico', table: 'ordens_servico'),
    (key: 'os_itens', label: 'Itens da O.S.', table: 'os_itens'),
    (key: 'servicos', label: 'Servicos', table: 'servicos'),
    (key: 'system_logs', label: 'Logs do Sistema', table: 'system_logs'),
  ];

  Future<List<SyncQueueItem>> getPendingQueue() async {
    final db = await _dbHelper.database;
    final result = <SyncQueueItem>[];

    for (final target in _targets) {
      final rows = await db.rawQuery(
        'SELECT COUNT(*) AS total FROM ${target.table} WHERE is_sync = 0',
      );

      final rawTotal = rows.first['total'];
      final total = _toInt(rawTotal) ?? 0;

      result.add(
        SyncQueueItem(
          featureKey: target.key,
          label: target.label,
          tableName: target.table,
          pendingCount: total,
        ),
      );
    }

    return result;
  }

  Future<int> getTotalPending() async {
    final queue = await getPendingQueue();
    return queue.fold<int>(0, (sum, item) => sum + item.pendingCount);
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
