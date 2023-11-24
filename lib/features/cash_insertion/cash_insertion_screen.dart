import 'package:cash_withdrawer/data/db/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/notes_model.dart';

class CashInsertionScreen extends StatefulWidget {
  static const String routeName = "/Cash-Insert-Screen";

  const CashInsertionScreen({super.key});

  @override
  State<CashInsertionScreen> createState() => _CashInsertionScreenState();
}

class _CashInsertionScreenState extends State<CashInsertionScreen> {
  DatabaseHelper? databaseHelper;
  /* DatabaseHelper databaseHelper = DatabaseHelper();
  List<NotesModel> noteModel =[];*/
  TextEditingController hundredRupeeNoteCountController =
      TextEditingController();
  TextEditingController twoHundredRupeeNoteCountController =
      TextEditingController();
  TextEditingController fiveHundredRupeeNoteCountController =
      TextEditingController();
  TextEditingController thousandRupeeNoteCountController =
      TextEditingController();
  TextEditingController twoThousandRupeeNoteCountController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Money'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Enter the number of Notes you want to add',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 3),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              '₹100   *  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                controller: hundredRupeeNoteCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Enter value',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('₹200   *  ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                controller: twoHundredRupeeNoteCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Enter value',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('₹500   *  ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                controller: fiveHundredRupeeNoteCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Enter value',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('₹1000 *  ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                controller: thousandRupeeNoteCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Enter value',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('₹2000 *  ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5),
                                ],
                                controller: twoThousandRupeeNoteCountController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: 'Enter value',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              databaseHelper!
                                  .insert(CashModel(
                                      hundredRupeeNoteCount: 2,
                                      twoHundredRupeeNoteCount: 0,
                                      fiveHundredRupeeNoteCount: 2,
                                      thousandRupeeNoteCount: 1,
                                      twoThousandRupeeNoteCount: 3))
                                  .then((value) {
                                print('data added');
                              }).onError((error, stackTrace) {
                                print(error.toString());
                              });
                              // _add();
                            },
                            child: const Text('Add'))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Total Available Balance: ₹5000',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  )),
            ],
          ),
        ),
      ),
    );
  }

/*  // Add data to database
  void _add() async {
    int result;
    if (noteModel[0].id != null) {  // Case 1: Update operation
      result = await databaseHelper.updateNote(noteModel[0]);
    } else { // Case 2: Insert Operation
      result = await databaseHelper.insertNote(noteModel[0]);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }*/

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
