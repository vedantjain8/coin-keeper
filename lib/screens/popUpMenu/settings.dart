import 'package:coinkeeper/settings/sharedpreferences.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/theme/consts.dart';
import 'package:intl/intl.dart';

List<String> _listCurrencies = ["USD", "INR", "EUR"];

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // variables
  String _dropdownValue = "";
  TextEditingController _nameController = TextEditingController();

  // drop table
  Future<void> _doomTable() async {
    try {
      await SQLHelper.dropTable();
    } catch (e) {
      print('yaha se journal error on doomtable function');
      print(e);
    }
  }

  void updateCurrencyName(String newName) {
    formatCurrency = NumberFormat.simpleCurrency(name: newName);
    saveOption('currency', newName);
  }

  Future<void> _updateValues() async {
    getOption("userName")
        .then((value) => _nameController = TextEditingController(text: value));

    final currency = await getOption("currency");
    setState(() {
      _dropdownValue = currency ?? _listCurrencies.first;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
    print("dispose used");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getOption("userName"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data to be fetched
          return const Center(child: CircularProgressIndicator());
        } else {
          // Once the data is available, build the rest of the UI
          return Scaffold(
            appBar: AppBar(
              title: const Text("Settings"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "User Name:",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _nameController,
                          maxLength: 20,
                          maxLines: 1,
                          onChanged: (value) {
                            saveOption("userName", value);
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select Currency:",
                      ),
                      ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          value: _dropdownValue,
                          icon: const Icon(Icons.attach_money),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _dropdownValue = value!;
                              updateCurrencyName(_dropdownValue);
                            });
                          },
                          items: _listCurrencies
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delete all Data:",
                      ),
                      ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            icon: const Icon(Icons.warning),
                            iconColor: Colors.red,
                            title: const Text("Are you sure?"),
                            content: const SingleChildScrollView(
                                child: Text(
                                    "By accepting you clear all the data from this app")),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _doomTable();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: const Text("Delete All Data"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
