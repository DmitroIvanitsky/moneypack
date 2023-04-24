import 'package:flutter/cupertino.dart';

import '../interfaces/expense_service_interface.dart';
import '../Objects/list_of_expenses.dart';
import '../Objects/record.dart';
import '../Utility/app_localizations.dart';
import '../interfaces/storage_interface.dart';

class ExpenseService implements ExpenseServiceInterface {
  static StorageInterface _storage;
  static bool _isInitialized = false;

  static final ExpenseService _instance = ExpenseService._();

  ExpenseService._();


  factory ExpenseService() {
    if (!_isInitialized) {
      throw Exception('IncomeService not initialized. Need to call first initialize<Repository>');
    } else {
      return _instance;
    }
  }

  static Future<ExpenseService> initialize({StorageInterface storage, String firstSampleCategory}) async {
    _storage = storage;
    _isInitialized = true;
    if ((await _storage.readExpenseCategories()).isEmpty)
      await _storage.addExpenseCategory(
          firstSampleCategory
      );

    return ExpenseService();
  }


  Stream get listOfExpensesStream => _storage.listOfExpensesStream;

  Stream get listOfExpensesCategoriesStream => _storage.listOfExpensesCategoriesStream;

//List of expense notes
  Future<ListOfExpenses> readExpenseNotes() async {
    return await _storage.readExpenseNotes();
  }

  addExpenseNote(Note note, {int index}) async {
    await addExpenseCategory(note.category);
    await _storage.addExpenseNote(note, index: index);
  }

  editExpenseNote(Note oldNote, Note newNote) async {
    await _storage.editExpenseNote(oldNote, newNote);
  }

  deleteExpenseNote(Note note) async {
    await _storage.deleteExpenseNote(note);
  }


  //List of expense categories
  Future<List<String>>readExpenseCategories() async {
    return await _storage.readExpenseCategories();
  }

  addExpenseCategory(String category, {int index}) async {
    await _storage.addExpenseCategory(category, index: index);
  }

  editExpenseCategory(String oldCategory, String newCategory) async {
    await _storage.editExpenseCategory(oldCategory, newCategory);
  }

  deleteExpenseCategory(String category) async {
    await _storage.deleteExpenseCategory(category);
  }

  Future<double> getTotalAmount() async {
    List<Note> list = (await readExpenseNotes()).list;
    double sum = 0;
    for(int i = 0; i < list.length; i++){
      sum += list[i].sum;
    }
    return sum;
  }

  Future<double> getTotalAmountFromFilteredList({BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day}) async {
    List<Note> list = await getFilteredList(context: context, selMode: selMode, currentDate: currentDate, currentCategory: currentCategory, day: day);
    double sum = 0;
    for(int i = 0; i < list.length; i++){
      sum += list[i].sum;
    }
    return sum;
  }



  Future<List<Note>> getFilteredList({BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day}) async {
    List<Note> list = (await readExpenseNotes()).list;
    List <Note> filteredIncomesList = [];
    String langCode =  AppLocalizations.of(context).locale.toString();

    if (day != null) {
      for (Note note in list)
        if (_isInFilter(langCode: langCode, selMode: selMode, noteDate: note.date, currentDate: currentDate) && note.date.weekday == day)
          filteredIncomesList.add(note);
    } else if (currentCategory != null) {
      for (Note note in list)
        if (_isInFilter(langCode: langCode, selMode: selMode, noteDate: note.date, currentDate: currentDate) && note.category == currentCategory)
          filteredIncomesList.add(note);
    } else {
      for (Note note in list)
        if (_isInFilter(langCode: langCode, selMode: selMode, noteDate: note.date, currentDate: currentDate))
          filteredIncomesList.add(note);
    }

    return filteredIncomesList;
  }

  bool _isInFilter({String langCode, String selMode, DateTime noteDate, DateTime currentDate}) {
    if (noteDate == null) return false;

    switch (selMode) {
      case 'Day':
        return noteDate.year == currentDate.year &&
            noteDate.month == currentDate.month &&
            noteDate.day == currentDate.day;
        break;
      case 'Week':
        int weekDay = langCode == 'ru' || langCode == 'uk'
            ? currentDate.weekday
            : currentDate.weekday + 1;
        DateTime nextWeekFirstDay =
        currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            noteDate.isBefore(nextWeekFirstDay);
        break;
      case 'Week(D)':
        int weekDay = langCode == 'ru' || langCode == 'uk'
            ? currentDate.weekday
            : currentDate.weekday + 1;
        DateTime nextWeekFirstDay =
        currentDate.subtract(Duration(days: weekDay)).add(Duration(days: 8));
        return noteDate.isAfter(nextWeekFirstDay.subtract(Duration(days: 8))) &&
            noteDate.isBefore(nextWeekFirstDay);
        break;
      case 'Month':
        return noteDate.year == currentDate.year && noteDate.month == currentDate.month;
        break;
      case 'Year':
        return noteDate.year == currentDate.year;
        break;
      default: {
        return false;
      }
      break;
    }
  }
}