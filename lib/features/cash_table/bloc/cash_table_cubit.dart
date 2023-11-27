import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/db/database_helper.dart';
import '../../../data/models/cash_model.dart';
import 'cash_table_state.dart';

class CashTableCubit extends Cubit<CashTableState>{
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  CashTableCubit():super(CashTableInitialState());

 List<CashModel> cashList = [];

  Future<void> fetchData() async {
    try {
      cashList = await _databaseHelper.getCashList();
      print(cashList);
      emit(DataFetchedSuccessState());
    } catch (error) {
      print('Error fetching data: $error');
      emit(DataFetchedErrorState());
    }
  }
}
