import 'package:flutter/material.dart';

class ExpenseNote{
  String category;
  double sum;
  DateTime date;
  String comment;

  ExpenseNote({
    @required this.date,
    @required this.category,
    @required this.sum,
    this.comment
  });

  ExpenseNote.fromJson(Map<String, dynamic> json)
  : category = json['category'],
    sum = json['sum'],
    date =  DateTime.parse(json['date'] ).toLocal(),
    comment = json['comment'];

  Map toJson() =>
      {
        'category' : category,
        'sum' : sum,
        'date' : date.toIso8601String(),
        'comment' : comment
      };
}