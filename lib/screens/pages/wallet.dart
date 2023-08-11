import 'package:coinkeeper/screens/wallet_page.dart';
import 'package:coinkeeper/data/consts.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<Map<String, dynamic>> _walletjournals = [];
  bool _isLoading = true;

  Future<void> _refreshWalletJournals() async {
    setState(() {
      _isLoading = true;
    });

    SQLHelper.getItems(switchArg: "all", tableName: "wallets")
        .then((cashWalletdata) {
      setState(() {
        _walletjournals = cashWalletdata;
        _isLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshWalletJournals();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshWalletJournals,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _refreshWalletJournals,
            child: const Text("Refresh"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _walletjournals.length,
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.hardEdge,
                color: primaryColor,
                child: InkWell(
                  splashColor: onClickColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WalletDetailedPage(
                          walletHead: _walletjournals[index]['title'],
                        ),
                      ),
                    );
                  },
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_walletjournals[index]['title'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Total Balance",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                formatCurrency
                                    .format(_walletjournals[index]['amount']),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontFamily:
                                        GoogleFonts.jetBrainsMono().fontFamily),
                              ),
                            ],
                          ),
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
