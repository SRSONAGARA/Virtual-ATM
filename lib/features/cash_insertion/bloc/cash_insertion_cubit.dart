import 'package:cash_withdrawer/data/models/denomination_count_model.dart';
import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/db/database_helper.dart';
import '../../../data/models/cash_model.dart';

class CashInsertionCubit extends Cubit<CashInsertionState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  CashInsertionCubit() : super(CashInsertionInitialState());

  final hundredController = TextEditingController();
  final twoHundredController = TextEditingController();
  final fiveHundredController = TextEditingController();
  final thousandController = TextEditingController();
  final twoThousandController = TextEditingController();

  Future<void> addCash() async {
    final controllers = [
      hundredController,
      twoHundredController,
      fiveHundredController,
      thousandController,
      twoThousandController,
    ];

    if (controllers.every((controller) => controller.text.isEmpty)) {
      emit(ControllerValueEmptyState());
      return;
    }

    final cashModel = CashModel(
      hundredRupeeNoteCount: _getValue(hundredController),
      twoHundredRupeeNoteCount: _getValue(twoHundredController),
      fiveHundredRupeeNoteCount: _getValue(fiveHundredController),
      thousandRupeeNoteCount: _getValue(thousandController),
      twoThousandRupeeNoteCount: _getValue(twoThousandController),
      dateTime: DateTime.now(),
    );

    Map<int, int> calculateTotalNoteCount(List<CashModel> cashList) {
      Map<int, int> noteCounts = {
        100: 0,
        200: 0,
        500: 0,
        1000: 0,
        2000: 0,
      };
      for (var cash in cashList) {
        noteCounts[100] =
            (noteCounts[100] ?? 0) + (cash.hundredRupeeNoteCount ?? 0);
        noteCounts[200] =
            (noteCounts[200] ?? 0) + (cash.twoHundredRupeeNoteCount ?? 0);
        noteCounts[500] =
            (noteCounts[500] ?? 0) + (cash.fiveHundredRupeeNoteCount ?? 0);
        noteCounts[1000] =
            (noteCounts[1000] ?? 0) + (cash.thousandRupeeNoteCount ?? 0);
        noteCounts[2000] =
            (noteCounts[2000] ?? 0) + (cash.twoThousandRupeeNoteCount ?? 0);
      }
      return noteCounts;
    }

    final cashList = await databaseHelper.getInsertionHistory() +
        await databaseHelper.getWithdrawalHistory();

    final totalNoteCounts = calculateTotalNoteCount(cashList..add(cashModel));

    final denominationCountModel = DenominationCountModel(
      hundredRupeeTotalNoteCount: totalNoteCounts[100],
      twoHundredRupeeTotalNoteCount: totalNoteCounts[200],
      fiveHundredRupeeTotalNoteCount: totalNoteCounts[500],
      thousandRupeeTotalNoteCount: totalNoteCounts[1000],
      twoThousandRupeeTotalNoteCount: totalNoteCounts[2000],
    );

    try {
      await databaseHelper.insert(cashModel);
      hundredController.clear();
      twoHundredController.clear();
      fiveHundredController.clear();
      thousandController.clear();
      twoThousandController.clear();

      await databaseHelper.insertIntoDenominationCount(denominationCountModel);

      emit(DataInsertionSuccessState());
    } catch (error) {
      emit(DataInsertionErrorState());
    }
  }

  int _getValue(TextEditingController controller) {
    return int.tryParse(controller.text) ?? 0;
  }
}
