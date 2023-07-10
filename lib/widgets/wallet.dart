import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/theme/color.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<Map<String, dynamic>> _walletjournals = [];
  bool _isLoading = true;

  void _refreshWalletJournals() {
    setState(() {
      _isLoading = true;
    });

    SQLHelper.getWalletItems().then((cashWalletdata) {
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
    return Column(
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
                  // TODO: add navigation to wallets page of cash to show filtered cash transactions
                  debugPrint('Card tapped.');
                },
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_walletjournals[index]['title']),
                            Text(_walletjournals[index]['amount'].toString())
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
