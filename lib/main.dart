import 'package:coinkeeper/screens/app_template.dart';
import 'package:coinkeeper/theme/consts.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initCurrencyOption();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Coin Keeper Material App",
      theme: ThemeData(useMaterial3: true),
      home: const AppTemplate(),
    );
  }
}
