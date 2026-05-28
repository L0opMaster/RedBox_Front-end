import 'package:flutter/material.dart';
import 'package:front_redbox/core/langue_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ChangeLangueProvider with ChangeNotifier {
  bool _isEnglish = true;

  bool get isEnglish => _isEnglish;

  Future<void> loadLangue() async {
    try {
      final isEng = await LangueStorage.getLangue();
      _isEnglish = isEng;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading language: $e");
    }
  }

  Future<void> togglelanguage() async {
    _isEnglish = !_isEnglish;
    notifyListeners();

    try {
      await LangueStorage.saveLangue(_isEnglish);
    } catch (e) {
      debugPrint("Error saving language: $e");
    }
  }
}
