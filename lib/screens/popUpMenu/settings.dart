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
  String _dropdownValue = _listCurrencies.first;
  TextEditingController _nameController = TextEditingController();
  // TODO add the initial value to the _nameController
  // TODO add the initial value of currency from the sharedprefeneces

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
    saveOptionCurrency(newName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.8),
        child: Column(
          children: [
            Row(
              children: [
                const Text("User Name:"),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  // TODO make this width dynamic
                  width: 220,
                  child: TextField(
                    controller: _nameController,
                    maxLength: 20,
                    maxLines: 1,
                    onSubmitted: (value) {
                      saveOptionName(value);
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Select Currency:",
                  style: TextStyle(fontSize: globalFontSize),
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
              children: [
                Text(
                  "Delete all Data:",
                  style: TextStyle(fontSize: globalFontSize),
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
                            "Decline",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _doomTable();
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
                  child: const Text("BOOM BABY"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
