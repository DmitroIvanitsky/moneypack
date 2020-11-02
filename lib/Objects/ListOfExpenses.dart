import 'ExpenseNote.dart';

class ListOfExpenses {
  static List<ExpenseNote> list = List();

  static add(ExpenseNote item) {
    list.add(item);
  }

  static print(){
    for(var n in list){
      String result = (n.category + ' ' + n.sum.toString());
      return result;
    }
  }
}