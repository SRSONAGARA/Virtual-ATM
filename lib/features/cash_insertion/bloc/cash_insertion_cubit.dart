import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/db/database_helper.dart';
import '../../../data/models/cash_model.dart';

class CashInsertionCubit extends Cubit<CashInsertionState>{
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  CashInsertionCubit():super(CashInsertionInitialState());

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

    try {
      var data = await _databaseHelper.insert(cashModel);
      print(data);
      print('Data added');
      hundredController.clear();
      twoHundredController.clear();
      fiveHundredController.clear();
      thousandController.clear();
      twoThousandController.clear();
      emit(DataInsertionSuccessState());

    } catch (error) {
      emit(DataInsertionErrorState());
    }
  }

  int _getValue(TextEditingController controller) {
    return int.tryParse(controller.text) ?? 0;
  }
}