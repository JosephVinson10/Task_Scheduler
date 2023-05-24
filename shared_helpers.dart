import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class helper {
  static Future<String> getValues() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('date') ?? 'Not Found';
  }

  static Future<void> setValues(String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('date', value);
  }
}
