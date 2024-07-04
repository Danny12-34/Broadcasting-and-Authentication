import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode { light, dark }

class ThemeManager extends ChangeNotifier {
  late SharedPreferences _prefs;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeManager() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _themeMode = _prefs.getBool('isDarkMode') == true ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  ThemeData get themeData {
    switch (_themeMode) {
      case ThemeMode.light:
        return ThemeData.light();
      case ThemeMode.dark:
        return ThemeData.dark();
    }
  }
}