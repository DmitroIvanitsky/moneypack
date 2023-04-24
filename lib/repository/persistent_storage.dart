import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Objects/list_of_expenses.dart';
import '../Objects/list_of_incomes.dart';
import '../Objects/record.dart';
import '../interfaces/storage_interface.dart';


const String KEY_INCOME_CATEGORIES = 'KEY_INCOME_CATEGORIES';
const String KEY_EXPENSE_CATEGORIES = 'KEY_EXPENSE_CATEGORIES';
const String KEY_INCOME_NOTES = 'KEY_INCOME_NOTES';
const String KEY_EXPENSE_NOTES = 'KEY_EXPENSE_NOTES';
const String KEY_NOTES = 'KEY_NOTES';

class SharedPreferencesStorage implements StorageInterface {
 //static String langCode;
  static bool _isInitialized = false;

  //caching data
  static ListOfExpenses _cachedListOfExpenses;
  static List<String> _cachedIncomeCategories;
  static ListOfIncomes _cachedListOfIncomes;
  static List<String> _cachedExpenseCategories;
  static List<String> notes;

  StreamController<ListOfExpenses> _listOfExpensesStream = new StreamController.broadcast();
  Stream get listOfExpensesStream => _listOfExpensesStream.stream;

  StreamController<List<String>> _listOfExpensesCategoriesStream = new StreamController.broadcast();
  Stream get listOfExpensesCategoriesStream => _listOfExpensesCategoriesStream.stream;

  StreamController<ListOfIncomes> _listOfIncomesStream = new StreamController.broadcast();
  Stream get listOfIncomesStream => _listOfIncomesStream.stream;

  StreamController<List<String>>  _listOfIncomeCategoriesStream = new StreamController.broadcast();
  Stream get listOfIncomeCategoriesStream => _listOfIncomeCategoriesStream.stream;





  static final SharedPreferencesStorage _instance = SharedPreferencesStorage._();

  SharedPreferencesStorage._();


  factory SharedPreferencesStorage() {
    if (!_isInitialized) {
      throw Exception('Storage not initialized. Need to call first Storage.initialize()');
    } else {
      return _instance;
    }
  }

  static Future<SharedPreferencesStorage> initialize() async {
    _isInitialized = true;
    SharedPreferencesStorage s = SharedPreferencesStorage();

    _cachedListOfExpenses = await s.readExpenseNotes();
    if (_cachedListOfExpenses == null) {
      _cachedListOfExpenses = ListOfExpenses();
      s._saveExpenseNotesList();
    }
    _cachedIncomeCategories = await s.readIncomeCategories();
    if (_cachedIncomeCategories == null) {
      _cachedIncomeCategories = [];
      s._saveIncomeCategoriesList();
    }
    _cachedListOfIncomes = await s.readIncomeNotes();
    if (_cachedListOfIncomes == null) {
      _cachedListOfIncomes = ListOfIncomes();
      s._saveIncomeNotesList();
    }
    _cachedExpenseCategories = await s.readExpenseCategories();
    if (_cachedExpenseCategories == null) {
      _cachedExpenseCategories = [];
      s._saveExpenseCategoriesList();
    }
    notes = await s.readNotes();
    if (notes == null) {
      notes = [];
      s._saveNotesList();
    }

    return SharedPreferencesStorage();
  }



  Future<List<String>> _getList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List l = prefs.getStringList(key);
    return l;
  }

  Future<bool> _saveList(list, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, list);
  }

  Future<String> _getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> _saveString(String string, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, string);
  }





