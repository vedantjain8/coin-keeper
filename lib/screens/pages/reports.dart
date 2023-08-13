import 'package:coinkeeper/functions/convert.dart';
import 'package:coinkeeper/provider/journal_stream.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/widgets/report_pie.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  // variables
  Map<String, double> _expensesjournals = {},
      _incomejournals = {},
      _walletjournals = {};
  bool _isLoading = true;

  void _refreshJournals() async {
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
        switchArg: "walletReport", tableName: "wallets");

    setState(() {
      _expensesjournals = listToMap(categoriesdata4expense);
      _incomejournals = listToMap(categoriesdata4income);
      _walletjournals = listToMap(categoriesdata4wallet);
      _isLoading = false;
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });
    _refreshJournals();
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: (_isLoading)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Expense Chart"),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CategoryExpense4ReportJournalStream()
                        .categoryExpense4ReportJournalStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final expensesjournals = snapshot.data ?? [];
                        return returnReportPieChart(
                            journals: listToMap(expensesjournals),
                            centerText: "Expense Chart");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Income Chart"),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CategoryIncome4ReportJournalStream()
                        .categoryIncome4ReportJournalStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final incomejournals = snapshot.data ?? [];
                        return returnReportPieChart(
                            journals: listToMap(incomejournals),
                            centerText: "Income Chart");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("wallet Chart"),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: CategoryWallet4ReportJournalStream()
                        .categoryWallet4ReportJournalStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final walletjournals = snapshot.data ?? [];
                        return returnReportPieChart(
                            journals: listToMap(walletjournals),
                            centerText: "Wallet Chart");
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
