import 'package:donotnote/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static void writeData(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(Strings.prefString);
    items ??= [];
    items.add(val);
    await prefs.setStringList(Strings.prefString, items);
  }

  static Future<List<String>?> readAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(Strings.prefString);
    return items;
  }

  static Future<bool> hasData(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(Strings.prefString);
    if (items == null) {
      return false;
    }
    return items.contains(val);
  }

  static void editData(String val) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(Strings.prefString);
    if (items == null) {
      return;
    }
    if (items.contains(val)) {
      items.remove(val);
      await prefs.setStringList(Strings.prefString, items);
    }
  }

  static void removeAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Strings.prefString);
  }
}
