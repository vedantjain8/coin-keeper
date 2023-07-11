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
    final data = await SQLHelper.getItemsFromID(transactionId);

    setState(() {
      _transactionItem = data;
      _isLoading = false;
    });
  }

     String _titleController = "";
     String _descriptionController = "";
     String _amountController = "";
     String _walletController = "";
     String _categoryController = "";
     String _typeController = "";


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

  // TODO add update code here
  Future<void> _addItem() async {
    try {
      await SQLHelper.createItem(
        (_titleController.isEmpty) ? "Adjusted Balance" : _titleController,
        _descriptionController,
        (_typeController.toString().toLowerCase() == "income")
            ? int.parse('+$_amountController')
            : int.parse('-$_amountController'),
        (_walletController.isEmpty) ? "cash" : _walletController,
        _typeController,
        _categoryController,
      );
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
      appBar: AppBar(
        title: Text("Edit Transaction ID: $transactionId"),
      ),
      body: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(_transactionItem.toString()),
                SingleChildScrollView(
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
                            initialValue: _transactionItem[0]['amount'].toString(),
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
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,1}'))
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
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// class EditTransaction extends StatefulWidget {
//   final void Function() refreshData;
//   final int id;

//   const EditTransaction({Key? key, required this.id, required this.refreshData})
//       : super(key: key);

//   @override
//   State<EditTransaction> createState() => _EditTransactionState();
// }

// class _EditTransactionState extends State<EditTransaction> {
//   late int transactionId;
//   List<Map<String, dynamic>> _selectedItemFromID = [];

//   String _titleController = "";
//   String _descriptionController = "";
//   String _amountController = "";
//   String _walletController = "";
//   String _categoryController = "";
//   String _typeController = 'income';

//   @override
//   void initState() {
//     super.initState();
//     transactionId = widget.id;
//     _loadData();
//   }

//   @override
//   void dispose() async {
//     // ignore: avoid_print
//     print('Dispose used for edit_transaction');
//     super.dispose();
//   }

//   void _loadData() async {
//     _selectedItemFromID = await SQLHelper.getItems();
//     // replace [0] with first where like todo template main .dart file _showform 
//     String _titleController = _selectedItemFromID[0]['title'];
//     String _descriptionController = _selectedItemFromID[0]['description'];
//     String _amountController = _selectedItemFromID[0]['amount'];
//     String _walletController = _selectedItemFromID[0]['wallet'];
//     String _typeController = _selectedItemFromID[0]['type'];
//     String _categoryController = _selectedItemFromID[0]['category'];
//   }

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       // submit sql insert query
//       await _addItem();

//       widget.refreshData();

//       // close the screen
//       Navigator.of(context).pop();

//       // Clear form fields
//       _formKey.currentState!.reset();
//     }
//   }

//   // Update a new journal to the database
//   Future<void> _addItem() async {
//   // TODO add update function here
//     try {
//       await SQLHelper.createItem(
//         (_titleController.isEmpty) ? "Adjusted Balance" : _titleController,
//         _descriptionController,
//         (_typeController.toString().toLowerCase() == "income")
//             ? int.parse('+$_amountController')
//             : int.parse('-$_amountController'),
//         (_walletController.isEmpty) ? "cash" : _walletController,
//         _typeController,
//         _categoryController,
//       );
//     } catch (e) {
//       print(e);
//     }
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Transaction ID: $transactionId'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.only(
//             top: 15,
//             left: 15,
//             right: 15,
//             // bottom: MediaQuery.of(context).viewInsets.bottom + 45,
//           ),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   // validator: (value) {
//                   //   if (value == null || value.isEmpty) {
//                   //     return 'Please enter your name';
//                   //   }
//                   //   return null;
//                   // },
//                   onChanged: (value) {
//                     setState(() {
//                       _titleController = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                   ),
//                 ),
//                 TextFormField(
//                   // validator: (value) {
//                   //   if (value == null || value.isEmpty) {
//                   //     return 'Please enter your email';
//                   //   }
//                   //   // Add more email validation logic if needed
//                   //   return null;
//                   // },
//                   onChanged: (value) {
//                     setState(() {
//                       _descriptionController = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                   ),
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Radio(
//                       value: 'income',
//                       groupValue: _typeController,
//                       onChanged: (value) {
//                         setState(() {
//                           _typeController = value.toString();
//                         });
//                       },
//                     ),
//                     const Text('Income'),
//                     const SizedBox(width: 20),
//                     Radio(
//                       value: 'expense',
//                       groupValue: _typeController,
//                       onChanged: (value) {
//                         setState(() {
//                           _typeController = value.toString();
//                         });
//                       },
//                     ),
//                     const Text('Expense'),
//                   ],
//                 ),
//                 TextFormField(
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter amount';
//                     }
//                     // Add more password validation logic if needed
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       _amountController = value;
//                     });
//                   },
//                   keyboardType: const TextInputType.numberWithOptions(
//                     decimal: true,
//                   ),
//                   inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
//                   ],
//                   decoration: const InputDecoration(
//                     labelText: 'Amount',
//                   ),
//                 ),
//                 TextFormField(
//                   // validator: (value) {
//                   //   if (value == null || value.isEmpty) {
//                   //     return 'Please enter amount';
//                   //   }
//                   //   // Add more password validation logic if needed
//                   //   return null;
//                   // },
//                   onChanged: (value) {
//                     setState(() {
//                       _walletController = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Wallet',
//                   ),
//                 ),
//                 TextFormField(
//                   // validator: (value) {
//                   //   if (value == null || value.isEmpty) {
//                   //     return 'Please enter your password';
//                   //   }
//                   //   // Add more password validation logic if needed
//                   //   return null;
//                   // },
//                   onChanged: (value) {
//                     setState(() {
//                       _categoryController = value;
//                     });
//                   },
//                   decoration: const InputDecoration(
//                     labelText: 'Category',
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child: const Text('Submit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       // child: Column(
//       //   mainAxisSize: MainAxisSize.min,
//       //   crossAxisAlignment: CrossAxisAlignment.end,
//       //   children: [
//       //     TextField(
//       //       controller: _titleController,
//       //       decoration: const InputDecoration(hintText: "Title"),
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     TextField(
//       //       controller: _descriptionController,
//       //       decoration: const InputDecoration(hintText: "description"),
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     Row(
//       //       children: [
//       //         Radio(
//       //           value: 'income',
//       //           groupValue: _typeController,
//       //           onChanged: (value) {
//       //             setState(() {
//       //               _typeController = value.toString();
//       //             });
//       //           },
//       //         ),
//       //         const Text('Income'),
//       //         const SizedBox(width: 10),
//       //         Radio(
//       //           value: 'expense',
//       //           groupValue: _typeController,
//       //           onChanged: (value) {
//       //             setState(() {
//       //               _typeController = value.toString();
//       //             });
//       //           },
//       //         ),
//       //         const Text('Expense'),
//       //       ],
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     TextField(
//       //       controller: _amountController,
//       //       keyboardType: const TextInputType.numberWithOptions(
//       //         decimal: true,
//       //       ),
//       //       inputFormatters: [
//       //         FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))
//       //       ],
//       //       decoration: const InputDecoration(hintText: "amount"),
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     TextField(
//       //       controller: _walletController,
//       //       decoration: const InputDecoration(hintText: "wallet"),
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     TextField(
//       //       controller: _categoryController,
//       //       decoration: const InputDecoration(hintText: "category"),
//       //     ),
//       //     const SizedBox(
//       //       height: 10,
//       //     ),
//       //     ElevatedButton(
//       //       onPressed: () async {
//       //         // submit sql insert query
//       //         await _addItem();

//       //         _titleController.text = '';
//       //         _descriptionController.text = '';
//       //         _amountController.text = '';
//       //         _walletController.text = '';
//       //         _categoryController.text = '';

//       //         widget.refreshData();

//       //         // close the screen
//       //         Navigator.of(context).pop();
//       //       },
//       //       child: const Text("Submit"),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }
