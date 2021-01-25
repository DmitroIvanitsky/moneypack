import '../Utility/Storage.dart';
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

  static List<ExpenseNote> filtered({String selMode, DateTime currentDate, String currentCategory, int day}){
    List <ExpenseNote> filteredExpensesList = [];

    if (day != null) {
      for (ExpenseNote note in ListOfExpenses.list)
        if (_isInFilter(
            selMode: selMode, noteDate: note.date, currentDate: currentDate) && note.date.weekday == day)
          filteredExpensesList.add(note);

    } else if (currentCategory != null) {
      for (ExpenseNote note in ListOfExpenses.list)
        if (_isInFilter(selMode: selMode, noteDate: note.date, currentDate: currentDate) && note.category == currentCategory)
          filteredExpensesList.add(note);
    } else {
      for (ExpenseNote note in ListOfExpenses.list)
        if (_isInFilter(selMode: selMode, noteDate: note.date, currentDate: currentDate))
          filteredExpensesList.add(note);
    }

    return filteredExpensesList;
  }

  static _isInFilter({String selMode, DateTime noteDate, DateTime currentDate}) {
    if (noteDate == null) return false;

    switch (selMode) {
      case 'День':
        return noteDate.year == currentDate.year &&
            noteDate.month == currentDate.month &&
            noteDate.day == currentDate.day;
        break;
      case 'Неделя':
        int weekDay = Storage.langCode == 'ru' || Storage.langCode == 'uk'
            ? currentDate.weekday
            : currentDate.weekday + 1;
        DateTime nextWeekFirstDay =
        currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            noteDate.isBefore(nextWeekFirstDay);
        break;
      case 'Неделя(Д)':
        int weekDay = Storage.langCode == 'ru' || Storage.langCode == 'uk'
            ? currentDate.weekday
            : currentDate.weekday + 1;
        DateTime nextWeekFirstDay =
        currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            noteDate.isBefore(nextWeekFirstDay);
        break;
      case 'Месяц':
        return noteDate.year == currentDate.year && noteDate.month == currentDate.month;
        break;
      case 'Год':
        return noteDate.year == currentDate.year;
        break;
    }
  }
}



