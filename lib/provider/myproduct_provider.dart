import 'package:flutter/material.dart';
import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/myproductpage.dart';
import 'package:front_redbox/service/productpage_service.dart';

class MyproductProvider with ChangeNotifier {
  List<MyProduct> _myproducts = [];
  List<MyProduct> _allMyProducts = [];
  bool _isAllProdLoading = false;
  bool _isloading = false;
  bool _hasMore = true;
  int? _categoryId;
  int _page = 0;
  String _query = "";
  String? _errorMessage;
  bool _isUpdate = false;
  bool _isDelete = false;

  List<MyProduct> get myproducts => _myproducts;
  List<MyProduct> get allMyProducts => _allMyProducts;
  bool get isAllProdLoading => _isAllProdLoading;
  bool get isloading => _isloading;
  bool get hasMore => _hasMore;
  int get page => _page;
  String get query => _query;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyProducts({bool refresh = false, int? categoryId}) async {
    if (_isloading) return;

    if (!_hasMore && !refresh) return;

    if (refresh || categoryId != null) _categoryId = categoryId;

    if (refresh) {
      _page = 0;
      _hasMore = true;
      _myproducts.clear();
    }

    _isloading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final result = await ProductpageService().fetchMyProduct(
        query: _query,
        categoryId: _categoryId,
        size: 20,
        page: _page,
        token: token,
      );

      final newItems = result.content;
      _myproducts.addAll(newItems);

      _hasMore = !result.last;

      if (newItems.isNotEmpty) {
        _page++;
      }
    } catch (e) {
      print('object $e');
    }

    _isloading = false;
    notifyListeners();
  }

  Future<void> clear() async {
    myproducts.clear();
    _page = 0;
    _hasMore = true;
    notifyListeners();
  }

  Future<void> search(String value) async {
    _query = value;
    await fetchMyProducts(refresh: true);
  }

  Future<bool> updateProduct(int id, Map<String, dynamic> body) async {
    _isUpdate = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final updated = await ProductpageService().updateMyProduct(
        id: id,
        body: body,
        token: token,
      );

      final index = _myproducts.indexWhere((mypro) => mypro.id == id);
      if (index != -1) _myproducts[index] = updated;

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isUpdate = false;
      notifyListeners();
    }
  }

  Future<bool> deletedMyProduct(int id) async {
    _isDelete = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      print(token);
      if (token == null || token.isEmpty) {
        throw Exception("Token missing");
      }
      await ProductpageService().deletedMyProduct(id: id, token: token);

      _myproducts.removeWhere((mypro) => mypro.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isDelete = false;
      notifyListeners();
    }
  }

  Future<void> gatAllMyPro() async {
    if (_isAllProdLoading) return;
    _isAllProdLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final results = await ProductpageService().getAllMyProduct(token: token);
      _allMyProducts = results;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isAllProdLoading = false;
      notifyListeners();
    }
  }
}
