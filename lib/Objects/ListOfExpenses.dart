import 'ExpenseNote.dart';

class ListOfExpenses {
  static List<ExpenseNote> list = List();

  ListOfExpenses();

  static add(ExpenseNote item) {
    list.add(item);
  }

  static double sum(){
    double sum = 0;
    for(int i = 0; i < list.length; i++){
      sum += list[i].sum;
    }
    return sum;
  }

  ListOfExpenses.fromJson(Map<String, dynamic> json){
    if (json['list'] != null)
    list = List<ExpenseNote>.from(json['list'].map((i) => ExpenseNote.fromJson(i)));
  }

  toJson() {
    List<Map> tmpList = [];

    for(ExpenseNote e in list) {
      tmpList.add(e.toJson());
    }
    return {
      'list' : tmpList
    };
  }
}



