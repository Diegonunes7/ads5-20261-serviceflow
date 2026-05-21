import 'package:sqflite/sqflite.dart';

import '../helpers/database_helper.dart';

class ReportingSnapshot {
  const ReportingSnapshot({
    required this.totalClientes,
    required this.totalTecnicos,
    required this.totalUsuarios,
    required this.totalOrdensServico,
    required this.totalPendencias,
    required this.pendingByModule,
    required this.generatedAt,
  });

  final int totalClientes;
  final int totalTecnicos;
  final int totalUsuarios;
  final int totalOrdensServico;
  final int totalPendencias;
  final Map<String, int> pendingByModule;
  final DateTime generatedAt;
}

class ReportingService {
  ReportingService({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  static const List<({String key, String table})> _pendingTargets = [
    (key: 'clientes', table: 'clientes'),
    (key: 'tecnicos', table: 'tecnicos'),
    (key: 'usuarios', table: 'usuarios'),
    (key: 'ordens_servico', table: 'ordens_servico'),
    (key: 'os_itens', table: 'os_itens'),
    (key: 'servicos', table: 'servicos'),
    (key: 'system_logs', table: 'system_logs'),
  ];

  Future<ReportingSnapshot> loadSnapshot() async {
    final db = await _dbHelper.database;

    final totalClientes = await _countByTable(db, 'clientes');
    final totalTecnicos = await _countByTable(db, 'tecnicos');
    final totalUsuarios = await _countByTable(db, 'usuarios');
    final totalOrdensServico = await _countByTable(db, 'ordens_servico');

    final pendingByModule = <String, int>{};
    for (final target in _pendingTargets) {
      pendingByModule[target.key] = await _countPendingByTable(db, target.table);
    }

    final totalPendencias = pendingByModule.values.fold<int>(
      0,
      (sum, count) => sum + count,
    );

    return ReportingSnapshot(
      totalClientes: totalClientes,
      totalTecnicos: totalTecnicos,
      totalUsuarios: totalUsuarios,
      totalOrdensServico: totalOrdensServico,
      totalPendencias: totalPendencias,
      pendingByModule: pendingByModule,
      generatedAt: DateTime.now(),
    );
  }

  Future<int> _countByTable(Database db, String tableName) async {
    final rows = await db.rawQuery('SELECT COUNT(*) AS total FROM $tableName');
    return _toInt(rows.first['total']) ?? 0;
  }

  Future<int> _countPendingByTable(Database db, String tableName) async {
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM $tableName WHERE is_sync = 0',
    );
    return _toInt(rows.first['total']) ?? 0;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
