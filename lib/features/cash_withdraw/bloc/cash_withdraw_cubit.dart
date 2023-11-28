import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CashWithdrawCubit extends Cubit<CashWithdrawState>{
  CashWithdrawCubit():super(CashWithdrawInitialState());

  Future<void> withdrawCash()async{

  }
}