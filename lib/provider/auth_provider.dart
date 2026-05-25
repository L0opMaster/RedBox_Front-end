import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;
  Future<void> logOut() async {
    await StorageService.logout();
    _token = null;
    notifyListeners();
  }
}
