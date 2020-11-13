import 'package:flutter_tutorial/Objects/IncomeNote.dart';

class ListOfIncome {
  static List<IncomeNote> list = List();

  ListOfIncome();

  static add(IncomeNote item){
    list.add(item);
  }

  static double sum(){
    double s = 0;
    for(int i = 0; i < list.length; i++){
      s += list[i].sum;
    }
    return s;
  }

  ListOfIncome.fromJson(Map<String, dynamic> json){
    list = List<IncomeNote>.from(json['list'].map((i) => IncomeNote.fromJson(i)));
  }

  toJson() {
    List<Map> tmpList = [];

    for(IncomeNote e in list){
      tmpList.add(e.toJson());
    }
    return{
      'list' : tmpList
    };
  }
}