import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const String _themeKey = 'isLightMode';

  // Save theme
  static Future<void> saveTheme(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_themeKey, isLight);
  }

  // Get theme

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_themeKey) ?? true;
  }
}
