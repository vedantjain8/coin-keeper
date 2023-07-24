import 'package:coinkeeper/screens/add_transaction.dart';
import 'package:coinkeeper/screens/edit_transaction.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/theme/color.dart';
import 'package:coinkeeper/theme/consts.dart';

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
    final data =
        await SQLHelper.getItems(switchArg: "all", wallet: "transactions");
    final cashWalletdata = await SQLHelper.getItems(
        switchArg: "filterByTitle", wallet: "wallets", titleclm: "cash");

    setState(() {
      _journals = data;
      _walletjournals = cashWalletdata;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts

    // ModalRoute.of(context)?.addScopedWillPopCallback((route) {
    //   refreshData();
    //   return Future.value(true);
    // } as WillPopCallback);
  }

  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });
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
    return RefreshIndicator(
      onRefresh: refreshData,
      child: Column(
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTransaction(refreshData: refreshData),
                    ),
                  ),
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
                                  Text((formatCurrency
                                          .format(_walletjournals[0]['amount']))
                                      .toString())
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
                      color:
                          (_journals[index]['type'].toString().toLowerCase() ==
                                  "income")
                              ? Colors.green[100]
                              : Colors.red[100],
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditTransaction(
                                  id: _journals[index]["id"],
                                  refreshData: refreshData),
                            ),
                          );
                        },
                        title: Text(_journals[index]['title'].toString()),
                        subtitle: Text(_journals[index]['createdAt']),
                        leading: (_journals[index]['wallet'] == "cash")
                            ? const Icon(
                                Icons.payment,
                                size: 42,
                              )
                            : Text(_journals[index]['wallet']),
                        trailing: Text(
                          formatCurrency.format(_journals[index]['amount']),
                          // style: const TextStyle(
                          //     color: Colors.white),
                          // color: (_journals[index]['type']
                          //             .toString()
                          //             .toLowerCase() ==
                          //         "income")
                          //     ? Colors.green
                          //     : Colors.red),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
