import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/category.dart';
import 'package:front_redbox/service/categories_service.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedCategoryId = 0;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get selectedCategoryId => _selectedCategoryId;

  void setSelectedCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> fetchCategory() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await CategoriesService().fetchCategories(token: token);

      _categories = [
        Category(
          id: 0,
          khmerName: 'ទាំងអស់',
          englishName: 'All',
          active: true,
          createdAt: '2006-06-09',
          updatedAt: '2006-06-09',
        ),
        ...result,
      ];
    } catch (e) {
      _errorMessage = e.toString();
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
