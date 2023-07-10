import 'package:sqflite/sqflite.dart' as sql;
import 'package:intl/intl.dart';

class SQLHelper {
  // create table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          title TEXT, 
          description TEXT, 
          amount INTEGER, 
          wallet TEXT NOT NULL, 
          type TEXT NOT NULL,
          category TEXT,
          createdAt TIMESTAMP NOT NULL
          )""");

    await database.execute("""CREATE TABLE wallets(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
          title TEXT UNIQUE, 
          amount INTEGER, 
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

  static Future<List<Map<String, dynamic>>> getWalletItems() async {
    final db = await SQLHelper.db();

    // return db.query('wallets');
    return db.rawQuery('SELECT * FROM wallets');
  }

  static Future<List<Map<String, dynamic>>> getCashWalletItems(
      String wallet) async {
    final db = await SQLHelper.db();

    // return db.query('wallets', orderBy: "id desc");
    return db.rawQuery(
        'SELECT * FROM wallets WHERE title = ? order by id desc', [wallet]);
  }

  // create record
  static Future<int> createItem(String title, String? description, int amount,
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

  // custom wallet
  static Future createWalletItem(int amount, String? wallet) async {
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
      final int parsedTotal =
          total is int ? total : int.tryParse(total.toString()) ?? 0;
      final int calculatedTotal = parsedTotal + amount;

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

  // drop database
  static Future<void> dropTable() async {
    final db = await SQLHelper.db();
    await db.execute('DROP TABLE IF EXISTS transactions');
    await db.execute('DROP TABLE IF EXISTS wallets');
    await SQLHelper.createTables(db);
  }
}
