import 'package:cash_withdrawer/features/cashTable/cashTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/db/database_helper.dart';
import '../../data/models/cash_model.dart';

class CashInsertionScreen extends StatefulWidget {
  static const String routeName = "/Cash-Insert-Screen";

  const CashInsertionScreen({Key? key}) : super(key: key);

  @override
  State<CashInsertionScreen> createState() => _CashInsertionScreenState();
}

class _CashInsertionScreenState extends State<CashInsertionScreen> {
  final TextEditingController _hundredController = TextEditingController();
  final TextEditingController _twoHundredController = TextEditingController();
  final TextEditingController _fiveHundredController = TextEditingController();
  final TextEditingController _thousandController = TextEditingController();
  final TextEditingController _twoThousandController = TextEditingController();
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Money',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Enter the number of Notes you want to add',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      _buildTextField('₹100  ', _hundredController),
                      _buildTextField('₹200  ', _twoHundredController),
                      _buildTextField('₹500  ', _fiveHundredController),
                      _buildTextField('₹1000', _thousandController),
                      _buildTextField('₹2000', _twoThousandController),
                      ElevatedButton(
                        onPressed: _addCash,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Total Available Stocks:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              const CashTable()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            '$label   *  ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: TextField(
              style: const TextStyle(fontWeight: FontWeight.bold),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
              ],
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter value',
                hintStyle: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addCash() async {
    final controllers = [
      _hundredController,
      _twoHundredController,
      _fiveHundredController,
      _thousandController,
      _twoThousandController,
    ];

    if (controllers.every((controller) => controller.text.isEmpty)) {
      _showAlertDialog('Error', 'Please enter values.');
      return;
    }

    final cashModel = CashModel(
      hundredRupeeNoteCount: _getValue(_hundredController),
      twoHundredRupeeNoteCount: _getValue(_twoHundredController),
      fiveHundredRupeeNoteCount: _getValue(_fiveHundredController),
      thousandRupeeNoteCount: _getValue(_thousandController),
      twoThousandRupeeNoteCount: _getValue(_twoThousandController),
    );

    try {
      await _databaseHelper.insert(cashModel);
      print('Data added');

      final cashList = await _databaseHelper.getCashList();
      if (cashList.isNotEmpty) {
        for (var cash in cashList) {
          print('Inserted data: $cash');
        }
      } else {
        print('No data found');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  int _getValue(TextEditingController controller) {
    return int.tryParse(controller.text) ?? 0;
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
      ),
    );
  }
}
