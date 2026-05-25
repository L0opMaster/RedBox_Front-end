import 'package:front_redbox/model/user.dart';

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  // From Json type to dart Object
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json["accessToken"],
      tokenType: json["tokenType"],
      user: UserModel.fromJson(json["user"]),
    );
  }
}
