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
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Virtual ATM Machine', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: (){
                        Navigator.pushNamed(context, CashInsertionScreen.routeName);
                      },
                      child: Card(
                        child: Image.asset('assets/insert_cash.png',height: 170),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Insert Cash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: (){
                        Navigator.pushNamed(context, CashWithdrawScreen.routeName);
                      },
                      child: Card(
                        child: Image.asset('assets/withdraw_cash.png',height: 170),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text('Withdraw cash', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
