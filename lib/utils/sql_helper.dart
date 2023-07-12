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
  }

  // open db
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'transaction.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        var batch = database.batch();
        await createTables(database);
        await batch.commit();
      },
    );
  }

  // read all record
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();

    return db.query('transactions', orderBy: "id desc");
  }

  // read single record
  static Future<List<Map<String, dynamic>>> getItemsFromID(int id) async {
    final db = await SQLHelper.db();

    return db.rawQuery('SELECT * FROM transactions WHERE id = ?', [id]);
  }

  // read all wallet items
  static Future<List<Map<String, dynamic>>> getWalletItems() async {
    final db = await SQLHelper.db();

    return db.rawQuery('SELECT * FROM wallets');
  }

  // read a specific wallet
  static Future<List<Map<String, dynamic>>> getCashWalletItems(
      String wallet) async {
    final db = await SQLHelper.db();

    return db.rawQuery(
        'SELECT * FROM wallets WHERE title = ? order by id desc', [wallet]);
  }

  // create record
  static Future<int> createItem(String title, String? description, double amount,
      String? wallet, String type, String? category) async {
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

    SQLHelper.createWalletItem(amount, wallet);

    return id; //returns 1
  }

  // create custom wallet
  static Future createWalletItem(double amount, String? wallet) async {
    final db = await SQLHelper.db();

    wallet = (wallet ?? "cash");

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
      final double calculatedTotal = parsedTotal + amount;

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
  static Future<int> updateItem(int id, String title, String? description,
      double amount, String? wallet, String type, String? category) async {
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

    final result = db.update('transactions', data, where: "id = ?", whereArgs: [id]);
    
    // update wallet table data
    SQLHelper.createWalletItem(amount, wallet);
    return result;
  }

  // drop database
  static Future<void> dropTable() async {
    final db = await SQLHelper.db();
    await db.execute('DROP TABLE IF EXISTS transactions');
    await db.execute('DROP TABLE IF EXISTS wallets');
    await SQLHelper.createTables(db);
  }
}
