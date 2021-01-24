import '../Utility/Storage.dart';
import '../Objects/IncomeNote.dart';

class ListOfIncomes {
  static List<IncomeNote> list = List();

  ListOfIncomes();

  static add(IncomeNote item){
    list.add(item);
  }

  static double sum(){
    double sum = 0;
    for(int i = 0; i < list.length; i++){
      sum += list[i].sum;
    }
    return sum;
  }

  ListOfIncomes.fromJson(Map<String, dynamic> json){
    if (json['list'] != null)
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

  // static List<IncomeNote> filtered({String selMode, DateTime currentDate}){
  //   List <IncomeNote> filteredList = [];
  //
  //   for (IncomeNote note in ListOfIncomes.list)
  //     if (_isInFilter(selMode: selMode, noteDate: note.date, currentDate: currentDate))
  //       filteredList.add(note);
  //
  //     return filteredList;
  // }

  // static _isInFilter({String selMode, DateTime noteDate, DateTime currentDate}) {
  //   if (noteDate == null) return false;
  //
  //   switch (selMode) {
  //     case 'День':
  //       return noteDate.year == currentDate.year &&
  //           noteDate.month == currentDate.month &&
  //           noteDate.day == currentDate.day;
  //       break;
  //     case 'Неделя':
  //       int weekDay = Storage.langCode == 'ru' || Storage.langCode == 'uk'
  //           ? currentDate.weekday
  //           : currentDate.weekday + 1;
  //       DateTime nextWeekFirstDay =
  //       currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
  //       return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
  //           noteDate.isBefore(nextWeekFirstDay);
  //       break;
  //     case 'Неделя(Д)':
  //       int weekDay = Storage.langCode == 'ru' || Storage.langCode == 'uk'
  //           ? currentDate.weekday
  //           : currentDate.weekday + 1;
  //       DateTime nextWeekFirstDay =
  //       currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
  //       return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
  //           noteDate.isBefore(nextWeekFirstDay);
  //       break;
  //     case 'Месяц':
  //       return noteDate.year == currentDate.year && noteDate.month == currentDate.month;
  //       break;
  //     case 'Год':
  //       return noteDate.year == currentDate.year;
  //       break;
  //   }
  // }
}