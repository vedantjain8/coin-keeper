import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

class SQLHelper {
  // create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          title TEXT, 
          description TEXT, 
          amount FLOAT, 
          wallet TEXT NOT NULL, 
          type TEXT NOT NULL,
          category TEXT,
          createdAt TIMESTAMP NOT NULL
          )""");

    await database.execute("""CREATE TABLE IF NOT EXISTS wallets(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          title TEXT UNIQUE, 
          amount FLOAT, 
          updatedAt TIMESTAMP NOT NULL
          )""");

    await SQLHelper.createWalletItem(0, "cash", null);
  }

  // open db
  static Future<sql.Database> db() async {
    var databasesPath = await sql.getDatabasesPath();
    var path = '$databasesPath/transaction.db';
    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        var batch = database.batch();
        await createTables(database);
        await batch.commit();
      },
    );
  }

  // read all record
  static Future<List<Map<String, dynamic>>> getItems(
      {required String? switchArg, required String? wallet, int? idclm, String? titleclm, String? walletclm }) async {
    final db = await SQLHelper.db();
    switch (switchArg) {
      case "all":
        return db.rawQuery('SELECT * FROM ($wallet)');
      case "filterById":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE id = ? order by id desc', [idclm]);
      case "filterByTitle":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE title = ? order by id desc', [titleclm]);
      case "filterByWallet":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE wallet = ? order by id desc', [walletclm]);
      default:
        return db.rawQuery("select * from transactions");
    }
  }

  // create record
  static Future<int> createItem(String title, String? description,
      double amount, String? wallet, String type, String? category) async {
    final db = await SQLHelper.db();

    wallet = (wallet ?? "cash");

    final data = {
      'title': title,
      'description': description,
      'amount': amount,
      'wallet': wallet,
      'type': type,
      'category': category,
      "createdAt": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())
    };
    final id = await db.insert(
      'transactions',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    SQLHelper.createWalletItem(amount, wallet, null);

    return id; //returns 1
  }

  // create custom wallet
  static Future createWalletItem(
      double amount, String? wallet, double? oldTransactionAmount) async {
    final db = await SQLHelper.db();

    wallet = (wallet ?? "cash");
    double calculatedTotal = 0.0;

    final result = await db.rawQuery(
      'SELECT * FROM wallets WHERE title = ?',
      [wallet],
    );

    if (result.isEmpty) {
      await db.insert(
        'wallets',
        {
          "title": wallet,
          "amount": amount,
          "updatedAt": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    } else {
      // final tranasactionResult = await db.query("select amount from transactions where id = ?", whereArgs: [transactionId]);
      oldTransactionAmount = (oldTransactionAmount ?? 0.0);
      final total = result.first['amount'] ?? 0;
      final double parsedTotal =
          total is double ? total : double.tryParse(total.toString()) ?? 0;
      calculatedTotal = parsedTotal + amount - oldTransactionAmount;

      await db.rawUpdate(
        'UPDATE wallets SET amount = ?, updatedAt = ? WHERE title = ?',
        [
          calculatedTotal,
          DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
          wallet,
        ],
      );
    }
  }

  // update item
  static Future<int> updateItem(
      int id,
      String title,
      String? description,
      double amount,
      String? wallet,
      String type,
      String? category,
      double oldTransactionAmount) async {
    final db = await SQLHelper.db();

    amount = (type.toString().toLowerCase() == "income")
        ? double.parse('+$amount')
        : double.parse('-$amount');

    final data = {
      'title': title,
      'description': description,
      'amount': amount,
      'wallet': wallet,
      'type': type,
      'category': category,
      "createdAt": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())
    };

    print(data);

    final result =
        db.update('transactions', data, where: "id = ?", whereArgs: [id]);

    // update wallet table data
    SQLHelper.createWalletItem(amount, wallet, oldTransactionAmount);
    return result;
  }

  // delete transaction record
  static Future<void> deleteItem(int id, double amount, String wallet) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("transactions", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }

  // drop database
  static Future<void> dropTable() async {
    final db = await SQLHelper.db();
    await db.execute('DROP TABLE IF EXISTS transactions');
    await db.execute('DROP TABLE IF EXISTS wallets');
    await SQLHelper.createTables(db);
  }
}
