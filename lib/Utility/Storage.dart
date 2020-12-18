import 'dart:convert';

import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tutorial/Objects/ExpenseNote.dart';
import 'package:flutter_tutorial/Objects/ListOfExpenses.dart';
import 'package:flutter_tutorial/Utility/Storage.dart';
import 'package:flutter_tutorial/pages/ListOfExpensesCategories.dart';

class Storage{

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
    savExpenseCategory(category);
    return true;
  }
  
  static savExpenseCategory(String category) async {
    List <String> categories = await getExpenseCategories();
    if (categories == null) categories = [];
    if (categories.contains(category)) return;

    if (categories.length > 4) categories.removeAt(0);
    categories.add(category);
    await saveList(categories, 'categories');
  }
  
  static getExpenseCategories() async {
    List l = await getList('categories');
    return l;
  }
}