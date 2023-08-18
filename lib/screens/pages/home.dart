import 'package:coinkeeper/screens/transaction.dart';
import 'package:coinkeeper/screens/wallet_page.dart';
import 'package:coinkeeper/settings/sharedpreferences.dart';
import 'package:coinkeeper/widgets/list_view_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/theme/color.dart';
import 'package:coinkeeper/data/consts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:coinkeeper/provider/journal_stream.dart';
import 'package:coinkeeper/provider/reload_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // variables

  final ScrollController _scrollController = ScrollController();
  int limitN = 5;
  int offsetN = 10;

  String? _username;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _updateValues();
    loadData4NavPages();
    super.initState();

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

    // Update the stream with the new data
    JournalStream().updateJournalData([...newData]);

    // Increment the offset
    offsetN += limitN;
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  Future<void> _updateValues() async {
    getOption("userName").then((value) {
      setState(() {
        _username = (value == null) ? "guest" : value;
      });
    });
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
            builder: (context) => const TransactionForm(),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi! ${greeting()}"),
                    Text(
                      _username.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: onClickColor,
                onTap: () {
                  const walletHead = "cash";

                  loadData4WalletPage(walletHead);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WalletDetailedPage(
                        walletHead: walletHead,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: primaryColor,
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CashWalletHeadJournalStream()
                        .cashWalletHeadJournalStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final walletjournals = snapshot.data ?? [];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (walletjournals.isNotEmpty)
                                Text(
                                  (formatCurrency
                                      .format(walletjournals[0]['amount'])),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.merge(
                                        TextStyle(
                                            color: Colors.white,
                                            fontFamily:
                                                GoogleFonts.jetBrainsMono()
                                                    .fontFamily,
                                            fontWeight: FontWeight.w700),
                                      ),
                                ),
                              const Text(
                                "Balance",
                              ),
                              const SizedBox(height: 50),
                              if (walletjournals.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      walletjournals[0]["title"].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.apply(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              fontWeightDelta: 2),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    const Icon(Icons.money, color: Colors.white)
                                  ],
                                )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: JournalStream().journalStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final journals = snapshot.data ?? [];
                  return listViewBuilderWidget(
                    journals: journals,
                    scrollController: _scrollController,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
