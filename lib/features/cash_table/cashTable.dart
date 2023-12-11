import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/cash_model.dart';
import 'bloc/cash_table_cubit.dart';
import 'bloc/cash_table_state.dart';

class CashTable extends StatefulWidget {
  static const String routeName = "/Cash-Table";
  final double scrSize;

  const CashTable({super.key, required this.scrSize});

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
    cashTableCubit.fetchDenominationCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CashTableCubit, CashTableState>(
        builder: (context, state) {
      final CashTableCubit cashTableCubit =
          BlocProvider.of<CashTableCubit>(context);
      final cashList = cashTableCubit.cashList;

      final denominationCountList = cashTableCubit.denominationCountList;
      return SizedBox(
        height: widget.scrSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Stocks of each denominations:',
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
                  ],
                  rows: denominationCountList.map((denominationCount) {
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
            SizedBox(
              height: widget.scrSize - MediaQuery.of(context).size.height / 5,
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
