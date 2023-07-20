import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static Future<void> create(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else if (value is List<String>) {
      prefs.setStringList(key, value);
    } else {
      debugPrint('Invalid Type');
    }
  }

  static Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.get(key);
  }

  static Future<bool> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }
}
