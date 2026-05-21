import 'package:serviceflow/app/core/base/base.repository.dart';

import '../usuario.model.dart';

class UsuarioRepository extends BaseRepository<Usuario> {
  UsuarioRepository() : super((map) => Usuario.fromMap(map));

  @override
  String get tableName => 'usuarios';

  Future<Usuario?> findByEmail(String email) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email.trim()],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return Usuario.fromMap(rows.first);
  }
}
