class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final bool active;
  final String username;
  final List<dynamic> roles;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.active,
    required this.roles,
  });

  // From Map Json to Dart Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      username: json["username"],
      email: json["email"],
      active: json["active"],
      roles: json["roles"],
    );
  }

  // From dart Object to Json Map

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "active": active,
      "roles": roles,
    };
  }
}
