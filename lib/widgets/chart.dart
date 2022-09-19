import 'package:flutter/material.dart';
import 'package:flutter_expense_ui/models/transaction.dart';
import 'package:flutter_expense_ui/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekDay.day &&
            recentTransaction[i].date.month == weekDay.month &&
            recentTransaction[i].date.year == weekDay.year) {
          totalSum += recentTransaction[i].amount;
        }
      }
      return {'day': DateFormat.E().format(weekDay), 'amount': totalSum};
    }).reversed.toList();
  }

  Widget build(BuildContext contex) {
    print(groupedTransactionValues);
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: groupedTransactionValues.map((data) {
              return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      label: data['day'].toString(),
                      spendingAmount: double.parse(data['amount'].toString()),
                      spendingPctOfTotal: maxSpending == 0.0
                          ? 0.0
                          : double.parse(data['amount'].toString()) /
                              maxSpending));
            }).toList(),
          ),
        ));
  }

  double get maxSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => double.parse(item['amount'].toString()) + sum);
  }
}
