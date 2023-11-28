import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/cash_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cash.db');
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE cash (id INTEGER PRIMARY KEY AUTOINCREMENT, hundredRupeeNoteCount INTEGER, twoHundredRupeeNoteCount INTEGER, fiveHundredRupeeNoteCount INTEGER, thousandRupeeNoteCount INTEGER, twoThousandRupeeNoteCount INTEGER, dateTime TEXT)");
  }

  Future<CashModel> insert(CashModel cashModel) async {
    var databaseClient = await database;
    await databaseClient!.insert('cash', cashModel.toMap());
    return cashModel;
  }

  Future<List<CashModel>> getCashList() async {
    var databaseClient = await database;
    final List<Map<String, Object?>> queryResult =
        await databaseClient!.query('cash');

    return queryResult.map((e) => CashModel.fromMap(e)).toList();
  }

  Future<void> updateCashStock(List<CashModel> updatedCashStock) async {
    try {
      var databaseClient = await database;

      for (var cashModel in updatedCashStock) {
        await databaseClient!.update(
          'cash',
          cashModel.toMap(),
          where: 'id = ?',
          whereArgs: [cashModel.id], // Assuming 'id' is the primary key
        );
      }

      print('Cash stock updated successfully!');
    } catch (error) {
      print('Error updating cash stock: $error');
      throw error;
    }
  }
}
