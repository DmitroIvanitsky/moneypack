import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static Future<bool> saveList(list, key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(key, list);
  }

  static Future<List<String>> getList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }
}