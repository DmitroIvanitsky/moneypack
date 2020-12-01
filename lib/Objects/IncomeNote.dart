class IncomeNote{
  final String category;
  final double sum;
  DateTime date;

  IncomeNote({this.date, this.category, this.sum});

  IncomeNote.fromJson(Map<String, dynamic> json)
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