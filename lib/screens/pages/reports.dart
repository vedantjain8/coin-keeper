import 'package:coinkeeper/functions/convert.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
import 'package:coinkeeper/widgets/report_pie.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  // variables
  Map<String, double> _expensesjournals = {};
  Map<String, double> _incomejournals = {};
  Map<String, double> _walletjournals = {};
  bool _isLoading = true;

  void _refreshJournals() async {
    final categoriesdata4expense = await SQLHelper.getItems(
        switchArg: "categoriesReport",
        wallet: "transactions",
        whereqry: "type",
        whereqryvalue: "expense");
    final categoriesdata4income = await SQLHelper.getItems(
        switchArg: "categoriesReport",
        wallet: "transactions",
        whereqry: "type",
        whereqryvalue: "income");
    final categoriesdata4wallet =
        await SQLHelper.getItems(switchArg: "walletReport", wallet: "wallets");

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
                  ElevatedButton(
                      onPressed: refreshData, child: const Text("Refresh")),
                  Text(_walletjournals.toString()),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Expense Chart"),
                  returnReportPieChart(_expensesjournals),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Income Chart"),
                  returnReportPieChart(_incomejournals),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("wallet Chart"),
                  returnReportPieChart(_walletjournals),
                ],
              ),
            ),
    );
  }
}
