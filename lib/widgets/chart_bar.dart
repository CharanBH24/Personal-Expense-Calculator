import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar(
      {Key? key,
      required this.label,
      required this.spendingAmount,
      required this.spendingPercentage})
      : super(key: key);
  final String label;
  final double spendingAmount;
  final double spendingPercentage;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: 20,
          child:
              FittedBox(child: Text('${spendingAmount.toStringAsFixed(0)}'))),
      Container(
        height: 60,
        width: 10,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(220, 200, 220, 1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                )),
          ),
          FractionallySizedBox(
            heightFactor: spendingPercentage,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ]),
      ),
      SizedBox(
        height: 4,
      ),
      Text(label)
    ]);
  }
}
