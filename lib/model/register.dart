class Register {
  final String firstName;
  final String lastName;
  final String dateOfBirth;
  final String username;
  final String email;
  final String password;

  Register({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.dateOfBirth,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "password": password,
      "dateOfBirth": dateOfBirth
    };
  }
}
