import 'dart:convert';

class ExpenseNote{
  final String category;
  final double sum;
  final DateTime date;

  ExpenseNote(this.date, this.category, this.sum);

  ExpenseNote.fromJson(Map<String, dynamic> json)
  : category = json['category'],
    sum = json['sum'],
    date = json['date'];

  Map toJson() =>
      {
        'category' : category,
        'sum' : sum,
        'date' : date
      };
}