import 'package:cash_withdrawer/data/db/database_helper.dart';
import 'package:cash_withdrawer/features/cash_table/bloc/cash_table_state.dart';
import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_cubit.dart';
import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/models/cash_model.dart';
import '../../data/models/denomination_count_model.dart';
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
  List<int> noteCountList = [];
  DatabaseHelper? databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    CashTableCubit cashTableCubit = BlocProvider.of<CashTableCubit>(context);
    cashTableCubit.fetchData();
    cashTableCubit.fetchDenominationCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashTableCubit, CashTableState>(
        builder: (context, state) {
      final CashWithdrawCubit cashWithdrawCubit =
          BlocProvider.of<CashWithdrawCubit>(context);
      final CashTableCubit cashTableCubit =
          BlocProvider.of<CashTableCubit>(context);
      final cashList = cashTableCubit.cashList;
      final denominationCountList = cashTableCubit.denominationCountList;
      print('denominationCountList:$denominationCountList');

      noteCountList = denominationCountList.expand<int>((denominationCount) {
        return [
          denominationCount.twoThousandRupeeTotalNoteCount ?? 0,
          denominationCount.thousandRupeeTotalNoteCount ?? 0,
          denominationCount.fiveHundredRupeeTotalNoteCount ?? 0,
          denominationCount.twoHundredRupeeTotalNoteCount ?? 0,
          denominationCount.hundredRupeeTotalNoteCount ?? 0,
        ];
      }).toList();

      print('noteCountList: $noteCountList');
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

      totalValue = availableBalance(cashList);
      return BlocConsumer<CashWithdrawCubit, CashWithdrawState>(
          builder: (context, state) {
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
                                      await cashWithdrawCubit.performWithdrawal(
                                          enteredAmount, noteCountList);
                                    } else {
                                      showAlertDialog('Success',
                                          'Amount should be a multiple of 100');
                                    }
                                  } else {
                                    showAlertDialog(
                                        'Error', 'Insufficient balance');
                                  }
                                } else {
                                  showAlertDialog(
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
                    flex: 7,
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
                    flex: 6,
                    child: SingleChildScrollView(
                      child: FittedBox(
                        child: Card(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('₹100')),
                              DataColumn(label: Text('₹200')),
                              DataColumn(label: Text('₹500')),
                              DataColumn(label: Text('₹1000')),
                              DataColumn(label: Text('₹2000')),
                            ],
                            rows:
                                denominationCountList.map((denominationCount) {
                              return DataRow(cells: [
                                DataCell(Text(
                                  '${denominationCount.hundredRupeeTotalNoteCount}',
                                )),
                                DataCell(Text(
                                  '${denominationCount.twoHundredRupeeTotalNoteCount}',
                                )),
                                DataCell(Text(
                                  '${denominationCount.fiveHundredRupeeTotalNoteCount}',
                                )),
                                DataCell(Text(
                                  '${denominationCount.thousandRupeeTotalNoteCount}',
                                )),
                                DataCell(Text(
                                  '${denominationCount.twoThousandRupeeTotalNoteCount}',
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }, listener: (context, state) {
        if (state is CashWithdrawSuccessState) {
          showAlertDialog('Success', 'Amount successfully Withdrawn!');
        } else if (state is CashWithdrawErrorState) {
          showAlertDialog('Error',
              'Unable to dispense requested amount with available notes');
        }
      });
    });
  }

  void showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
