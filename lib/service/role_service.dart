import 'dart:convert';

import 'package:front_redbox/model/role_model.dart';
import 'package:front_redbox/service/api_client.dart';
import 'package:front_redbox/util/base_url.dart';

class RoleService {
  RoleService._internal();
  static final RoleService _instance = RoleService._internal();
  factory RoleService() => _instance;

  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl.baseUrl);

  Future<List<RoleModel>> fetchRole({String? token}) async {
    final response = await apiClient.get('/api/roles', token: token);

    if (response.statusCode == 200) {
      print('Statuscode ${response.statusCode}');

      final List data = jsonDecode(response.body) as List;
      print('Body: ${response.body}');

      return data.map((roles) => RoleModel.fromJson(roles)).toList();
    } else {
      throw Exception('Failed: ${response.statusCode}');
    }
  }
}
