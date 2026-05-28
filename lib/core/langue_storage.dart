import 'package:shared_preferences/shared_preferences.dart';

class LangueStorage {
  static const String _LangueKey = 'isEng';

  // Save theme
  static Future<void> saveLangue(bool isEng) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_LangueKey, isEng);
  }

  // Get theme

  static Future<bool> getLangue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_LangueKey) ?? true;
  }
}