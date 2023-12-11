import 'package:flutter/material.dart';
import '../cash_insertion/cash_insertion_screen.dart';
import '../cash_withdraw/cash_withdraw_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = "/Dashboard_Screen";
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cash Add-WithDrawer',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CashInsertionScreen.routeName);
                },
                child: const Text('Insert Cash')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CashWithdrawScreen.routeName);
                },
                child: const Text('Withdraw Cash')),
          ],
        ),
      ),
    );
  }
}
