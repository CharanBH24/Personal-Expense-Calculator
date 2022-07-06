import 'package:flutter/material.dart';
import 'package:personal_expense_calculator/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_calculator/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  const Chart({Key? key, required this.recentTransaction}) : super(key: key);

  final List<Transaction> recentTransaction;

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].dateTime?.day == weekDay.day &&
            recentTransaction[i].dateTime?.year == weekDay.year &&
            recentTransaction[i].dateTime?.month == weekDay.month) {
          totalSum += recentTransaction[i].price!;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    return groupedTransactionValues.fold(0.0, (sum, tx) {
      return sum + tx['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: data['day'],
                    spendingAmount: data['amount'],
                    spendingPercentage: data['amount'] / maxSpending),
              );
            }).toList()),
      ),
    );
  }
}
