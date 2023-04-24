import 'package:flutter/material.dart';

class Note{
  String category;
  double sum;
  DateTime date;
  String comment;

  Note({
    @required this.date,
    @required this.category,
    @required this.sum,
    this.comment
  });

  Note.fromJson(Map<String, dynamic> json)
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

  @override
  bool operator ==(Object other) {
    return other is Note
        && this.category == other.category
        && this.sum == other.sum
        && this.date == other.date
        && this.comment == other.comment;
  }

  @override
  int get hashCode => date.millisecondsSinceEpoch;
}