import 'package:serviceflow/app/core/base/base.repository.dart';

import '../ordem_servico.model.dart';

class ClienteOption {
  const ClienteOption({
    required this.id,
    required this.nome,
  });

  final int id;
  final String nome;
}

class TecnicoOption {
  const TecnicoOption({
    required this.id,
    required this.nome,
  });

  final int id;
  final String nome;
}

class OrdemServicoRepository extends BaseRepository<OrdemServico> {
  OrdemServicoRepository() : super((map) => OrdemServico.fromMap(map));

  @override
  String get tableName => 'ordens_servico';

  Future<List<ClienteOption>> findClientesAtivos() async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'clientes',
      columns: ['id', 'nome'],
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'nome ASC',
    );

    return rows
        .map(
          (row) => ClienteOption(
            id: _toInt(row['id']) ?? 0,
            nome: row['nome']?.toString() ?? 'Sem nome',
          ),
        )
        .where((item) => item.id > 0)
        .toList();
  }

  Future<List<TecnicoOption>> findTecnicosAtivos() async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'tecnicos',
      columns: ['id', 'nome'],
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'nome ASC',
    );

    return rows
        .map(
          (row) => TecnicoOption(
            id: _toInt(row['id']) ?? 0,
            nome: row['nome']?.toString() ?? 'Sem nome',
          ),
        )
        .where((item) => item.id > 0)
        .toList();
  }

  Future<bool> clienteAtivoExiste(int id) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'clientes',
      columns: ['id'],
      where: 'id = ? AND ativo = ?',
      whereArgs: [id, 1],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<bool> tecnicoAtivoExiste(int id) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      'tecnicos',
      columns: ['id'],
      where: 'id = ? AND ativo = ?',
      whereArgs: [id, 1],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
