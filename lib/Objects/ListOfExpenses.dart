import 'ExpenseNote.dart';

class ListOfExpenses {
  static List<ExpenseNote> list = List();

  static add(ExpenseNote item) {
    list.add(item);
    print(list.length);
  }

  static double sum(){
    double s = 0;
    for(int i = 0; i < list.length; i++){
      s += list[i].sum;
    }
    return s;
  }
}