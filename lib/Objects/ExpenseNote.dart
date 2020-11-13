class ExpenseNote{
  final String category;
  final double sum;
  DateTime date;

  ExpenseNote(this.date, this.category, this.sum);

  ExpenseNote.fromJson(Map<String, dynamic> json)
  : category = json['category'],
    sum = json['sum'],
    date =  DateTime.parse(json['date'] ).toLocal();

  Map toJson() =>
      {
        'category' : category,
        'sum' : sum,
        'date' : date.toIso8601String()
      };
}