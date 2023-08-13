import 'package:coinkeeper/provider/journal_stream.dart';
import 'package:coinkeeper/utils/sql_helper.dart';

void loadData4NavPages() async {
  // home page
  final journalData = await SQLHelper.getItems(
    switchArg: "all",
    tableName: "transactions",
    limit: 10,
  );
  final categoriesData = await SQLHelper.getItems(
    switchArg: "categories",
    tableName: "transactions",
  );
  final cashWalletData = await SQLHelper.getItems(
    switchArg: "filterByTitle",
    tableName: "wallets",
    titleclm: "cash",
  );

  // wallet page
  final walletData = await SQLHelper.getItems(
    switchArg: "all",
    tableName: "wallets",
  );

  // reports page
  final categoriesdata4expense = await SQLHelper.getItems(
      switchArg: "categoriesReport",
      tableName: "transactions",
      whereqry: "type",
      whereqryvalue: "expense");
  final categoriesdata4income = await SQLHelper.getItems(
      switchArg: "categoriesReport",
      tableName: "transactions",
      whereqry: "type",
      whereqryvalue: "income");
  final categoriesdata4wallet = await SQLHelper.getItems(
    switchArg: "walletReport",
    tableName: "wallets",
  );

  // Update the journal data through the stream
  CategoryJournalStream().updateJournalData(categoriesData);
  JournalStream().updateJournalData(journalData);
  CashWalletHeadJournalStream().updateJournalData(cashWalletData);
  WalletPageJournalStream().updateJournalData(walletData);
  CategoryExpense4ReportJournalStream()
      .updateJournalData(categoriesdata4expense);
  CategoryIncome4ReportJournalStream().updateJournalData(categoriesdata4income);
  CategoryWallet4ReportJournalStream().updateJournalData(categoriesdata4wallet);
}

void loadData4Wallet_page(String walletHead) async {
  final walletJournalData = await SQLHelper.getItems(
    switchArg: "filterByWallet",
    tableName: "transactions",
    walletclm: walletHead,
  );

  WalletJournalStream().updateJournalData(walletJournalData);
}
