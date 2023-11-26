import 'package:flutter/material.dart';
import '../../data/db/database_helper.dart';
import '../../data/models/cash_model.dart';

class CashTable extends StatefulWidget {
  static const String routeName = "/Cash-Table";
  const CashTable({super.key});

  @override
  State<CashTable> createState() => _CashTableState();
}

class _CashTableState extends State<CashTable> {
  late List<CashModel> _cashList = [];
  late DatabaseHelper _databaseHelper;
  late int _totalValue = 0;
  late Map<int, int> _totalNoteCount = {};

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final cashList = await _databaseHelper.getCashList();
      setState(() {
        _cashList = cashList;
      });
      _totalValue = _calculateTotalValue(cashList);
      _totalNoteCount = _calculateTotalNoteCount(cashList);
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  int _calculateTotalValue(List<CashModel> list) {
    for (var cash in list) {
      _totalValue += (cash.hundredRupeeNoteCount ?? 0) * 100 +
          (cash.twoHundredRupeeNoteCount ?? 0) * 200 +
          (cash.fiveHundredRupeeNoteCount ?? 0) * 500 +
          (cash.thousandRupeeNoteCount ?? 0) * 1000 +
          (cash.twoThousandRupeeNoteCount ?? 0) * 2000;
    }
    return _totalValue;
  }

  Map<int, int> _calculateTotalNoteCount(List<CashModel> cashList) {
    Map<int, int> noteCounts = {
      100: 0,
      200: 0,
      500: 0,
      1000: 0,
      2000: 0,
    };
    for (var cash in _cashList) {
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

  List<DataRow> _buildTotalNoteCountsRows(Map<int, int> totalNoteCounts) {
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
    final totalNoteCounts = _calculateTotalNoteCount(_cashList);
    final totalNoteCountsRows = _buildTotalNoteCountsRows(totalNoteCounts);

    return SingleChildScrollView(
      child: Card(
        child: Column(
          children: [
            DataTable(columns: [
              DataColumn(label: Text('Denomination')),
              DataColumn(label: Text('Count')),
            ], rows: totalNoteCountsRows),

            /* DataTable(
              columns: const [
                DataColumn(label: Text('₹100')),
                DataColumn(label: Text('₹200')),
                DataColumn(label: Text('₹500')),
                DataColumn(label: Text('₹1000')),
                DataColumn(label: Text('₹2000')),
              ],
              rows: _cashList.map((cash) {
                return DataRow(cells: [
                  DataCell(Text('${cash.hundredRupeeNoteCount}')),
                  DataCell(Text('${cash.twoHundredRupeeNoteCount}')),
                  DataCell(Text('${cash.fiveHundredRupeeNoteCount}')),
                  DataCell(Text('${cash.thousandRupeeNoteCount}')),
                  DataCell(Text('${cash.twoThousandRupeeNoteCount}')),
                ]);
              }).toList(),
            ),*/
            const SizedBox(
              height: 10,
            ),
            Text('Total Value: ₹$_totalValue'),
            Text('Total Value: ₹$_totalValue')
          ],
        ),
      ),
    );
  }
}
