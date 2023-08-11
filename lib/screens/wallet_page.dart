import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/widgets/list_view_builder_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  int limitN = 5;
  int offsetN = 10;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(
        switchArg: "filterByWallet",
        tableName: "transactions",
        walletclm: walletHead);

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
      appBar: AppBar(
        title: Text("$walletHead Transaction"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Container(
            child: listViewBuilderWidget(
          journals: _journals,
          isLoading: _isLoading,
          // refreshData: refreshData,
          scrollController: _scrollController,
        )),
      ),
    );
  }
}
