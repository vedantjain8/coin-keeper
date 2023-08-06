import 'package:coinkeeper/screens/edit_transaction.dart';
import 'package:coinkeeper/theme/color.dart';
import 'package:coinkeeper/theme/consts.dart';
import 'package:flutter/material.dart';

Widget listViewBuilderWidget({
  required List<Map<String, dynamic>> journals,
  required bool isLoading,
  required void Function() refreshData,
  ScrollController? scrollController,
}) {
  return isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          controller: scrollController,
          itemCount: journals.length,
          itemBuilder: (context, index) => Card(
            color:
                (journals[index]['type'].toString().toLowerCase() == "income")
                    ? listviewBuilderListIncomeColor
                    : listviewBuilderListExpenseColor,
            margin: const EdgeInsets.all(15),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditTransaction(
                        id: journals[index]["id"], refreshData: refreshData),
                  ),
                );
              },
              title: Text(journals[index]['title'].toString()),
              subtitle: Text(journals[index]['createdAt']),
              leading: (journals[index]['wallet'] == "cash")
                  ? const Icon(
                      Icons.payment,
                      size: 42,
                    )
                  : Text(journals[index]['wallet']),
              trailing: Text(
                formatCurrency.format(journals[index]['amount']),
              ),
            ),
          ),
        );
}
