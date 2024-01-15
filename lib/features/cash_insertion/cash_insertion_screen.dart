import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_cubit.dart';
import 'package:cash_withdrawer/features/cash_insertion/bloc/cash_insertion_state.dart';
import 'package:cash_withdrawer/features/cash_table/bloc/cash_table_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    CashTableCubit cashTable = BlocProvider.of<CashTableCubit>(context);
    return BlocConsumer<CashInsertionCubit, CashInsertionState>(
        builder: (context, state) {
      CashInsertionCubit cashInsertionCubit =
          BlocProvider.of<CashInsertionCubit>(context);
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Add Money',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
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
                        buildTextField(
                            '₹100  ', cashInsertionCubit.hundredController),
                        buildTextField(
                            '₹200  ', cashInsertionCubit.twoHundredController),
                        buildTextField(
                            '₹500  ', cashInsertionCubit.fiveHundredController),
                        buildTextField(
                            '₹1000', cashInsertionCubit.thousandController),
                        buildTextField(
                            '₹2000', cashInsertionCubit.twoThousandController),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: () async {
                            await cashInsertionCubit.addCash();
                            await cashTable.fetchData();
                            await cashTable.fetchDenominationCount();
                          },
                          child: const Text('Add',style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CashTable(scrSize: MediaQuery.of(context).size.height / 2.2)
              ],
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is ControllerValueEmptyState) {
       showCustomSnackBar('Please enter values.');
      } else if (state is DataInsertionSuccessState) {
        showCustomSnackBar('Data Inserted Successfully!.');
      } else {
        showCustomSnackBar('Data note inserted.');
      }
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
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
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
