import 'package:serviceflow/app/core/base/base.repository.dart';

import '../tecnico.model.dart';

class TecnicoRepository extends BaseRepository<Tecnico> {
  TecnicoRepository() : super((map) => Tecnico.fromMap(map));

  @override
  String get tableName => 'tecnicos';

  Future<Tecnico?> findByNome(String nome) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      where: 'nome = ?',
      whereArgs: [nome.trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return Tecnico.fromMap(rows.first);
  }
}
