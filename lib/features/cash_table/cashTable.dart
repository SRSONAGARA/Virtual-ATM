import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/cash_model.dart';
import 'bloc/cash_table_cubit.dart';
import 'bloc/cash_table_state.dart';

class CashTable extends StatefulWidget {
  static const String routeName = "/Cash-Table";

  const CashTable({super.key});

  @override
  State<CashTable> createState() => _CashTableState();
}

class _CashTableState extends State<CashTable> {
  int totalValue = 0;

  @override
  void initState() {
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
      final totalNoteCounts = calculateTotalNoteCount(cashList);
      final totalNoteCountsRows = buildTotalNoteCountsRows(totalNoteCounts);
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total Available Stocks:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: DataTable(columns: const [
                DataColumn(label: Text('Denomination')),
                DataColumn(label: Text('Count')),
              ], rows: totalNoteCountsRows),
            ),
            const SizedBox(height: 10),
            const Text(
              'Insertion History:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),
            FittedBox(
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
                  rows: cashList.map((cash) {
                    final formattedTime =
                        DateFormat('HH:mm:ss').format(cash.dateTime!);
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
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }
}
