import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future setupPreferences(BuildContext context) async {
  return await SharedPreferences.getInstance().then((prefs) async {
    var user = prefs.getString("auth_user");
    var theme = prefs.getString("app_theme") ?? "System";
  });
}
