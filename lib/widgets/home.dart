import 'package:flutter/material.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/theme/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables
  List<Map<String, dynamic>> _journals = [];
  List<Map<String, dynamic>> _walletjournals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    final walletdata = await SQLHelper.getWalletItems();

    setState(() {
      _journals = data;
      _walletjournals = walletdata;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  String _typeController = 'income';

  void _showForm() async {
    showModalBottomSheet(
      context: context,
      elevation: 30,
      isScrollControlled: true,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 45,
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

                  // close the bottom sheet
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
    } catch (e) {
      print(e);
    }
    _refreshJournals();
  }

  // drop table
  Future<void> _doomTable() async {
    try {
      await SQLHelper.dropTable();
      _refreshJournals();
    } catch (e) {
      print('yaha se journal error on doomtable function');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () => _doomTable(),
                child: const Text("BOOM BABY"),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                onPressed: () => _showForm(),
                // onPressed: () async {
                //   await SQLHelper.createItem(
                //     "abc",
                //     "pqr",
                //     10,
                //     "cash",
                //     "income",
                //     "s",
                //   );
                //   _refreshJournals();
                // },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        SizedBox(
          child: Center(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: onClickColor,
                onTap: () {
                  // TODO: add navigation to wallets page of cash to show filtered cash transactions
                  debugPrint('Card tapped.');
                },
                child: SizedBox(
                  height: 80,
                  child: Card(
                    color: primaryColor,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Cash Balance"),
                                Text(_walletjournals[0]['amount'].toString())
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) => Card(
                    color: secondaryColor,
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(_journals[index]['title'].toString()),
                      subtitle: Text(_journals[index]['createdAt']),
                      leading: (_journals[index]['wallet'] == "cash")
                          ? const Icon(
                              Icons.payment,
                              size: 42,
                            )
                          : Text(_journals[index]['wallet']),
                      trailing: Text(
                        _journals[index]['amount'].toString(),
                        style: TextStyle(
                            color: (_journals[index]['type']
                                        .toString()
                                        .toLowerCase() ==
                                    "income")
                                ? Colors.green
                                : Colors.red),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
