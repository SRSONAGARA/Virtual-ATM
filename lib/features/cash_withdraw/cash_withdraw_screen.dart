import 'package:flutter/material.dart';

import '../cash_table/cashTable.dart';
class CashWithdrawScreen extends StatefulWidget {
  static const String routeName = "/Cash-Withdraw-Screen";
  const CashWithdrawScreen({super.key});

  @override
  State<CashWithdrawScreen> createState() => _CashWithdrawScreenState();
}

class _CashWithdrawScreenState extends State<CashWithdrawScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Withdraw Money',
            // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Enter the Amount you wish to withdraw.',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: '₹ ',
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(3)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                hintText: 'Enter value',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('Withdraw'))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              const Text('Recent Transaction',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey)),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        title: const Text('₹ 100'),
                        subtitle: Text(DateTime.now().toString()),
                      ),
                    );
                  },
                ),
              ),
              const Divider(),
              const Text(
                'Total Available Stocks:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              const Expanded(flex:4,child: CashTable()),
            ],
          ),
        ),
      ),
    );
  }
}
