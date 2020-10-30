import 'package:flutter_tutorial/ExpenseNote.dart';

class ListOfExpenses {
  List<ExpenseNote> list = List();

  add(ExpenseNote item) {
    list.add(item);
  }
}
