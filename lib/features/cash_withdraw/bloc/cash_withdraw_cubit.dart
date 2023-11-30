import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/db/database_helper.dart';

class CashWithdrawCubit extends Cubit<CashWithdrawState>{
  final DatabaseHelper databaseHelper = DatabaseHelper();
  CashWithdrawCubit():super(CashWithdrawInitialState());

  Future<Map<int, int>> performWithdrawal(int enteredAmount, List<int> noteCountList) async{
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
      await databaseHelper!.updateDatabase(result);
      emit(CashWithdrawSuccessState());
    }

    print('result: $result');
    return result;
  }
}