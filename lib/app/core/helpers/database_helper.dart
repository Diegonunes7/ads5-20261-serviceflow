import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'app.config.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  Database? _database;

  Future<void> initialize() async {
    await database;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final filePath = path.join(dbPath, AppConfig.databaseName);

    return openDatabase(
      filePath,
      version: AppConfig.databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supabase_id TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        nome_completo TEXT NOT NULL,
        grupo_id TEXT NOT NULL,
        perfil TEXT DEFAULT 'tecnico',
        ultimo_login TEXT,
        avatar_local_path TEXT,
        configuracoes TEXT,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL,
        telefone TEXT NOT NULL,
        documento TEXT,
        endereco TEXT,
        cidade TEXT,
        estado TEXT,
        cep TEXT,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS tecnicos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        especialidade TEXT,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS servicos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        preco REAL NOT NULL,
        tempo_estimado TEXT,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ordens_servico (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER NOT NULL,
        tecnico_id INTEGER NOT NULL,
        observacao TEXT,
        pecas_aplicadas TEXT,
        valor_pecas REAL DEFAULT 0,
        foto_antes TEXT,
        foto_depois TEXT,
        assinatura TEXT,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
        FOREIGN KEY (tecnico_id) REFERENCES tecnicos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS os_itens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        os_id INTEGER NOT NULL,
        servico_id INTEGER NOT NULL,
        descricao_snapshot TEXT,
        preco_snapshot REAL,
        ativo INTEGER DEFAULT 1,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (os_id) REFERENCES ordens_servico(id),
        FOREIGN KEY (servico_id) REFERENCES servicos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS system_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        level TEXT NOT NULL,
        source TEXT NOT NULL,
        operation TEXT NOT NULL,
        message TEXT NOT NULL,
        metadata TEXT,
        timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
        is_sync INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == newVersion) return;
    // Estrategia simples para fase inicial do projeto.
    await _onCreate(db, newVersion);
  }
}
