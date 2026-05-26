class Category {
  final int id;
  final String khmerName;
  final String englishName;
  final bool active;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.khmerName,
    required this.englishName,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      khmerName: json["khmerName"],
      englishName: json["englishName"],
      active: json["active"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
    );
  }
}
