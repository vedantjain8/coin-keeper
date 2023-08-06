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
            ? double.parse('+$_amountController')
            : double.parse('-$_amountController'),
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
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
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
                  onChanged: (value) {
                    setState(() {
                      _descriptionController = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
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
                      ],
                    ),
                    Row(
                      children: [
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
                    )
                  ],
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == 0.0) {
                      return 'Please enter amount';
                    }
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
                  onChanged: (value) {
                    setState(() {
                      _categoryController = value.trim();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                ),
                const SizedBox(
                  height: 20,
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
    );
  }
}
