import 'dart:math';
import 'package:cash_withdrawer/data/db/database_helper.dart';
import 'package:cash_withdrawer/features/cash_table/bloc/cash_table_state.dart';
import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_cubit.dart';
import 'package:cash_withdrawer/features/cash_withdraw/bloc/cash_withdraw_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cash_table/bloc/cash_table_cubit.dart';

class CashWithdrawScreen extends StatefulWidget {
  static const String routeName = "/Cash-Withdraw-Screen";
  const CashWithdrawScreen({super.key});

  @override
  State<CashWithdrawScreen> createState() => _CashWithdrawScreenState();
}

class _CashWithdrawScreenState extends State<CashWithdrawScreen> {
  TextEditingController amountToWithdraw = TextEditingController();
  List<int> noteCountList = [];
  int totalValue = 0;
  DatabaseHelper? databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    CashTableCubit cashTableCubit = BlocProvider.of<CashTableCubit>(context);
    CashWithdrawCubit cashWithdrawCubit =
        BlocProvider.of<CashWithdrawCubit>(context);
    cashTableCubit.fetchData();
    cashTableCubit.fetchDenominationCount();

    cashWithdrawCubit.fetchWithdrawTransaction();
    cashWithdrawCubit.fetchWithdrawDenominationCountHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashTableCubit, CashTableState>(
        builder: (context, state) {
      final CashTableCubit cashTableCubit =
          BlocProvider.of<CashTableCubit>(context);
      final denominationCountList = cashTableCubit.denominationCountList;

      noteCountList = denominationCountList.expand<int>((denominationCount) {
        return [
          denominationCount.twoThousandRupeeTotalNoteCount ?? 0,
          denominationCount.thousandRupeeTotalNoteCount ?? 0,
          denominationCount.fiveHundredRupeeTotalNoteCount ?? 0,
          denominationCount.twoHundredRupeeTotalNoteCount ?? 0,
          denominationCount.hundredRupeeTotalNoteCount ?? 0,
        ];
      }).toList();

      for (var denominationCount in denominationCountList) {
        totalValue = (denominationCount.hundredRupeeTotalNoteCount ?? 0) * 100 +
            (denominationCount.twoHundredRupeeTotalNoteCount ?? 0) * 200 +
            (denominationCount.fiveHundredRupeeTotalNoteCount ?? 0) * 500 +
            (denominationCount.thousandRupeeTotalNoteCount ?? 0) * 1000 +
            (denominationCount.twoThousandRupeeTotalNoteCount ?? 0) * 2000;
      }

      return BlocConsumer<CashWithdrawCubit, CashWithdrawState>(
          builder: (context, state) {
        CashWithdrawCubit cashWithdrawCubit =
            BlocProvider.of<CashWithdrawCubit>(context);
        final withdrawalTransactions = cashWithdrawCubit.withdrawalTransactions;
        final withdrawDenominationCount =
            cashWithdrawCubit.withdrawDenominationCount;
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
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
                                      await cashTableCubit
                                          .fetchDenominationCount();
                                      await cashWithdrawCubit
                                          .fetchWithdrawDenominationCountHistory();
                                      await cashWithdrawCubit
                                          .fetchWithdrawTransaction();
                                      amountToWithdraw.clear();
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
                    child: withdrawalTransactions.isEmpty
                        ? const Text('You have note yet done any withdrawal!')
                        : ListView.builder(
                            itemCount: min(3, withdrawalTransactions.length),
                            itemBuilder: (context, index) {
                              final reversedList =
                                  withdrawalTransactions.reversed.toList();
                              if (index < reversedList.length) {
                                final transaction = reversedList[index];
                                return Card(
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    title: Text(
                                        'You withdraw an amount of ₹ ${transaction.withdrawnAmount}'),
                                    subtitle: Text(
                                        '${DateFormat('dd-MM-yyyy').format(transaction.dateTime ?? DateTime.now())}  ${DateFormat('HH:mm:ss').format(transaction.dateTime ?? DateTime.now())}'),
                                  ),
                                );
                              }
                            },
                          ),
                  ),
                  const Divider(),
                  const Text(
                    'Available Stocks of each denominations:',
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
                  const SizedBox(height: 10),
                  const Divider(),
                  const Text(
                    'Withdraw History:',
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
                      scrollDirection: Axis.vertical,
                      child: FittedBox(
                        child: Card(
                          child: DataTable(
                              columns: const [
                                DataColumn(label: Text('₹100')),
                                DataColumn(label: Text('₹200')),
                                DataColumn(label: Text('₹500')),
                                DataColumn(label: Text('₹1000')),
                                DataColumn(label: Text('₹2000')),
                                DataColumn(label: Text('DateTime')),
                              ],
                              rows: withdrawDenominationCount.map((cash) {
                                final formattedTime = DateFormat('HH:mm:ss')
                                    .format(cash.dateTime!);
                                final formattedDateTime =
                                    '${DateFormat('dd-MM-yyyy').format(cash.dateTime!)} $formattedTime';
                                return DataRow(cells: [
                                  DataCell(Text(
                                    '${cash.hundredRupeeNoteCount}',
                                  )),
                                  DataCell(Text(
                                    '${cash.twoHundredRupeeNoteCount}',
                                  )),
                                  DataCell(Text(
                                    '${cash.fiveHundredRupeeNoteCount}',
                                  )),
                                  DataCell(Text(
                                    '${cash.thousandRupeeNoteCount}',
                                  )),
                                  DataCell(Text(
                                    '${cash.twoThousandRupeeNoteCount}',
                                  )),
                                  DataCell(Text(formattedDateTime)),
                                ]);
                              }).toList()),
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
