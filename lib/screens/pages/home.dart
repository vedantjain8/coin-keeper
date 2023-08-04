import 'package:coinkeeper/screens/add_transaction.dart';
import 'package:coinkeeper/screens/edit_transaction.dart';
import 'package:coinkeeper/screens/wallet_page.dart';
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
  List<Map<String, dynamic>> _categoriesjournals = [];
  bool _isLoading = true;
  int _choiceIndex = 0;
  final ScrollController _scrollController = ScrollController();
  int limitN = 5;
  int offsetN = 10;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(
        switchArg: "all", wallet: "transactions", limit: 10);
    final cashWalletdata = await SQLHelper.getItems(
        switchArg: "filterByTitle", wallet: "wallets", titleclm: "cash");
    final categoriesdata = await SQLHelper.getItems(
        switchArg: "categories", wallet: "transactions");

    setState(() {
      _journals = data;
      _walletjournals = cashWalletdata;
      _categoriesjournals = categoriesdata;
      _isLoading = false;
      _choiceIndex = 0;
      offsetN = 10;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() async {
    final newData = await SQLHelper.getItems(
      switchArg: "limitAll",
      wallet: "transactions",
      limit: limitN,
      offset: offsetN,
    );

    setState(() {
      _journals = [
        ..._journals,
        ...newData
      ];
      offsetN += limitN;
    });
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WalletDetailedPage(
                          walletHead: "cash",
                        ),
                      ),
                    );
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
          (_categoriesjournals.isEmpty)
              ? Container()
              : Container(
                  height: 60,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categoriesjournals.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: const Text("All"),
                            selected: _choiceIndex == index,
                            selectedColor: Colors.blue[200],
                            onSelected: (bool selected) async {
                              final data = await SQLHelper.getItems(
                                  switchArg: "all", wallet: "transactions");
                              setState(() {
                                _choiceIndex = selected ? index : 0;
                                _journals = data;
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ChoiceChip(
                            label: Text(
                                _categoriesjournals[index - 1]['category']),
                            selected: _choiceIndex == index,
                            selectedColor: Colors.blue[200],
                            onSelected: (bool selected) async {
                              final data = await SQLHelper.getItems(
                                  switchArg: "filterByCategories",
                                  wallet: "transactions",
                                  categoriesclm: _categoriesjournals[index - 1]
                                      ["category"]);
                              setState(() {
                                _choiceIndex = selected ? index : 0;
                                _journals = data;
                              });
                            },
                            backgroundColor: Colors.grey[200],
                            labelStyle: const TextStyle(color: Colors.black),
                          ),
                        );
                      }
                    },
                  ),
                ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: _scrollController,
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
