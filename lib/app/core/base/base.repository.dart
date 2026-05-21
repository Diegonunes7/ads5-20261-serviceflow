import '../helpers/database_helper.dart';
import 'base.model.dart';

typedef ModelMapper<E extends BaseModel> = E Function(Map<String, dynamic> map);

abstract class BaseRepository<E extends BaseModel> {
  BaseRepository(
    this._fromMap, {
    DatabaseHelper? dbHelper,
  }) : dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper dbHelper;
  final ModelMapper<E> _fromMap;

  String get tableName;

  Future<int> insert(E entity) async {
    final db = await dbHelper.database;
    final map = Map<String, dynamic>.from(entity.toMap())..remove('id');
    return db.insert(tableName, map);
  }

  Future<int> update(E entity) async {
    final entityId = entity.id;
    if (entityId == null) {
      throw ArgumentError('Nao e possivel atualizar entidade sem id.');
    }

    final db = await dbHelper.database;
    final map = Map<String, dynamic>.from(entity.toMap())..remove('id');
    return db.update(
      tableName,
      map,
      where: 'id = ?',
      whereArgs: [entityId],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<E?> findById(int id) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromMap(rows.first);
  }

  Future<List<E>> findAll({
    String? orderBy,
  }) async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      orderBy: orderBy ?? 'created_at DESC',
    );
    return rows.map(_fromMap).toList();
  }

  Future<List<E>> findPendingSync() async {
    final db = await dbHelper.database;
    final rows = await db.query(
      tableName,
      where: 'is_sync = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
    return rows.map(_fromMap).toList();
  }

  Future<int> markAsSynced(int id) async {
    final db = await dbHelper.database;
    return db.update(
      tableName,
      {'is_sync': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
