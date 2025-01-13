import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';


class DBHelper {

  static Future<void> createTables(Database database) async {
    await database.execute('''
      CREATE TABLE ecrivains (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        prenom TEXT NOT NULL,
        tel TEXT NOT NULL
      )
    ''');
    await database.execute('''
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
  static Future<Database> db() async  {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'demo.db');
    return openDatabase('first.db' , version: 1 , onCreate:(Database database, int version) async {
      await createTables(database);
    });
  }
}
