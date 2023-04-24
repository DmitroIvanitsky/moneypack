import 'package:flutter/cupertino.dart';

import '../interfaces/income_service_interface.dart';
import '../Objects/list_of_incomes.dart';
import '../Objects/record.dart';
import '../Utility/app_localizations.dart';
import '../interfaces/storage_interface.dart';

class IncomeService implements IncomeServiceInterface{
  static StorageInterface _storage;
  static bool _isInitialized = false;

  static final IncomeService _instance = IncomeService._();

  IncomeService._();


  factory IncomeService() {
    if (!_isInitialized) {
      throw Exception(
          'IncomeService not initialized. Need to call first initialize<Repository>');
    } else {
      return _instance;
    }
  }

  static Future<IncomeService> initialize(
      {StorageInterface storage, String firstSampleCategory}) async {
    _storage = storage;
    _isInitialized = true;
    if ((await _storage.readIncomeCategories()).isEmpty)
      await _storage.addIncomeCategory(
          firstSampleCategory
      );

    return IncomeService();
  }

  Future<ListOfIncomes> readIncomeNotes() async {
    return await _storage.readIncomeNotes();
  }

  addIncomeNote(Note note, {int index}) async {
    await addIncomeCategory(note.category);
    await _storage.addIncomeNote(note, index: index);
  }

  editIncomeNote(Note oldNote, Note newNote) async {
    await _storage.editIncomeNote(oldNote, newNote);
  }

  deleteIncomeNote(Note incomeNote) async {
    await _storage.deleteIncomeNote(incomeNote);
  }


  //List of income categories
  Future<List<String>> readIncomeCategories() async {
    return await _storage.readIncomeCategories();
  }

  addIncomeCategory(String category, {int index}) async {
    await _storage.addIncomeCategory(category, index: index);
  }

  editIncomeCategory(String oldCategory, String newCategory) async {
    await _storage.editIncomeCategory(oldCategory, newCategory);
  }

  deleteIncomeCategory(String category) async {
    await _storage.deleteIncomeCategory(category);
  }


  Future<double> getTotalAmount() async {
    List<Note> list = (await readIncomeNotes()).list;
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum += list[i].sum;
    }
    return sum;
  }

  Future<double> getTotalAmountFromFilteredList(
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day}) async {
    List<Note> list = await getFilteredList(context: context, selMode: selMode,
        currentDate: currentDate,
        currentCategory: currentCategory,
        day: day);
    double sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum += list[i].sum;
    }
    return sum;
  }


  Future<List<Note>> getFilteredList(
      {BuildContext context, String selMode, DateTime currentDate, String currentCategory, int day}) async {
    String langCode =  AppLocalizations.of(context).locale.toString();
    List<Note> list = (await readIncomeNotes()).list;
    List <Note> filteredIncomesList = [];

    if (day != null) {
      for (Note note in list)
        if (_isInFilter(langCode: langCode, selMode: selMode, noteDate: note.date, currentDate: currentDate) &&
            note.date.weekday == day)
          filteredIncomesList.add(note);
    } else if (currentCategory != null) {
      for (Note note in list)
        if (_isInFilter(
            langCode: langCode, selMode: selMode, noteDate: note.date, currentDate: currentDate) &&
            note.category == currentCategory)
          filteredIncomesList.add(note);
    } else {
      for (Note note in list)
        if (_isInFilter(
            langCode: langCode,
            selMode: selMode, noteDate: note.date, currentDate: currentDate))
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
        return noteDate.year == currentDate.year &&
            noteDate.month == currentDate.month;
        break;
      case 'Year':
        return noteDate.year == currentDate.year;
        break;
      default:
        {
          return false;
        }
        break;
    }
  }

  @override
  Stream get listOfIncomeCategoriesStream => _storage.listOfIncomeCategoriesStream;

  @override
  Stream get listOfIncomesStream => _storage.listOfIncomesStream;
}