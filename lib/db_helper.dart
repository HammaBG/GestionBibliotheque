import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // Singleton instance
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  // Get or initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'library.db'); // Consistent name for the database

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  // Create tables
  static Future<void> createTables(Database db) async {
    await db.execute('''
      CREATE TABLE ecrivains (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        tel TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE livres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        isbn TEXT NOT NULL,
        dateSortie TEXT NOT NULL,
        photo TEXT,
        ecrivainId INTEGER NOT NULL,
        FOREIGN KEY (ecrivainId) REFERENCES ecrivains (id)
      )
    ''');
  }

  // Insert data into a table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  // Update data in a table
  Future<int> update(
      String table,
      Map<String, dynamic> data,
      String whereClause,
      List<Object> whereArgs,
      ) async {
    final db = await database;
    return await db.update(table, data, where: whereClause, whereArgs: whereArgs);
  }

  // Delete data from a table
  Future<int> delete(
      String table,
      String whereClause,
      List<Object> whereArgs,
      ) async {
    final db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  // Fetch all rows from a table
  Future<List<Map<String, dynamic>>> fetchAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Fetch rows with specific criteria
  Future<List<Map<String, dynamic>>> fetchWhere(
      String table,
      String whereClause,
      List<Object> whereArgs,
      ) async {
    final db = await database;
    return await db.query(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> fetchAllBooks() async {
    final db = await database;
    return await db.query('livres');
  }
  Future<void> insertBook(Map<String, dynamic> book) async {
    final db = await database;
    await db.insert('livres', book);
  }
  Future<int> updateBook(Map<String, dynamic> book, int id) async {
    final db = await database;
    return await db.update('livres', book, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete('livres', where: 'id = ?', whereArgs: [id]);
  }
  Future<List<Map<String, dynamic>>> fetchAllBooksWithEcrivain() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT livres.*, ecrivains.nom AS ecrivain_nom, ecrivains.prenom AS ecrivain_prenom
    FROM livres
    INNER JOIN ecrivains ON livres.ecrivainId = ecrivains.id
  ''');
  }


}
