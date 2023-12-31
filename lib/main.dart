import 'package:coinkeeper/screens/layout/responsive.dart';
import 'package:coinkeeper/data/consts.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _LoadSQLTable.db();
  await initCurrencyOption();
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
      home: const ResponsiveLayout(),
    );
  }
}

class _LoadSQLTable {
  static Future<sql.Database> db() async {
    var databasesPath = await sql.getDatabasesPath();
    var path = '$databasesPath/transaction.db';
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        var batch = database.batch();
        SQLHelper.createTables(database);
        await batch.commit();
      },
    );
  }
}
