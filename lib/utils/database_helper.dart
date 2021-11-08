import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const dbname = "myDatabase.db";
  static const dbVersion = 1;
  static const tableName = "myTable";
  static const columnId = "id";
  static const columnEnglish = "english";
  static const columnVietnamese = "vietnamese";
  static const columnStatus = "status";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initiateDatabase();
    return _database;
  }

  initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    var exists = await databaseExists(path);
    if (exists)
      {
        print('dbname exists');
        //await deleteDatabase(path);
      }
    //await deleteDatabase(path);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int dbversion) async {
    return await db.execute('''
         CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,$columnEnglish TEXT NOT NULL,$columnVietnamese TEXT NOT NULL,$columnStatus INTEGER NOT NULL)
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    row.removeWhere((key, value) => key=='id');
    return await db!.insert(tableName, row,conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    Database? db = await instance.database;
    return await db!.query(tableName,orderBy: 'id desc');
  }

  Future<List<Map<String, dynamic>>> getById(String tableName,String newWord) async {
    Database? db = await instance.database;
    return db!.query(tableName, where: "english = ?", whereArgs: [newWord], limit: 1);
  }

  Future<List<Map<String, dynamic>>> queryNotification(String tableName) async {
    Database? db = await instance.database;
    return await db!.query(tableName,where: "status = 0",orderBy: 'id desc');
  }

  Future<int> queryById(String sWord) async {
    Database? db = await instance.database;
    String whereString = '${DatabaseHelper.columnEnglish} = ?';
    List<dynamic> whereArguments = [sWord];
    List<Map> result = await db!.query(DatabaseHelper.tableName,
        where: whereString, whereArgs: whereArguments);
    return result.length;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id=row['id'];
    return await db!
        .update(tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!
        .delete(tableName, where: '$columnId=?', whereArgs: [id]);
  }

  Future<void> delDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final String path = join(directory.path, dbname);
    deleteDatabase(path);
  }
}
