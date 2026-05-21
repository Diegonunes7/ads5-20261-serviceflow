import 'package:serviceflow/app/core/base/base.repository.dart';

import '../cliente.model.dart';

class ClienteRepository extends BaseRepository<Cliente> {
  ClienteRepository() : super((map) => Cliente.fromMap(map));

  @override
  String get tableName => 'clientes';

  Future<Cliente?> findByEmail(String email) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email.trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return Cliente.fromMap(rows.first);
  }
}
