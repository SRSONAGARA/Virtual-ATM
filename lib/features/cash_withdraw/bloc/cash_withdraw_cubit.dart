import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/db/database_helper.dart';
import '../../../data/models/cash_model.dart';

class CashWithdrawCubit extends Cubit<CashWithdrawState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  CashWithdrawCubit() : super(CashWithdrawInitialState());

  Future<Map<int, int>> performWithdrawal(
      int enteredAmount, List<int> noteCountList) async {
    final denominations = [2000, 1000, 500, 200, 100];

    print('1');
    Map<int, int> result = {};
    int remainingAmount = enteredAmount;

    for (int i = 0; i < denominations.length; i++) {
      int denomination = denominations[i];
      int notesAvailable = noteCountList[i];

      while (remainingAmount >= denomination && notesAvailable > 0) {
        result[denomination] = (result[denomination] ?? 0) + 1;
        notesAvailable--;
        remainingAmount -= denomination;
      }
      noteCountList[i] = notesAvailable;
      print('2');
    }
    if (remainingAmount > 0) {
      print('3');
      emit(CashWithdrawErrorState());
      return {0: 0};
    }
    if (result.isNotEmpty) {
      Map<int, int> negativeResult =
          result.map((key, value) => MapEntry(key, -value));

      await databaseHelper.updateDatabase(result);
      final cashModel = CashModel(
        hundredRupeeNoteCount:
            negativeResult.containsKey(100) ? negativeResult[100] ?? 0 : 0,
        twoHundredRupeeNoteCount:
            negativeResult.containsKey(200) ? negativeResult[200] ?? 0 : 0,
        fiveHundredRupeeNoteCount:
            negativeResult.containsKey(500) ? negativeResult[500] ?? 0 : 0,
        thousandRupeeNoteCount:
            negativeResult.containsKey(1000) ? negativeResult[1000] ?? 0 : 0,
        twoThousandRupeeNoteCount:
            negativeResult.containsKey(2000) ? negativeResult[2000] ?? 0 : 0,
        dateTime: DateTime.now(),
      );

      await databaseHelper.insert(cashModel);
      emit(CashWithdrawSuccessState());
    }

    print('result: ${result}');
    return result;
  }
}
