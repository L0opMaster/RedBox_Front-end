import 'dart:convert';
import 'dart:math';

import 'package:front_redbox/model/user.dart';
import 'package:front_redbox/service/api_client.dart';
import 'package:front_redbox/util/base_url.dart';

class UserService {
  UserService._internal();

  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl.baseUrl);

  Future<List<UserModel>> fetchUser({String? token}) async {
    final response = await apiClient.get('/api/users', token: token);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((user) => UserModel.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch $e');
    }
  }
}
