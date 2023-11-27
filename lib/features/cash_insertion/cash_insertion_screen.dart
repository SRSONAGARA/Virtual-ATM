import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_cubit.dart';
import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cash_table/cashTable.dart';

class CashInsertionScreen extends StatefulWidget {
  static const String routeName = "/Cash-Insert-Screen";

  const CashInsertionScreen({Key? key}) : super(key: key);

  @override
  State<CashInsertionScreen> createState() => _CashInsertionScreenState();
}

class _CashInsertionScreenState extends State<CashInsertionScreen> {
  CashInsertionCubit? cashInsertionCubit;
  @override
  void initState() {
    super.initState();
    cashInsertionCubit = CashInsertionCubit();
  }

  void rebuildCashTablePart() {
    setState(() {
      // Implement any logic needed to update/rebuild part of CashTable
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CashInsertionCubit, CashInsertionState>(
        builder: (context, state) {
      CashInsertionCubit cashInsertionCubit =
          BlocProvider.of<CashInsertionCubit>(context);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Add Money',
            ),
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
                        _buildTextField(
                            '₹100  ', cashInsertionCubit.hundredController),
                        _buildTextField(
                            '₹200  ', cashInsertionCubit.twoHundredController),
                        _buildTextField(
                            '₹500  ', cashInsertionCubit.fiveHundredController),
                        _buildTextField(
                            '₹1000', cashInsertionCubit.thousandController),
                        _buildTextField(
                            '₹2000', cashInsertionCubit.twoThousandController),
                        ElevatedButton(
                          onPressed: () {
                            cashInsertionCubit.addCash();
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CashTable(refreshCallback: rebuildCashTablePart)
              ],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is ControllerValueEmptyState) {
        _showAlertDialog('Empty', 'Please enter values.');
      } else if (state is DataInsertionSuccessState) {
        _showAlertDialog('Successful', 'Data Inserted Successfully!.');
      } else {
        _showAlertDialog('Error', 'Data note inserted.');
      }
    });
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
