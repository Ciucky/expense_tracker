// helpers/db_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'expenses.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, category TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
