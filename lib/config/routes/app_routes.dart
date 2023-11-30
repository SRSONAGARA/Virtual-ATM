import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_cubit.dart';
import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/cash_insertion/cash_insertion_screen.dart';
import '../../features/cash_table/bloc/cash_table_cubit.dart';
import '../../features/cash_table/cashTable.dart';
import '../../features/cash_withdraw/cash_withdraw_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get getAppRoutes => {
        DashboardScreen.routeName: (_) => const DashboardScreen(),
        CashInsertionScreen.routeName: (_) => MultiBlocProvider(providers: [
              BlocProvider<CashInsertionCubit>(
                  create: (_) => CashInsertionCubit()),
              BlocProvider<CashTableCubit>(
                create: (_) => CashTableCubit(),
              )
            ], child: const CashInsertionScreen()),
        CashWithdrawScreen.routeName: (_) => MultiBlocProvider(providers: [
              BlocProvider(create: (_) => CashTableCubit()),
              BlocProvider(create: (_) => CashWithdrawCubit())
            ], child: const CashWithdrawScreen()),
        CashTable.routeName: (_) => MultiBlocProvider(providers: [
              BlocProvider(create: (_) => CashTableCubit()),
              BlocProvider(create: (_) => CashInsertionCubit())
            ], child: const CashTable())
      };
}
