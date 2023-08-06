import 'package:coinkeeper/screens/add_transaction.dart';
import 'package:coinkeeper/screens/wallet_page.dart';
import 'package:coinkeeper/widgets/list_view_builder_widget.dart';
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
  List<Map<String, dynamic>> _journals = [],
      _walletjournals = [],
      _categoriesjournals = [];
  bool _isLoading = true;
  int _choiceIndex = 0;

  final ScrollController _scrollController = ScrollController();
  int limitN = 5;
  int offsetN = 10;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(
        switchArg: "all", tableName: "transactions", limit: 10);
    final cashWalletdata = await SQLHelper.getItems(
        switchArg: "filterByTitle", tableName: "wallets", titleclm: "cash");
    final categoriesdata = await SQLHelper.getItems(
        switchArg: "categories", tableName: "transactions");

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
      tableName: "transactions",
      limit: limitN,
      offset: offsetN,
    );

    setState(() {
      _journals = [..._journals, ...newData];
      offsetN += limitN;
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabBackgroundColor,
        foregroundColor: fabForegroundColor,
        splashColor: onClickColor,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddTransaction(refreshData: refreshData),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Column(
          children: [
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
                                    Text((formatCurrency.format(
                                            _walletjournals[0]['amount']))
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
                              selectedColor: chipSelectedColor,
                              onSelected: (bool selected) async {
                                final data = await SQLHelper.getItems(
                                    switchArg: "all",
                                    tableName: "transactions");
                                setState(() {
                                  _choiceIndex = selected ? index : 0;
                                  _journals = data;
                                });
                              },
                              backgroundColor: chipBackgroundColor,
                              labelStyle: chipTextStyle,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ChoiceChip(
                              label: Text(
                                  _categoriesjournals[index - 1]['category']),
                              selected: _choiceIndex == index,
                              selectedColor: chipSelectedColor,
                              onSelected: (bool selected) async {
                                final data = await SQLHelper.getItems(
                                    switchArg: "filterByCategories",
                                    tableName: "transactions",
                                    categoriesclm:
                                        _categoriesjournals[index - 1]
                                            ["category"]);
                                setState(() {
                                  _choiceIndex = selected ? index : 0;
                                  _journals = data;
                                });
                              },
                              backgroundColor: chipBackgroundColor,
                              labelStyle: chipTextStyle,
                            ),
                          );
                        }
                      },
                    ),
                  ),
            Expanded(
              child: listViewBuilderWidget(
                journals: _journals,
                isLoading: _isLoading,
                refreshData: refreshData,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
