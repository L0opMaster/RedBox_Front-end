import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const tokenKey = "auth_token";

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      return false;
    }

    bool isExpired = JwtDecoder.isExpired(token);

    return !isExpired;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(tokenKey);

    await prefs.remove('user');
  }

  static Future<void> saveUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('user');
  }
}
