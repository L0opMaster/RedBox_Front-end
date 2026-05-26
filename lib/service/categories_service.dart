import 'dart:convert';

import 'package:front_redbox/model/category.dart';
import 'package:front_redbox/service/api_client.dart';
import 'package:front_redbox/util/base_url.dart';

class CategoriesService {
  CategoriesService._internal();
  static final CategoriesService _instance = CategoriesService._internal();
  factory CategoriesService() => _instance;

  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl.baseUrl);

  Future<List<Category>> fetchCategories({String? token}) async {
    final response = await apiClient.get('/api/categories', token: token);
    if (response.statusCode == 200) {
      print('StatusCode: ${response.statusCode}');
      final List categories = jsonDecode(response.body) as List;
      print('Body: ${response.body}');
      return categories.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }
}
