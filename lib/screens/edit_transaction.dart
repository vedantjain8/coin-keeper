import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTransaction extends StatefulWidget {
  final void Function() refreshData;
  final int id;
  const EditTransaction(
      {super.key, required this.id, required this.refreshData});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  // variable
  late int transactionId;
  List<Map<String, dynamic>> _transactionItem = [];
  bool _isLoading = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _loadJournal() async {
    final data = await SQLHelper.getItems(
        switchArg: "filterById", wallet: "transactions", idclm: transactionId);

    setState(() {
      _transactionItem = data;
      _isLoading = false;
      _oldTransactionAmount = _transactionItem[0]['amount'];
      _amountController = _transactionItem[0]['amount'];
      _titleController = _transactionItem[0]['title'];
      _descriptionController = _transactionItem[0]['description'];
      _walletController = _transactionItem[0]['wallet'];
      _categoryController = _transactionItem[0]['category'];
      _typeController = _transactionItem[0]['type'];
    });
  }

  String _titleController = "";
  String _descriptionController = "";
  double _amountController = 0.0;
  String _walletController = "";
  String _categoryController = "";
  String _typeController = "";
  double _oldTransactionAmount = 0.0;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // submit sql insert query
      await _updateItem();

      widget.refreshData();

      // close the screen
      Navigator.of(context).pop();

      // Clear form fields
      _formKey.currentState!.reset();
    }
  }

  Future<void> _updateItem() async {
    try {
      await SQLHelper.updateItem(
          transactionId,
          _titleController,
          _descriptionController,
          _amountController,
          // (_typeController.toString().toLowerCase() == "income")
          //     ? int.parse('+$_amountController')
          //     : int.parse('-$_amountController'),
          _walletController,
          _typeController,
          _categoryController,
          _oldTransactionAmount);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _deleteFormItem() async {
    try {
      await SQLHelper.deleteItem(
          transactionId, _amountController, _walletController);
      widget.refreshData();

      // close the screen
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    transactionId = widget.id;
    super.initState();
    _loadJournal();
  }

  @override
  void dispose() async {
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submitForm(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
      appBar: AppBar(
        title: Text("Edit Transaction ID: $transactionId"),
        actions: [
          Stack(
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
                              child: Text("This action can't be undone!")),
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
          ),
        ],
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      Text(_transactionItem.toString()),
                      TextFormField(
                        initialValue: _transactionItem[0]['title'],
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
                        initialValue: _transactionItem[0]['description'],
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
                        initialValue: _transactionItem[0]['amount'].toString(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }

                          if (_typeController.toString().toLowerCase() ==
                              "income") {
                            if (double.tryParse('+$value') == null) {
                              return "Please enter a valid positive amount";
                            }
                          }

                          if (_typeController.toString().toLowerCase() ==
                              "expense") {
                            if (double.tryParse(value) == null && double.tryParse(value)! < 0) {
                              return "Please enter a valid expense amount";
                            }
                          }

                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _amountController = double.parse(value);
                          });
                        },
                        keyboardType: const TextInputType.numberWithOptions(
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
                        initialValue: _transactionItem[0]['wallet'],
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
                        initialValue: _transactionItem[0]['category'],
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
