class IncomeNote{
  final String category;
  final double sum;
  DateTime date;
  final String comment;

  IncomeNote({this.date, this.category, this.sum, this.comment});

  IncomeNote.fromJson(Map<String, dynamic> json)
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