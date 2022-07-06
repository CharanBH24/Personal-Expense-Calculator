import 'package:flutter/material.dart';

class Transaction {
  String? title;
  double? price;
  DateTime? dateTime;
  String? desc;

  Transaction({
    @required this.title,
    this.desc,
    @required this.price,
    @required this.dateTime,
  });
}
