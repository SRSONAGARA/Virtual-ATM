import 'package:cash_withdrawer/data/models/denomination_count_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/db/database_helper.dart';
import '../../../data/models/cash_model.dart';
import 'cash_table_state.dart';

class CashTableCubit extends Cubit<CashTableState>{
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  CashTableCubit():super(CashTableInitialState());

 List<CashModel> cashList = [];
 List<DenominationCountModel> denominationCountList = [];

  Future<void> fetchData() async {
    try {
      cashList = await _databaseHelper.getInsertionHistory();
      emit(DataFetchedSuccessState());
    } catch (error) {
      print('Error fetching data: $error');
      emit(DataFetchedErrorState());
    }
  }

  Future<void> fetchDenominationCount() async {
    try {
      denominationCountList = await _databaseHelper.getDenominationCountList();
      emit(DataFetchedSuccessState());
    } catch (error) {
      print('Error fetching data: $error');
      emit(DataFetchedErrorState());
    }
  }
}
