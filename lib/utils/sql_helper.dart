import 'package:coinkeeper/settings/sharedpreferences.dart';
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
        initOption();
        var batch = database.batch();
        await createTables(database);
        await batch.commit();
      },
    );
  }

  // read all record
  static Future<List<Map<String, dynamic>>> getItems({
    required String? switchArg,
    required String? wallet,
    int? idclm,
    String? titleclm,
    String? walletclm,
    String? categoriesclm,
  }) async {
    final db = await SQLHelper.db();
    switch (switchArg) {
      case "all":
        return db.rawQuery('SELECT * FROM ($wallet) order by id desc');
      case "filterById":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE id = ? order by id desc', [idclm]);
      case "filterByTitle":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE title = ? order by id desc',
            [titleclm]);
      case "filterByWallet":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE wallet = ? order by id desc',
            [walletclm]);
      case "filterByCategories":
        return db.rawQuery(
            'SELECT * FROM ($wallet) WHERE category = ? order by id desc',
            [categoriesclm]);
      case "categories":
        return db.rawQuery('SELECT distinct(category) FROM ($wallet)');
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

    await updateWalletAmount(wallet, amount);

    return id;
  }

  static Future<void> updateWalletAmount(String wallet, double amount) async {
    final db = await SQLHelper.db();

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
      final total = result.first['amount'] ?? 0;
      final double parsedTotal =
          total is double ? total : double.tryParse(total.toString()) ?? 0;
      final calculatedTotal = parsedTotal + amount;

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

    final data = {
      'title': title,
      'description': description,
      'amount': amount,
      'wallet': wallet,
      'type': type,
      'category': category,
      "createdAt": DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())
    };

    final result =
        db.update('transactions', data, where: "id = ?", whereArgs: [id]);

    // Calculate the difference in amount for the wallet
    final amountDiff = amount - oldTransactionAmount;

    await updateWalletAmount(wallet!, amountDiff);
    return result;
  }

  // delete transaction record
  static Future<void> deleteItem(int id, double amount, String wallet) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("transactions", where: "id = ?", whereArgs: [id]);

      // Calculate the negative amount to subtract from the wallet
      final amountDiff = -amount;
      await updateWalletAmount(wallet, amountDiff);
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
    deleteOption;
  }
}
