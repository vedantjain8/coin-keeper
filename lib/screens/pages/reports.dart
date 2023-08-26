import 'package:coinkeeper/functions/convert.dart';
import 'package:coinkeeper/provider/journal_stream.dart';
import 'package:coinkeeper/widgets/report_pie.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
