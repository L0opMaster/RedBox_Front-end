import 'dart:convert';

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
}
