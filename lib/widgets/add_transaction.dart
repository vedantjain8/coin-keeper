import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatefulWidget {
  final void Function() refreshData;
  const AddTransaction({super.key, required this.refreshData});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {


  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String _typeController = 'income';

  // Insert a new journal to the database
  Future<void> _addItem() async {
    try {
      await SQLHelper.createItem(
        _titleController.text,
        _descriptionController.text,
        (_typeController.toString().toLowerCase() == "income")
            ? int.parse('+${_amountController.text}')
            : int.parse('-${_amountController.text}'),
        (_walletController.text == "") ? "cash" : _walletController.text,
        _typeController,
        _categoryController.text,
      );
      // TODO add redirect to home page and refresh journal to view changes
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: "description"),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Radio(
                    value: 'Income',
                    groupValue: _typeController,
                    onChanged: (value) {
                      setState(() {
                        _typeController = value.toString();
                      });
                    },
                  ),
                  const Text('Income'),
                  const SizedBox(width: 10),
                  Radio(
                    value: 'Expense',
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
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(hintText: "amount"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _walletController,
                decoration: const InputDecoration(hintText: "wallet"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(hintText: "category"),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // submit sql insert query
                  await _addItem();

                  _titleController.text = '';
                  _descriptionController.text = '';
                  _amountController.text = '';
                  _walletController.text = '';
                  _categoryController.text = '';

                  widget.refreshData();

                  // close the screen
                  Navigator.of(context).pop();
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
