import 'package:coinkeeper/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

Widget returnReportPieChart({
  required Map<String, double> journals,
  required String centerText,
}) {
  return journals.isNotEmpty
      ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: PieChart(
            animationDuration: const Duration(milliseconds: 800),
            dataMap: journals,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            centerText: centerText,
            baseChartColor: pieChartBaseChartColor,
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
      : const Text("NO DATA FOUND");
}
