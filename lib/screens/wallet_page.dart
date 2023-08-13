import 'package:coinkeeper/provider/journal_stream.dart';
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
  final ScrollController _scrollController = ScrollController();
  int limitN = 5;
  int offsetN = 10;

  @override
  void initState() {
    super.initState();
    walletHead = widget.walletHead;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() async {
    final newData = await SQLHelper.getItems(
      switchArg: "limit",
      tableName: "transactions",
      limit: limitN,
      offset: offsetN,
      walletclm: walletHead,
    );

    // Update the stream with the new data
    WalletJournalStream().updateJournalData([...newData]);

    // Increment the offset
    offsetN += limitN;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$walletHead Transaction"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: WalletJournalStream().walletJournalStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final data = snapshot.data ?? [];
            return listViewBuilderWidget(
              journals: data,
              // refreshData: refreshData,
              scrollController: _scrollController,
            );
          }
        },
      ),
    );
  }
}
