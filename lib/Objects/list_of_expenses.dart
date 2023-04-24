import 'record.dart';

class ListOfExpenses {
  List<Note> list = [];

  get getList => list;

  ListOfExpenses();


  ListOfExpenses.fromJson(Map<String, dynamic> json){
    if (json != null && json['list'] != null)
     list = List<Note>.from(json['list'].map((i) => Note.fromJson(i)));
  }

  toJson() {
    List<Map> tmpList = [];

    for(Note e in list) {
      tmpList.add(e.toJson());
    }
    return {
      'list' : tmpList
    };
  }
}



