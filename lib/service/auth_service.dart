import 'dart:convert';

import 'package:front_redbox/core/storage_service.dart';
import 'package:front_redbox/model/auth_response.dart';
import 'package:front_redbox/service/api_client.dart';
import 'package:front_redbox/util/base_url.dart';

class AuthService {
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final ApiClient apiClient = ApiClient(baseUrl: BaseUrl.baseUrl);

  Future<AuthResponse?> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await apiClient.post("/api/auth/login", {
      "usernameOrEmail": usernameOrEmail,
      "password": password,
    });
    print('status: ${response.statusCode}');

    if (response.statusCode == 200) {
      print('bofy${response.body}');
      final data = jsonDecode(response.body);

      final authresponse = AuthResponse.fromJson(data);
      await StorageService.saveUser(jsonEncode(authresponse.user.toJson()));
      final token = data["accessToken"];
      await StorageService.saveToken(token);

      return authresponse;
    }

    return null;
  }

  Future<AuthResponse?> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String dateOfBirth,
    required String password,
  }) async {
    final response = await apiClient.post("/api/auth/register", {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "password": password,
      "dateOfBirth": dateOfBirth,
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      final authresponse = AuthResponse.fromJson(data);
      await StorageService.saveUser(jsonEncode(authresponse.user.toJson()));
      final token = data["accessToken"];
      await StorageService.saveToken(token);
      return authresponse;
    }

    return null;
  }
}
