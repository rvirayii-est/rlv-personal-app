import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Database configuration
  static const String _databaseName = 'rlviray_app.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableUsers = 'users';
  static const String tableNotes = 'notes';

  // Users table columns
  static const String columnUserId = 'id';
  static const String columnUserName = 'name';
  static const String columnUserEmail = 'email';
  static const String columnUserCreatedAt = 'created_at';
  static const String columnUserUpdatedAt = 'updated_at';

  // Notes table columns
  static const String columnNoteId = 'id';
  static const String columnNoteTitle = 'title';
  static const String columnNoteContent = 'content';
  static const String columnNoteUserId = 'user_id';
  static const String columnNoteCreatedAt = 'created_at';
  static const String columnNoteUpdatedAt = 'updated_at';

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserName TEXT NOT NULL,
        $columnUserEmail TEXT UNIQUE NOT NULL,
        $columnUserCreatedAt TEXT NOT NULL,
        $columnUserUpdatedAt TEXT NOT NULL
      )
    ''');

    // Create notes table
    await db.execute('''
      CREATE TABLE $tableNotes (
        $columnNoteId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNoteTitle TEXT NOT NULL,
        $columnNoteContent TEXT,
        $columnNoteUserId INTEGER,
        $columnNoteCreatedAt TEXT NOT NULL,
        $columnNoteUpdatedAt TEXT NOT NULL,
        FOREIGN KEY ($columnNoteUserId) REFERENCES $tableUsers ($columnUserId) ON DELETE CASCADE
      )
    ''');

    print('Database tables created successfully');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Example: Add new column in version 2
      // if (oldVersion < 2) {
      //   await db.execute('ALTER TABLE $tableUsers ADD COLUMN phone TEXT');
      // }
    }
  }

  // Generic insert method
  Future<int> insert(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Generic query all method
  Future<List<Map<String, dynamic>>> queryAll(String table, {String? orderBy}) async {
    Database db = await database;
    return await db.query(table, orderBy: orderBy);
  }

  // Generic query by id
  Future<Map<String, dynamic>?> queryById(String table, int id, String idColumn) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // Generic query with where clause
  Future<List<Map<String, dynamic>>> queryWhere(
    String table,
    String where,
    List<dynamic> whereArgs,
    {String? orderBy}
  ) async {
    Database db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  // Generic update method
  Future<int> update(String table, Map<String, dynamic> row, int id, String idColumn) async {
    Database db = await database;
    return await db.update(
      table,
      row,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  // Generic delete method
  Future<int> delete(String table, int id, String idColumn) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  // Delete all rows in a table
  Future<int> deleteAll(String table) async {
    Database db = await database;
    return await db.delete(table);
  }

  // Get count of rows in a table
  Future<int> getCount(String table) async {
    Database db = await database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Execute raw query
  Future<List<Map<String, dynamic>>> rawQuery(String query, [List<dynamic>? arguments]) async {
    Database db = await database;
    return await db.rawQuery(query, arguments);
  }

  // Execute raw insert/update/delete
  Future<int> rawExecute(String query, [List<dynamic>? arguments]) async {
    Database db = await database;
    return await db.rawUpdate(query, arguments);
  }

  // Close database
  Future<void> close() async {
    Database db = await database;
    await db.close();
    _database = null;
  }

  // Delete database file
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
