import 'package:cash_withdrawer/features/cashTable/cashTable.dart';
import 'package:flutter/cupertino.dart';
import '../../features/cash_insertion/cash_insertion_screen.dart';
import '../../features/cash_withdraw/cash_withdraw_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get getAppRoutes => {
    DashboardScreen.routeName: (_)=> const DashboardScreen(),
    CashInsertionScreen.routeName: (_)=> const CashInsertionScreen(),
    CashWithdrawScreen.routeName: (_)=> const CashWithdrawScreen(),
    CashTable.routeName: (_)=> const CashTable(),
  };
}
