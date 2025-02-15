import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future setupPreferences(BuildContext context) async {
  return await SharedPreferences.getInstance().then((prefs) async {
    var user = prefs.getString("auth_user");
    var theme = prefs.getString("app_theme") ?? "System";
  });
}

class StorageService {
  // this support all the data types(String, int, float, double,List<String

  static Future<void> storeData(String key, dynamic value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  static Future<dynamic> retrieveData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(key)) {
      return null;
    }

    if (prefs.getString(key) != null) {
      return prefs.getString(key);
    } else if (prefs.getInt(key) != null) {
      return prefs.getInt(key);
    } else if (prefs.getBool(key) != null) {
      return prefs.getBool(key);
    } else if (prefs.getDouble(key) != null) {
      return prefs.getDouble(key);
    } else if (prefs.getStringList(key) != null) {
      return prefs.getStringList(key);
    }

    return null;
  }
}
