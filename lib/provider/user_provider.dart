import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/user.dart';
import 'package:front_redbox/service/user_service.dart';

class UserProvider with ChangeNotifier {
  List<UserModel> _listUser = [];
  bool _isloading = false;
  String? _errorMessage;

  List<UserModel> get listUser => _listUser;
  bool get isloading => _isloading;
  String? get erroeMessage => _errorMessage;

  Future<void> fetchUser() async {
    if (_isloading) return;
    _isloading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await UserService().fetchUser(token: token);
      _listUser = result;
    } catch (e) {
      _errorMessage = e.toString();
      _listUser = [];
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
