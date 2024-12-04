
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" as p;

import '../models/model.dart';

abstract class DbHelper{
  static Database? _db;

  static int get _version => 1;

  static Future<void> init() async{
    if(_db != null)return;

    try{
      var databasePath = await getDatabasesPath();
      String path = p.join(databasePath, "notes.db");
      _db = await openDatabase(path, version: _version, onCreate: onCreate, onUpgrade: onUpdate);
    }catch (exeption){
      print(exeption);
    }
  }

  static void onCreate(Database db, int version) async {
    // When creating the db, create the table
    String sqlQuery = "CREATE TABLE Notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT , colorString TEXT)";
    await db.execute(sqlQuery);
  }

  static void onUpdate(Database db, int oldVersion, int version) async {
    // for updating the database
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    return await _db!.query(table);
  }

  static Future<int> insert(String table, Model model) async {
    return _db!.insert(table, model.toMap());
  }

  static Future<int> update(String table, Model model) async {
    return _db!.update(table, model.toMap(), where: "id = ?", whereArgs: [model.id]);
  }

  static Future<int> delete(String table, Model model) async {
    return _db!.delete(table, where: "id = ?", whereArgs: [model.id]);
  }
}