// ignore_for_file: public_member_api_docs, sort_constructors_first
class RoleModel {
  final int id;
  final String name;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  RoleModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json["id"],
      name: json["name"],
      isActive: json["isActive"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