//List of expense notes
  Future<ListOfExpenses> readExpenseNotes() async {
    if (_cachedListOfExpenses != null)
      return _cachedListOfExpenses;

    String raw = await _getString(KEY_EXPENSE_NOTES);
    if (raw != null) _cachedListOfExpenses = ListOfExpenses.fromJson(jsonDecode(raw));

    return _cachedListOfExpenses;
  }

  addExpenseNote(Note note, {int index}) async {
    if (note != null) {
      if (index != null && index < _cachedListOfExpenses.list.length)
        _cachedListOfExpenses.list.insert(index, note);
      else
        _cachedListOfExpenses.list.add(note);
    }
    await _saveExpenseNotesList();
    return true;
  }

  editExpenseNote(Note oldNote, Note newNote) async {
    if (_cachedListOfExpenses == null) return;

    int index = _cachedListOfExpenses.list.indexOf(oldNote);
    if (index == -1) return;

    _cachedListOfExpenses.list[index] = newNote;

    await _saveExpenseNotesList();
  }

  deleteExpenseNote(Note note) async {
    if (_cachedListOfExpenses == null) return;

    _cachedListOfExpenses.list.remove(note);

    await _saveExpenseNotesList();
  }

  _saveExpenseNotesList() async {
    _listOfExpensesStream.sink.add(_cachedListOfExpenses);
    await _saveString(jsonEncode(_cachedListOfExpenses.toJson()), KEY_EXPENSE_NOTES);
  }


  //List of income notes
  Future<ListOfIncomes> readIncomeNotesList() async {
    if (_cachedListOfIncomes != null)
      return _cachedListOfIncomes;

    String rawData = await _getString(KEY_INCOME_NOTES);
    if (rawData != null) _cachedListOfIncomes = ListOfIncomes.fromJson(jsonDecode(rawData));

    return _cachedListOfIncomes;
  }

  Future<ListOfIncomes> readIncomeNotes() async {
    if (_cachedListOfIncomes != null)
      return _cachedListOfIncomes;

    String rawData = await _getString(KEY_INCOME_NOTES);
    if (rawData != null) _cachedListOfIncomes = ListOfIncomes.fromJson(jsonDecode(rawData));

    return _cachedListOfIncomes;
  }

  addIncomeNote(Note note, {int index}) async {
    if (note != null) {
      if (index != null && index < _cachedListOfIncomes.list.length)
        _cachedListOfIncomes.list.insert(index, note);
      else
        _cachedListOfIncomes.list.add(note);
    }
    await _saveIncomeNotesList();
    addIncomeCategory(note.category);
    return true;
  }

  editIncomeNote(Note oldNote, Note newNote) async {
    int index = _cachedListOfIncomes.list.indexOf(oldNote);
    if (index == -1) return;

    _cachedListOfIncomes.list[index] = newNote;

    await _saveIncomeNotesList();
  }

  deleteIncomeNote(Note incomeNote) async {
    _cachedListOfIncomes.list.remove(incomeNote);

    await _saveIncomeNotesList();
  }


  _saveIncomeNotesList() async {
    _listOfIncomesStream.sink.add(_cachedListOfIncomes);
    await _saveString(jsonEncode(_cachedListOfIncomes.toJson()), KEY_INCOME_NOTES);
  }




  //List of income categories
  Future<List<String>> readIncomeCategories() async {
    if (_cachedIncomeCategories != null)
      return _cachedIncomeCategories;

    _cachedIncomeCategories = await _getList(KEY_INCOME_CATEGORIES);

    return _cachedIncomeCategories;
  }

  addIncomeCategory(String category, {int index}) async {
    if (_cachedIncomeCategories.contains(category)) return;

    if (index == null)
      _cachedIncomeCategories.add(category);
    else
      _cachedIncomeCategories.insert(index, category);


    await _saveIncomeCategoriesList();
  }

  editIncomeCategory(String oldCategory, String newCategory) async {
    if (_cachedIncomeCategories.contains(newCategory)) { //if present, place as first
      deleteIncomeCategory(newCategory);
      addIncomeCategory(newCategory);
    } else {
      _cachedIncomeCategories[_cachedIncomeCategories.indexOf(oldCategory)] = newCategory;
    }

    await _saveIncomeCategoriesList();
  }

  deleteIncomeCategory(String category) async {
    if (!_cachedIncomeCategories.contains(category)) return;

    _cachedIncomeCategories.remove(category);
    await _saveIncomeCategoriesList();
  }

  _saveIncomeCategoriesList() async {
    _listOfIncomeCategoriesStream.sink.add(_cachedIncomeCategories);
    await _saveList(_cachedIncomeCategories, KEY_INCOME_CATEGORIES);
  }



  //List of expense categories
  Future<List<String>> readExpenseCategories() async {
    if (_cachedExpenseCategories != null)
      return _cachedExpenseCategories;

    _cachedExpenseCategories = await _getList(KEY_EXPENSE_CATEGORIES);

    return _cachedExpenseCategories;
  }

  addExpenseCategory(String category, {int index}) async {
    if (_cachedExpenseCategories.contains(category)) return;

    if (index == null)
      _cachedExpenseCategories.add(category);
    else
      _cachedExpenseCategories.insert(index, category);

    await _saveExpenseCategoriesList();
  }

  editExpenseCategory(String oldCategory, String newCategory) async {
    if (_cachedExpenseCategories.contains(newCategory)) { //if present, place as first
      deleteExpenseCategory(newCategory);
      addExpenseCategory(newCategory);
    } else {
      _cachedExpenseCategories[_cachedExpenseCategories.indexOf(oldCategory)] = newCategory;
    }

    await _saveExpenseCategoriesList();
  }

  deleteExpenseCategory(String category) async {
    if (!_cachedExpenseCategories.contains(category)) return;

    _cachedExpenseCategories.remove(category);
    await _saveExpenseCategoriesList();
  }

  _saveExpenseCategoriesList() async {
    _listOfExpensesCategoriesStream.sink.add(_cachedExpenseCategories);
    await _saveList(_cachedExpenseCategories, KEY_EXPENSE_CATEGORIES);
  }



//Notes
  readNotes() async {
    if (notes != null)
      return notes;

    notes = await _getList(KEY_NOTES);

    return notes;
  }


  addNote(String category, {int index}) async {
    if (notes.contains(category)) return;

    notes.insert(
        index ?? notes.length, category
    );

    await _saveNotesList();
  }

  editNotes(String oldNote, String newNote) async {
    if (notes.contains(newNote)) { //if present, place as first
      deleteNote(newNote);
      addNote(newNote);
    } else {
      notes[notes.indexOf(oldNote)] = newNote;
    }

    await _saveNotesList();
  }

  deleteNote(String category) async {
    if (!notes.contains(category)) return;

    notes.remove(category);
    await _saveNotesList();
  }

  _saveNotesList() async {
    await _saveList(notes, KEY_NOTES);
  }


  void loadFromBackup({expenseCatList, listOfExpenses, incomeCatList, listOfIncomes}) async {
    _cachedExpenseCategories = expenseCatList;
    _cachedListOfExpenses = listOfExpenses;
    _cachedIncomeCategories = incomeCatList;
    _cachedListOfIncomes = listOfIncomes;

    await _saveExpenseCategoriesList();
    await _saveExpenseNotesList();
    await _saveIncomeCategoriesList();
    await _saveIncomeNotesList();
  }
}