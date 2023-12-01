import 'package:cash_withdrawer/data/models/denomination_count_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../models/cash_model.dart';
import '../models/withdraw_history_model.dart';

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

    await database.execute(
        "CREATE TABLE withdrawalHistory (id INTEGER PRIMARY KEY AUTOINCREMENT, withdrawnAmount INTEGER, dateTime TEXT)");
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

  Future<void> updateDatabase(Map<int, int> updatedNoteCounts) async {
    var databaseClient = await database;

    List<DenominationCountModel> existingDenominationCounts =
        await getDenominationCountList();

    int updatedCountForHundred =
        existingDenominationCounts.first.hundredRupeeTotalNoteCount! -
            (updatedNoteCounts[100] ?? 0);
    int updatedCountForTwoHundred =
        existingDenominationCounts.first.twoHundredRupeeTotalNoteCount! -
            (updatedNoteCounts[200] ?? 0);
    int updatedCountForFiveHundred =
        existingDenominationCounts.first.fiveHundredRupeeTotalNoteCount! -
            (updatedNoteCounts[500] ?? 0);
    int updatedCountForThousand =
        existingDenominationCounts.first.thousandRupeeTotalNoteCount! -
            (updatedNoteCounts[1000] ?? 0);
    int updatedCountForTowThousand =
        existingDenominationCounts.first.twoThousandRupeeTotalNoteCount! -
            (updatedNoteCounts[2000] ?? 0);

    DenominationCountModel updatedDenominationCount = DenominationCountModel(
        hundredRupeeTotalNoteCount: updatedCountForHundred,
        twoHundredRupeeTotalNoteCount: updatedCountForTwoHundred,
        fiveHundredRupeeTotalNoteCount: updatedCountForFiveHundred,
        thousandRupeeTotalNoteCount: updatedCountForThousand,
        twoThousandRupeeTotalNoteCount: updatedCountForTowThousand);

    print('updatedDenominationCount: $updatedDenominationCount');
    await insertIntoDenominationCount(updatedDenominationCount);
  }

  Future<List<DenominationCountModel>> getDenominationCountList() async {
    var databaseClient = await database;
    final List<Map<String, Object?>> queryResult =
        await databaseClient!.query('denominationCount');

    return queryResult.map((e) => DenominationCountModel.fromMap(e)).toList();
  }
  
  Future<WithdrawHistoryModel> insertIntoWithdrawHistory(WithdrawHistoryModel withdrawHistoryModel)async{
    var databaseClient = await database;
    await databaseClient!.insert('withdrawalHistory', withdrawHistoryModel.toMap());
    print('insertIntoWithdrawHistory');
    return withdrawHistoryModel;
  }

  Future<List<WithdrawHistoryModel>> getWithdrawList() async {
    var databaseClient = await database;
    final List<Map<String, Object?>> queryResult =
    await databaseClient!.query('withdrawalHistory');

    return queryResult.map((e) => WithdrawHistoryModel.fromMap(e)).toList();
  }
}
