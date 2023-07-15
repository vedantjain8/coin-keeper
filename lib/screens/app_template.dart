import 'package:coinkeeper/screens/popUpMenu/about.dart';
import 'package:coinkeeper/screens/popUpMenu/settings.dart';
import 'package:coinkeeper/widgets/wallet.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/widgets/home.dart';

class AppTemplate extends StatefulWidget {
  const AppTemplate({Key? key}) : super(key: key);

  @override
  State<AppTemplate> createState() => _AppTemplateState();
}

class _AppTemplateState extends State<AppTemplate> {
  // variables
  int _bottomNavigationBarIndex = 0;
  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      const HomePage(),
      const WalletPage(),
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
                      Icons.settings ,
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
              // TODO: add page navigation for each button
              // if (value == 1) {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const AboutPage(),
              //     ),
              //   );
              // }
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
        ],
      ),
    );
  }
}
