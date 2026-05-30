import 'dart:convert';

import 'package:front_redbox/model/myproductpage.dart';
import 'package:front_redbox/model/product_page.dart';
import 'package:front_redbox/service/api_client.dart';
import 'package:front_redbox/util/base_url.dart';

class ProductpageService {
  ProductpageService._internal();
  static final ProductpageService _instance = ProductpageService._internal();
  factory ProductpageService() => _instance;

  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl.baseUrl);

  Future<ProductPage> fetchProductPage({
    String query = '',
    int? categoryId,
    bool? active,
    int page = 0,
    int size = 6,
    String? token,
  }) async {
    String url = '/api/products/search?q=$query&page=$page&size=$size';
    if (categoryId != null) {
      url += '&categoryId=$categoryId';
    }

    final response = await apiClient.get(url, token: token);

    if (response.statusCode == 200) {
      print('StatusCode ${response.statusCode}');
      final data = jsonDecode(response.body);
      print(response.body);
      return ProductPage.fromJson(data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  Future<MyProductPage> fetchMyProduct({
    String query = '',
    int? categoryId,
    bool? active,
    int page = 0,
    int size = 20,
    String? token,
  }) async {
    String url = '/api/products/my-product?q=$query&page=$page&size=$size';
    if (categoryId != null) {
      url += '&categoryId=$categoryId';
    }

    final response = await apiClient.get(url, token: token);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return MyProductPage.fromJson(data);
    } else {
      throw Exception('Failed to fetch product');
    }
  }

  Future<Product> createProduct({
    String? token,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.post('/api/products', body, token: token);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      'Failed to create product (${response.statusCode}): ${response.body}',
    );
  }

  Future<MyProduct> updateMyProduct({
    String? token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final reponse = await apiClient.put(
      '/api/products/$id',
      body,
      token: token,
    );
    if (reponse.statusCode == 200) {
      return MyProduct.fromJson(jsonDecode(reponse.body));
    }

    throw Exception(
      'Failed to update product${reponse.statusCode}): ${reponse.body}',
    );
  }

  Future<void> deletedMyProduct({String? token, required int id}) async {
    final response = await apiClient.delete('/api/products/$id', token: token);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete product (${response.statusCode}): ${response.body}',
      );
    }
  }
}
