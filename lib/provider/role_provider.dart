import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/role_model.dart';
import 'package:front_redbox/service/role_service.dart';

class RoleProvider with ChangeNotifier {
  List<RoleModel> _roles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RoleModel> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoles() async {
    if (_isLoading) {
      return;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final role = await RoleService().fetchRole(token: token);
      _roles = role;
    } catch (e) {
      _errorMessage = e.toString();
      _roles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
