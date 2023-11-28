import 'package:cash_withdrawer/data/db/database_helper.dart';
import 'package:cash_withdrawer/features/cash_table/bloc/cash_table_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/cash_model.dart';
import '../cash_table/bloc/cash_table_cubit.dart';

class CashWithdrawScreen extends StatefulWidget {
  static const String routeName = "/Cash-Withdraw-Screen";
  const CashWithdrawScreen({super.key});

  @override
  State<CashWithdrawScreen> createState() => _CashWithdrawScreenState();
}

class _CashWithdrawScreenState extends State<CashWithdrawScreen> {
  int totalValue = 0;
  TextEditingController amountToWithdraw = TextEditingController();
  DatabaseHelper? databaseHelper;
  int availableBalance(List<CashModel> list) {
    for (var cash in list) {
      totalValue += (cash.hundredRupeeNoteCount ?? 0) * 100 +
          (cash.twoHundredRupeeNoteCount ?? 0) * 200 +
          (cash.fiveHundredRupeeNoteCount ?? 0) * 500 +
          (cash.thousandRupeeNoteCount ?? 0) * 1000 +
          (cash.twoThousandRupeeNoteCount ?? 0) * 2000;
    }
    return totalValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CashTableCubit cashTableCubit = BlocProvider.of<CashTableCubit>(context);
    cashTableCubit.fetchData();
  }

  Map<int, int> calculateTotalNoteCount(List<CashModel> cashList) {
    Map<int, int> noteCounts = {
      100: 0,
      200: 0,
      500: 0,
      1000: 0,
      2000: 0,
    };
    for (var cash in cashList) {
      noteCounts[100] =
          (noteCounts[100] ?? 0) + (cash.hundredRupeeNoteCount ?? 0);
      noteCounts[200] =
          (noteCounts[200] ?? 0) + (cash.twoHundredRupeeNoteCount ?? 0);
      noteCounts[500] =
          (noteCounts[500] ?? 0) + (cash.fiveHundredRupeeNoteCount ?? 0);
      noteCounts[1000] =
          (noteCounts[1000] ?? 0) + (cash.thousandRupeeNoteCount ?? 0);
      noteCounts[2000] =
          (noteCounts[2000] ?? 0) + (cash.twoThousandRupeeNoteCount ?? 0);
    }
    print('noteCounts: $noteCounts');
    return noteCounts;
  }

  List<DataRow> buildTotalNoteCountsRows(Map<int, int> totalNoteCounts) {
    List<DataRow> rows = [];
    totalNoteCounts.forEach((denomination, count) {
      rows.add(DataRow(cells: [
        DataCell(Text('₹$denomination')),
        DataCell(Text('$count')),
      ]));
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashTableCubit, CashTableState>(
        builder: (context, state) {
      final CashTableCubit cashTableCubit =
          BlocProvider.of<CashTableCubit>(context);
      final cashList = cashTableCubit.cashList;
      totalValue = availableBalance(cashList);
      final totalNoteCounts = calculateTotalNoteCount(cashList);
      final totalNoteCountsRows = buildTotalNoteCountsRows(totalNoteCounts);

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Withdraw Money',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  'Total available Balance: ₹$totalValue',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountToWithdraw,
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
                            onPressed: () async {
                              final enteredAmountStr = amountToWithdraw.text;
                              final enteredAmount =
                                  int.tryParse(enteredAmountStr) ?? 0;

                              if (enteredAmount != 0) {
                                if (enteredAmount <= totalValue) {
                                  if (enteredAmount % 100 == 0) {
                                    List<CashModel> updatedCashStock =
                                        performWithdrawal(
                                            cashList, enteredAmount);
                                    cashTableCubit.fetchData();

                                    await databaseHelper!.updateCashStock(updatedCashStock);

                                    setState(() {
                                    totalValue -= enteredAmount;
                                    print('totalValue: $totalValue');
                                  });
                                    _showAlertDialog('Success',
                                        'Amount successfully Withdrawn!');
                                  } else {
                                    _showAlertDialog('Success',
                                        'Amount should be a multiple of 100');
                                  }
                                } else {
                                  _showAlertDialog(
                                      'Error', 'Insufficient balance');
                                }
                              } else {
                                _showAlertDialog(
                                    'Error', 'Please enter a valid amount');
                              }
                            },
                            child: const Text('Withdraw'))
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: Text(
                              'You withdraw an amount of ₹ ${amountToWithdraw.text}'),
                          subtitle: Text(
                              '${DateFormat('dd-MM-yyyy').format(DateTime.now())}  ${DateFormat('HH:mm:ss').format(DateTime.now())}'),
                          // subtitle: Text(DateTime.now().toString()),
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
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Card(
                      child: DataTable(columns: const [
                        DataColumn(label: Text('Denomination')),
                        DataColumn(label: Text('Count')),
                      ], rows: totalNoteCountsRows),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<CashModel> performWithdrawal(
      List<CashModel> cashList, int enteredAmount) {
    int remainingAmount = enteredAmount;
    List<CashModel> updatedCashList = List.from(cashList);
    for (var cash in updatedCashList) {
      int hundredValue = (cash.hundredRupeeNoteCount ?? 0) * 100;
      int twoHundredValue = (cash.twoHundredRupeeNoteCount ?? 0) * 200;
      int fiveHundredValue = (cash.fiveHundredRupeeNoteCount ?? 0) * 500;
      int thousandValue = (cash.thousandRupeeNoteCount ?? 0) * 1000;
      int twoThousandValue = (cash.twoThousandRupeeNoteCount ?? 0) * 2000;

      int totalValue = hundredValue +
          twoHundredValue +
          fiveHundredValue +
          thousandValue +
          twoThousandValue;
      if (totalValue >= remainingAmount) {
        int remainingValue = totalValue - remainingAmount;

        cash.hundredRupeeNoteCount = remainingValue ~/ 100;
        remainingValue %= 100;
        cash.twoHundredRupeeNoteCount = remainingValue ~/ 200;
        remainingValue %= 200;
        cash.fiveHundredRupeeNoteCount = remainingValue ~/ 500;
        remainingValue %= 500;
        cash.thousandRupeeNoteCount = remainingValue ~/ 1000;
        remainingValue %= 1000;
        cash.twoThousandRupeeNoteCount = remainingValue ~/ 2000;
        break;
      } else {
        print('else');
        int denominationWithdrawn = totalValue;
        cash.hundredRupeeNoteCount = 0;
        cash.twoHundredRupeeNoteCount = 0;
        cash.fiveHundredRupeeNoteCount = 0;
        cash.thousandRupeeNoteCount = 0;
        cash.twoThousandRupeeNoteCount = 0;

        remainingAmount -= denominationWithdrawn;
      }
    }
    print('success');
    return cashList;
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
