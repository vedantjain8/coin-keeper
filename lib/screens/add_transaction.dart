import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddTransaction extends StatefulWidget {
  final void Function() refreshData;
  const AddTransaction({super.key, required this.refreshData});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // submit sql insert query
      await _addItem();
      
      widget.refreshData();

      // close the screen
      Navigator.of(context).pop();

      // Clear form fields
      _formKey.currentState!.reset();
    }
  }

  @override
  void dispose() async {
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  String _titleController = "";
  String _descriptionController = "";
  String _amountController = "";
  String _walletController = "";
  String _categoryController = "";
  String _typeController = 'income';

  // Insert a new journal to the database
  Future<void> _addItem() async {
    try {
      await SQLHelper.createItem(
        (_titleController.isEmpty) ? "Adjusted Balance" : _titleController,
        _descriptionController,
        (_typeController.toString().toLowerCase() == "income")
            ? int.parse('+$_amountController')
            : int.parse('-$_amountController'),
        (_walletController.isEmpty) ? "cash" : _walletController,
        _typeController.toLowerCase(),
        _categoryController,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Transaction"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // bottom: MediaQuery.of(context).viewInsets.bottom + 45,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your name';
                  //   }
                  //   return null;
                  // },
                  onChanged: (value) {
                    setState(() {
                      _titleController = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   // Add more email validation logic if needed
                  //   return null;
                  // },
                  onChanged: (value) {
                    setState(() {
                      _descriptionController = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'income',
                      groupValue: _typeController,
                      onChanged: (value) {
                        setState(() {
                          _typeController = value.toString();
                        });
                      },
                    ),
                    const Text('Income'),
                    const SizedBox(width: 20),
                    Radio(
                      value: 'expense',
                      groupValue: _typeController,
                      onChanged: (value) {
                        setState(() {
                          _typeController = value.toString();
                        });
                      },
                    ),
                    const Text('Expense'),
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    // Add more password validation logic if needed
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _amountController = value;
                    });
                  },
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter amount';
                  //   }
                  //   // Add more password validation logic if needed
                  //   return null;
                  // },
                  onChanged: (value) {
                    setState(() {
                      _walletController = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Wallet',
                  ),
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your password';
                  //   }
                  //   // Add more password validation logic if needed
                  //   return null;
                  // },
                  onChanged: (value) {
                    setState(() {
                      _categoryController = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     TextField(
      //       controller: _titleController,
      //       decoration: const InputDecoration(hintText: "Title"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     TextField(
      //       controller: _descriptionController,
      //       decoration: const InputDecoration(hintText: "description"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     Row(
      //       children: [
      //         Radio(
      //           value: 'income',
      //           groupValue: _typeController,
      //           onChanged: (value) {
      //             setState(() {
      //               _typeController = value.toString();
      //             });
      //           },
      //         ),
      //         const Text('Income'),
      //         const SizedBox(width: 10),
      //         Radio(
      //           value: 'expense',
      //           groupValue: _typeController,
      //           onChanged: (value) {
      //             setState(() {
      //               _typeController = value.toString();
      //             });
      //           },
      //         ),
      //         const Text('Expense'),
      //       ],
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     TextField(
      //       controller: _amountController,
      //       keyboardType: const TextInputType.numberWithOptions(
      //         decimal: true,
      //       ),
      //       inputFormatters: [
      //         FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
      //       ],
      //       decoration: const InputDecoration(hintText: "amount"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     TextField(
      //       controller: _walletController,
      //       decoration: const InputDecoration(hintText: "wallet"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     TextField(
      //       controller: _categoryController,
      //       decoration: const InputDecoration(hintText: "category"),
      //     ),
      //     const SizedBox(
      //       height: 10,
      //     ),
      //     ElevatedButton(
      //       onPressed: () async {
      //         // submit sql insert query
      //         await _addItem();

      //         _titleController.text = '';
      //         _descriptionController.text = '';
      //         _amountController.text = '';
      //         _walletController.text = '';
      //         _categoryController.text = '';

      //         widget.refreshData();

      //         // close the screen
      //         Navigator.of(context).pop();
      //       },
      //       child: const Text("Submit"),
      //     ),
      //   ],
      // ),
    );
  }
}
