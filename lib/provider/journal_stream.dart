import 'dart:async';

class JournalStream {
  List<Map<String, dynamic>> currentData = [];
  static final JournalStream _instance = JournalStream._internal();

  factory JournalStream() => _instance;

  JournalStream._internal();

  final StreamController<List<Map<String, dynamic>>> _journalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get journalStream =>
      _journalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    currentData.addAll(newData);
    _journalController.sink.add(currentData);
  }

  void clearJournalData() {
    currentData.clear();
  }

  void dispose() {
    _journalController.close();
  }
}

// class CategoryJournalStream {
//   static final CategoryJournalStream _instance =
//       CategoryJournalStream._internal();

//   factory CategoryJournalStream() => _instance;

//   CategoryJournalStream._internal();

//   final StreamController<List<Map<String, dynamic>>>
//       _categoryjournalController =
//       StreamController<List<Map<String, dynamic>>>.broadcast();

//   Stream<List<Map<String, dynamic>>> get categoryjournalStream =>
//       _categoryjournalController.stream;

//   void updateJournalData(List<Map<String, dynamic>> newData) async {
//     _categoryjournalController.sink.add(newData);
//   }

//   void dispose() {
//     _categoryjournalController.close();
//   }
// }

class CashWalletHeadJournalStream {
  static final CashWalletHeadJournalStream _instance =
      CashWalletHeadJournalStream._internal();

  factory CashWalletHeadJournalStream() => _instance;

  CashWalletHeadJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>>
      _cashWalletHeadJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get cashWalletHeadJournalStream =>
      _cashWalletHeadJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    _cashWalletHeadJournalController.sink.add(newData);
  }

  void dispose() {
    _cashWalletHeadJournalController.close();
  }
}

class WalletPageJournalStream {
  static final WalletPageJournalStream _instance =
      WalletPageJournalStream._internal();

  factory WalletPageJournalStream() => _instance;

  WalletPageJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>>
      _walletPageJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get walletPageJournalStream =>
      _walletPageJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    _walletPageJournalController.sink.add(newData);
  }

  void dispose() {
    _walletPageJournalController.close();
  }
}

class CategoryExpense4ReportJournalStream {
  static final CategoryExpense4ReportJournalStream _instance =
      CategoryExpense4ReportJournalStream._internal();

  factory CategoryExpense4ReportJournalStream() => _instance;

  CategoryExpense4ReportJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>>
      _categoryExpense4ReportJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get categoryExpense4ReportJournalStream =>
      _categoryExpense4ReportJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    _categoryExpense4ReportJournalController.sink.add(newData);
  }

  void dispose() {
    _categoryExpense4ReportJournalController.close();
  }
}

class CategoryIncome4ReportJournalStream {
  static final CategoryIncome4ReportJournalStream _instance =
      CategoryIncome4ReportJournalStream._internal();

  factory CategoryIncome4ReportJournalStream() => _instance;

  CategoryIncome4ReportJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>>
      _categoryIncome4ReportJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get categoryIncome4ReportJournalStream =>
      _categoryIncome4ReportJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    _categoryIncome4ReportJournalController.sink.add(newData);
  }

  void dispose() {
    _categoryIncome4ReportJournalController.close();
  }
}

class CategoryWallet4ReportJournalStream {
  static final CategoryWallet4ReportJournalStream _instance =
      CategoryWallet4ReportJournalStream._internal();

  factory CategoryWallet4ReportJournalStream() => _instance;

  CategoryWallet4ReportJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>>
      _categoryWallet4ReportJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get categoryWallet4ReportJournalStream =>
      _categoryWallet4ReportJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    _categoryWallet4ReportJournalController.sink.add(newData);
  }

  void dispose() {
    _categoryWallet4ReportJournalController.close();
  }
}

class WalletJournalStream {
  List<Map<String, dynamic>> currentData = [];
  static final WalletJournalStream _instance = WalletJournalStream._internal();

  factory WalletJournalStream() => _instance;

  WalletJournalStream._internal();

  final StreamController<List<Map<String, dynamic>>> _walletJournalController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get walletJournalStream =>
      _walletJournalController.stream;

  void updateJournalData(List<Map<String, dynamic>> newData) async {
    currentData.addAll(newData);
    _walletJournalController.sink.add(currentData);
  }

  void clearJournalData() {
    currentData.clear();
  }

  void dispose() {
    _walletJournalController.close();
    currentData.clear();
  }
}
