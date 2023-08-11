import 'package:coinkeeper/theme/color.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionForm extends StatefulWidget {
  // final void Function() refreshData;
  final int? id;
  const TransactionForm({
    super.key,
    // required this.refreshData,
    this.id,
  });

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  // variables
  bool _isLoading = true;
  bool _isEditable = false;
  late int? transactionId;
  Map<String, dynamic> _transactionItem = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // controllers
  String _titleController = "";
  String _descriptionController = "";
  double _amountController = 0.0;
  String _walletController = "";
  String _categoryController = "";
  String _typeController = "income";
  double _oldTransactionAmount = 0.0;
  DateTime _datetime = DateTime.now();

  void _loadJournal() async {
    final data = await SQLHelper.getItems(
        switchArg: "filterById",
        tableName: "transactions",
        idclm: transactionId);

    setState(() {
      _transactionItem = data.first;
      _isLoading = false;
      _oldTransactionAmount = _transactionItem['amount'];
      _amountController = _transactionItem['amount'];
      _titleController = _transactionItem['title'];
      _descriptionController = _transactionItem['description'];
      _walletController = _transactionItem['wallet'];
      _categoryController = _transactionItem['category'];
      _typeController = _transactionItem['type'];
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // submit sql insert query
      (_isEditable) ? await _updateItem() : await _addItem();

      // widget.refreshData();

      // close the screen
      Navigator.of(context).pop();

      // Clear form fields
      _formKey.currentState!.reset();
    }
  }

  // Insert a new journal to the database
  Future<void> _addItem() async {
    try {
      await SQLHelper.createItem(
        (_titleController.isEmpty) ? "Adjusted Balance" : _titleController,
        _descriptionController,
        // (_typeController.toString().toLowerCase() == "income")
        //     ? double.parse('+$_amountController')
        //     : double.parse('-$_amountController'),
        _amountController,
        (_walletController.isEmpty) ? "cash" : _walletController,
        _typeController.toLowerCase(),
        _categoryController,
      );
    } catch (e) {
      print(e);
    }
  }

  // Update the db record
  Future<void> _updateItem() async {
    try {
      await SQLHelper.updateItem(
          transactionId!,
          _titleController,
          _descriptionController,
          _amountController,
          _walletController,
          _typeController,
          _categoryController,
          _oldTransactionAmount);
    } catch (e) {
      print(e);
    }
  }

  // delete the db record
  Future<void> _deleteFormItem() async {
    try {
      await SQLHelper.deleteItem(
          transactionId!, _amountController, _walletController);
      // widget.refreshData();

      // close the screen
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // date time widget
  Future<void> chooseDate(BuildContext context) async {
    DateTime initialDate = _datetime;
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (picked != null && initialDate != picked) {
      setState(() {
        _datetime = DateTime(picked.year, picked.month, picked.day,
            initialDate.hour, initialDate.minute);
      });
    }
  }

  Future<void> chooseTime(BuildContext context) async {
    DateTime initialDate = _datetime;
    TimeOfDay initialTime =
        TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: initialTime,
        initialEntryMode: TimePickerEntryMode.input);
    if (time != null && initialTime != time) {
      setState(() {
        _datetime = DateTime(initialDate.year, initialDate.month,
            initialDate.day, time.hour, time.minute);
      });
    }
  }

  @override
  void initState() {
    transactionId = widget.id;
    (transactionId != null) ? _isEditable = true : _isEditable = false;
    (_isEditable) ? _loadJournal() : _isLoading = false;
    super.initState();
  }

  @override
  void dispose() async {
    // TODO add disposes
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submitForm(),
        foregroundColor: fabForegroundColor,
        backgroundColor: fabBackgroundColor,
        child: (_isEditable) ? const Icon(Icons.check) : const Icon(Icons.save),
      ),
      appBar: AppBar(
        title: (_isEditable)
            ? Text("Edit Transaction ID: $transactionId")
            : const Text("Add new Transaction"),
        actions: [
          (_isEditable)
              ? Stack(
                  children: [
                    IconButton(
                        color: Colors.red,
                        onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                icon: const Icon(Icons.warning),
                                iconColor: Colors.red,
                                title: const Text("Are you sure?"),
                                content: const SingleChildScrollView(
                                    child:
                                        Text("This action can't be undone!")),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Decline",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteFormItem();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        icon: const Icon(Icons.delete_forever)),
                  ],
                )
              : const SizedBox.shrink()
          // add anything for top right corner widget in the add transaction layout
        ],
      ),
      body: SingleChildScrollView(
          child:
              // (_isEditable)
              //     ?
              (_isLoading)
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: _transactionItem['title'],
                              onChanged: (value) {
                                setState(() {
                                  _titleController = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Title',
                              ),
                            ),
                            TextFormField(
                              initialValue: _transactionItem['description'],
                              onChanged: (value) {
                                setState(() {
                                  _descriptionController = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            ListTile(
                              title: const Text('Income'),
                              leading: Radio(
                                value: 'income',
                                groupValue: _typeController,
                                onChanged: (value) {
                                  setState(() {
                                    _typeController = value.toString();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            ListTile(
                              title: const Text('Expense'),
                              leading: Radio(
                                value: 'expense',
                                groupValue: _typeController,
                                onChanged: (value) {
                                  setState(() {
                                    _typeController = value.toString();
                                  });
                                },
                              ),
                            ),
                            TextFormField(
                              initialValue:
                                  (_isEditable) ? _transactionItem['amount'].toString() : "",
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    double.tryParse(value) == 0.0) {
                                  return 'Please enter amount';
                                }

                                double parsedAmount =
                                    double.tryParse(value) ?? 0.0;

                                if (_typeController.toString().toLowerCase() ==
                                    "income") {
                                  if (parsedAmount < 0) {
                                    return "Please enter a valid positive amount";
                                  }
                                } else if (_typeController
                                        .toString()
                                        .toLowerCase() ==
                                    "expense") {
                                  if (parsedAmount >= 0) {
                                    return "Please enter a valid negative amount";
                                  }
                                }

                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _amountController = double.parse(value);
                                });
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\-?\d{0,10}\.?\d{0,2}'))
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                              ),
                            ),
                            TextFormField(
                              initialValue: _transactionItem['wallet'],
                              onChanged: (value) {
                                setState(() {
                                  _walletController = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Wallet',
                              ),
                            ),
                            TextFormField(
                              initialValue: _transactionItem['category'],
                              onChanged: (value) {
                                setState(() {
                                  _categoryController = value.trim();
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Category',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
          // : // new entry from below
          // Container(
          //     padding: const EdgeInsets.only(
          //       top: 15,
          //       left: 15,
          //       right: 15,
          //     ),
          //     child: Form(
          //       key: _formKey,
          //       child: Column(
          //         children: [
          //           TextFormField(
          //             onChanged: (value) {
          //               setState(() {
          //                 _titleController = value.trim();
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               labelText: 'Title',
          //             ),
          //           ),
          //           TextFormField(
          //             onChanged: (value) {
          //               setState(() {
          //                 _descriptionController = value.trim();
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               labelText: 'Description',
          //             ),
          //           ),
          //           Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceAround,
          //             children: [
          //               Row(
          //                 children: [
          //                   Radio(
          //                     value: 'income',
          //                     groupValue: _typeController,
          //                     onChanged: (value) {
          //                       setState(() {
          //                         _typeController = value.toString();
          //                       });
          //                     },
          //                   ),
          //                   const Text('Income'),
          //                 ],
          //               ),
          //               Row(
          //                 children: [
          //                   Radio(
          //                     value: 'expense',
          //                     groupValue: _typeController,
          //                     onChanged: (value) {
          //                       setState(() {
          //                         _typeController = value.toString();
          //                       });
          //                     },
          //                   ),
          //                   const Text('Expense'),
          //                 ],
          //               )
          //             ],
          //           ),
          //           TextFormField(
          //             validator: (value) {
          //               if (value == null ||
          //                   value.isEmpty ||
          //                   double.tryParse(value) == 0.0) {
          //                 return 'Please enter valid amount';
          //               }
          //               return null;
          //             },
          //             onChanged: (value) {
          //               setState(() {
          //                 _amountController = double.tryParse(value) ?? 0.0;
          //               });
          //             },
          //             keyboardType: const TextInputType.numberWithOptions(
          //               decimal: true,
          //             ),
          //             inputFormatters: [
          //               FilteringTextInputFormatter.allow(
          //                   RegExp(r'^\d+\.?\d{0,1}'))
          //             ],
          //             decoration: const InputDecoration(
          //               labelText: 'Amount',
          //             ),
          //           ),
          //           TextFormField(
          //             onChanged: (value) {
          //               setState(() {
          //                 _walletController = value.trim();
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               labelText: 'Wallet',
          //             ),
          //           ),
          //           TextFormField(
          //             onChanged: (value) {
          //               setState(() {
          //                 _categoryController = value.trim();
          //               });
          //             },
          //             decoration: const InputDecoration(
          //               labelText: 'Category',
          //             ),
          //           ),
          //           const SizedBox(
          //             height: 20,
          //           ),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               const Text("Select Date Time: "),
          //               InkWell(
          //                   onTap: () {
          //                     chooseDate(context);
          //                   },
          //                   child: Wrap(
          //                     spacing: 10,
          //                     children: [
          //                       Icon(
          //                         Icons.calendar_today,
          //                         size: 18,
          //                         color:
          //                             Theme.of(context).colorScheme.primary,
          //                       ),
          //                       Text(DateFormat("dd/MM/yyyy")
          //                           .format(_datetime))
          //                     ],
          //                   )),
          //               InkWell(
          //                   onTap: () {
          //                     chooseTime(context);
          //                   },
          //                   child: Wrap(
          //                     spacing: 10,
          //                     children: [
          //                       Icon(
          //                         Icons.watch_later_outlined,
          //                         size: 18,
          //                         color:
          //                             Theme.of(context).colorScheme.primary,
          //                       ),
          //                       Text(DateFormat("hh:mm a").format(_datetime))
          //                     ],
          //                   )),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          ),
    );
  }
}
