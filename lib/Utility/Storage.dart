import 'dart:convert';
import 'dart:io';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import '../Objects/AllData.dart';
import '../Objects/IncomeNote.dart';
import '../Objects/ListOfExpenses.dart';
import '../Objects/ListOfIncomes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Objects/ExpenseNote.dart';

class Storage{
  static String langCode;

  static Future<bool> saveList(list, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, list);
  }

  static Future<List<String>> getList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List l = prefs.getStringList(key);
    return l;
  }

  static Future<bool> saveString(list, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, list);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> saveExpenseNote(ExpenseNote expenseNote, String category) async {
    if (expenseNote != null) {//Null if EDIT object, saved earlier
      ListOfExpenses.list.add(expenseNote);
    }
    await Storage.saveString(jsonEncode(ListOfExpenses().toJson()), 'ExpenseNote');
    saveLastExpenseCategory(category);
    return true;
  }

  static Future<bool> saveIncomeNote(IncomeNote incomeNote, String category) async {
    if (incomeNote != null) {
      ListOfIncomes.list.add(incomeNote);
    }
    await Storage.saveString(jsonEncode(ListOfIncomes().toJson()), 'IncomeNote');
    saveLastIncomeCategory(category);
    return true;
  }
  
  static saveLastExpenseCategory(String category) async {
    List <String> expCategories = await getExpenseCategories();
    if (expCategories == null) expCategories = [];
    if (expCategories.contains(category)) return;

    if (expCategories.length > 2) expCategories.removeAt(0);
    expCategories.add(category);
    await saveList(expCategories, 'expCategories');
  }

  static saveLastIncomeCategory(String category) async {
    List <String> incCategories = await getIncomeCategories();
    if (incCategories == null) incCategories = [];
    if (incCategories.contains(category)) return;

    if (incCategories.length > 2) incCategories.removeAt(0);
    incCategories.add(category);
    await saveList(incCategories, 'incCategories');
  }
  
  static getExpenseCategories() async {
    List eL = await getList('expCategories');
    return eL;
  }

  static getIncomeCategories() async {
    List iL = await getList('incCategories');
    return iL;
  }

  static saveExpenseCategory(String category) async{
    List <String> expCategories = await getList('Expenses');
    if (!expCategories.contains(category)) {
      expCategories.add(category);
      await saveList(expCategories, 'Expenses');
    }
  }

  static saveIncomeCategory(String category) async{
    List <String> incCategories = await getList('Incomes');
    if (!incCategories.contains(category)) {
      incCategories.add(category);
      await saveList(incCategories, 'Incomes');
    }
  }

  static void saveBackup() async {
    List<String> expenseCatList = await Storage.getList('Expenses');
    List<String> incomeCatList = await Storage.getList('Incomes');
    ListOfExpenses listOfExpenses = ListOfExpenses.fromJson(jsonDecode(await Storage.getString('ExpenseNote')));
    ListOfIncomes listOfIncomes = ListOfIncomes.fromJson(jsonDecode(await Storage.getString('IncomeNote')));

    AllData backupObject = AllData(
      expenseCatList: expenseCatList == null ? null : expenseCatList,
      incomeCatList: incomeCatList == null ? null : incomeCatList,
      listOfExpenses: listOfExpenses == null ? null : listOfExpenses,
      listOfIncomes: listOfIncomes == null ? null : listOfIncomes,
    );

    String appDir = (await getApplicationDocumentsDirectory()).path;//Get app directory path
    File file = File(appDir + '/MPBackup.json');
    await file.writeAsString(jsonEncode(backupObject.toJson()));
    await Share.shareFiles([file.path]);
  }

  static void loadBackup(File file) async {
    //String appDir = (await getApplicationDocumentsDirectory()).path;//Get app directory path
    //File file = File(appDir + '/MPKbackup.json');
    String res = await file.readAsString();
    AllData backupObject = AllData.fromJson(jsonDecode(res));

    //list of incomes categories
    await Storage.saveList(backupObject.incomeCatList, "Incomes");

    //list of expenses categories
    await Storage.saveList(backupObject.expenseCatList, 'Expenses');

    //list of expenseNotes
    await Storage.saveString(jsonEncode(ListOfExpenses().toJson()), 'ExpenseNote');

    //list of incomeNotes
    await Storage.saveString(jsonEncode(ListOfIncomes().toJson()), 'IncomeNote');
  }

}