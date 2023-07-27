import 'package:coinkeeper/functions/convert.dart';
import 'package:coinkeeper/utils/sql_helper.dart';
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
                  _expensesjournals.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            animationDuration:
                                const Duration(milliseconds: 800),
                            dataMap: _expensesjournals,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                            legendOptions: const LegendOptions(
                              showLegends: true,
                              legendPosition: LegendPosition.bottom,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        )
                      : const Text("NO DATA"),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("Income Chart"),
                  _incomejournals.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            animationDuration:
                                const Duration(milliseconds: 800),
                            dataMap: _incomejournals,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                            legendOptions: const LegendOptions(
                              showLegends: true,
                              legendPosition: LegendPosition.bottom,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        )
                      : const Text("NOT DATA"),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text("wallet Chart"),
                  _walletjournals.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PieChart(
                            animationDuration:
                                const Duration(milliseconds: 800),
                            dataMap: _walletjournals,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                            legendOptions: const LegendOptions(
                              showLegends: true,
                              legendPosition: LegendPosition.bottom,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        )
                      : const Text("NNOO DATA"),
                ],
              ),
            ),
    );
  }
}
