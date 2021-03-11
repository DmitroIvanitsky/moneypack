import 'ListOfExpenses.dart';
import 'ListOfIncomes.dart';


class AllData {
  List<String> expenseCatList = List();
  List<String> incomeCatList = List();
  ListOfExpenses listOfExpenses = ListOfExpenses();
  ListOfIncomes listOfIncomes = ListOfIncomes();

  AllData(
      {this.expenseCatList, this.incomeCatList, this.listOfExpenses, this.listOfIncomes});

  AllData.fromJson(Map<String, dynamic> json) {
    if (json == null) return;

    if (json['listOfExpenses'] != null)
      listOfExpenses = ListOfExpenses.fromJson(json['listOfExpenses']);
    if (json['listOfIncomes'] != null)
      listOfIncomes = ListOfIncomes.fromJson(json['listOfIncomes']);

    expenseCatList = (json['expenseCatList'] == null) ? [] : List<String>.from(
        json['expenseCatList']);
    incomeCatList = (json['incomeCatList'] == null) ? [] : List<String>.from(
        json['incomeCatList']);
  }

  toJson() {
    return {
      'expenseCatList': expenseCatList,
      'incomeCatList': incomeCatList,
      'listOfExpenses': listOfExpenses.toJson(),
      'listOfIncomes': listOfIncomes.toJson()
    };
  }
}