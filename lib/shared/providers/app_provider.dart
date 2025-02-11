import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  String _theme = "system";
  String get theme => _theme;

  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }
}
