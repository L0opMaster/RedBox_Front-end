import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/product_page.dart';
import 'package:front_redbox/service/productpage_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  bool _isLoading = false;
  int _page = 0;
  bool _hasMore = true;
  String _query = "";
  int? _categoryId;
  String? _errorMessage;
  bool _isCreate = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  int get page => _page;
  bool get hasMore => _hasMore;
  String get query => _query;
  String? get errorMessage => _errorMessage;
  bool get isCreate => _isCreate;

  Future<void> fetchProduct({bool refresh = false, int? categoryId}) async {
    if (_isLoading) return;

    // If we don't have more pages and we aren't refreshing, stop here
    if (!_hasMore && !refresh) return;

    // FIX 1: Explicitly overwrite categoryId on refresh/selection (handles null/0 properly)
    if (refresh || categoryId != null) {
      _categoryId = categoryId;
    }

    if (refresh) {
      _page = 0;
      _hasMore = true;
      _products.clear();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();

      final result = await ProductpageService().fetchProductPage(
        query: _query,
        categoryId: _categoryId,
        size: 6,
        page: _page,
        token: token,
      );

      final newItems = result.content;
      _products.addAll(newItems);

      //  INVERT True if it nOT the last page.
      _hasMore = !result.last;

      if (newItems.isNotEmpty) {
        _page++;
      }

      print("PAGE: $_page");
      print("HAS MORE: $_hasMore");
      print("PRODUCT COUNT: ${_products.length}");
    } catch (e) {
      print("ERROR: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProduct(Map<String, dynamic> body) async {
    _isCreate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final newProduct = await ProductpageService().createProduct(
        body: body,
        token: token,
      );
      _products = [newProduct, ..._products];

      _isCreate = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();

      _isCreate = false;
      notifyListeners();

      return false;
    }
  }

  Future<void> search(String value) async {
    _query = value;
    await fetchProduct(refresh: true);
  }
}
