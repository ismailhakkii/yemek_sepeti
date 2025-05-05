import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  MaterialColor _mainColor = Colors.red;

  ThemeMode get themeMode => _themeMode;
  MaterialColor get mainColor => _mainColor;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setMainColor(MaterialColor color) {
    _mainColor = color;
    notifyListeners();
  }
} 