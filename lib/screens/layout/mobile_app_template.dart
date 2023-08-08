import 'package:coinkeeper/screens/popUpMenu/about.dart';
import 'package:coinkeeper/screens/popUpMenu/settings.dart';
import 'package:coinkeeper/screens/pages/reports.dart';
import 'package:coinkeeper/screens/pages/wallet.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/screens/pages/home.dart';

class MobileAppTemplate extends StatefulWidget {
  const MobileAppTemplate({Key? key}) : super(key: key);

  @override
  State<MobileAppTemplate> createState() => _MobileAppTemplateState();
}

class _MobileAppTemplateState extends State<MobileAppTemplate> {
  // variables
  int _bottomNavigationBarIndex = 0;
  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      const HomePage(),
      const WalletPage(),
      const ReportsPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coin Keeper"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.info_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("About"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Settings"),
                  ],
                ),
              )
            ],
            // offset:
            //     const Offset(0, 50),
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                  break;

                default:
                  break;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _bottomNavigationBarIndex,
          children: widgetList,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (bottomNavigationBarIndex) {
          setState(() {
            _bottomNavigationBarIndex = bottomNavigationBarIndex;
          });
        },
        currentIndex: _bottomNavigationBarIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallets"),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: "Report"),
        ],
      ),
    );
  }
}
