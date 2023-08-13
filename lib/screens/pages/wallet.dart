import 'package:coinkeeper/provider/journal_stream.dart';
import 'package:coinkeeper/provider/reload_data.dart';
import 'package:coinkeeper/screens/wallet_page.dart';
import 'package:coinkeeper/data/consts.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/theme/color.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: WalletPageJournalStream().walletPageJournalStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final walletjournals = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: walletjournals.length,
                  itemBuilder: (context, index) => Card(
                    clipBehavior: Clip.hardEdge,
                    color: primaryColor,
                    child: InkWell(
                      splashColor: onClickColor,
                      onTap: () {
                        final walletHead = walletjournals[index]['title'];

                        loadData4Wallet_page(walletHead);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WalletDetailedPage(
                              walletHead: walletHead,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              walletjournals[index]['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text("Total Balance",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(
                              formatCurrency
                                  .format(walletjournals[index]['amount']),
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
