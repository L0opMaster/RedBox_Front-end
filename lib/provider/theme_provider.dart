import 'package:flutter/material.dart';
import 'package:front_redbox/core/theme_storage.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isLight => _themeMode == ThemeMode.light;

  ThemeProvider() {
    loadTheme();
  }
  //loading theme from ThemeStorage
  Future<void> loadTheme() async {
    final isLight = await ThemeStorage.getTheme();

    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }

  // Toggle theme and Save theme
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await ThemeStorage.saveTheme(isLight);
    notifyListeners();
  }
  // void toggleTheme() {
  //   _themeMode = _themeMode == ThemeMode.light
  //       ? ThemeMode.dark
  //       : ThemeMode.light;

  //   notifyListeners();
  // }

  // void setLightMode() {
  //   _themeMode = ThemeMode.light;
  //   notifyListeners();
  // }

  // void setDarkMode() {
  //   _themeMode = ThemeMode.dark;
  //   notifyListeners();
  // }
  // Set dark mode
  // Future<void> setDarkMode() async {
  //   _themeMode = ThemeMode.dark;

  //   await ThemeStorage.saveTheme(true);

  //   notifyListeners();
  // }
}
