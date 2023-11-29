import 'package:cash_withdrawer/data/models/denomination_count_model.dart';
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

    await database.execute(
        "CREATE TABLE denominationCount (id INTEGER PRIMARY KEY AUTOINCREMENT, hundredRupeeTotalNoteCount INTEGER, twoHundredRupeeTotalNoteCount INTEGER, fiveHundredRupeeTotalNoteCount INTEGER, thousandRupeeTotalNoteCount INTEGER, twoThousandRupeeTotalNoteCount INTEGER)");
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

  Future<DenominationCountModel> insertIntoDenominationCount(
      DenominationCountModel denominationCount) async {
    var databaseClient = await database;
    List<DenominationCountModel> existingDenominationCounts =
        await getDenominationCountList();
    if (existingDenominationCounts.isEmpty) {
      await databaseClient!
          .insert('denominationCount', denominationCount.toMap());
    } else {
      DenominationCountModel existingDenominationCount =
          existingDenominationCounts.first;
      await databaseClient!.update(
        'denominationCount',
        {
          'hundredRupeeTotalNoteCount':
              denominationCount.hundredRupeeTotalNoteCount,
          'twoHundredRupeeTotalNoteCount':
              denominationCount.twoHundredRupeeTotalNoteCount,
          'fiveHundredRupeeTotalNoteCount':
              denominationCount.fiveHundredRupeeTotalNoteCount,
          'thousandRupeeTotalNoteCount':
              denominationCount.thousandRupeeTotalNoteCount,
          'twoThousandRupeeTotalNoteCount':
              denominationCount.twoThousandRupeeTotalNoteCount,
        },
        where: 'id = ?',
        whereArgs: [existingDenominationCount.id],
      );
    }
    return denominationCount;
  }

  Future<List<DenominationCountModel>> getDenominationCountList() async {
    var databaseClient = await database;
    final List<Map<String, Object?>> queryResult =
        await databaseClient!.query('denominationCount');

    return queryResult.map((e) => DenominationCountModel.fromMap(e)).toList();
  }
}
