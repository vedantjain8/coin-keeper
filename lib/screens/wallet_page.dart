import 'package:coinkeeper/screens/edit_transaction.dart';
import 'package:coinkeeper/theme/consts.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';

class WalletDetailedPage extends StatefulWidget {
  final String walletHead;
  const WalletDetailedPage({super.key, required this.walletHead});

  @override
  State<WalletDetailedPage> createState() => _WalletDetailedPageState();
}

class _WalletDetailedPageState extends State<WalletDetailedPage> {
  late String walletHead;
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(switchArg: "filterByWallet",wallet: "transactions", walletclm:  walletHead);

    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    walletHead = widget.walletHead;
    _refreshJournals();
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
      appBar: AppBar(
        title: Text("$walletHead Transaction"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Container(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) => Card(
                    color: (_journals[index]['type'].toString().toLowerCase() ==
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
      ),
    );
  }
}
