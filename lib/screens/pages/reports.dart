import 'package:coinkeeper/functions/convert.dart';
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
                  returnReportPieChart(
                      journals: _expensesjournals, centerText: "Expense Chart"),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Income Chart"),
                  returnReportPieChart(
                      journals: _incomejournals, centerText: "Income Chart"),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("wallet Chart"),
                  returnReportPieChart(
                      journals: _walletjournals, centerText: "Wallet Chart"),
                ],
              ),
            ),
    );
  }
}
