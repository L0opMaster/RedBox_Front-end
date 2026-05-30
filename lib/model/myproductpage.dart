class MyProductPage {
  final List<MyProduct> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final bool last;
  MyProductPage({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.last,
  });
  factory MyProductPage.fromJson(Map<String, dynamic> json) {
    return MyProductPage(
      content: (json['content'] as List)
          .map((item) => MyProduct.fromJson(item))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      number: json['number'] ?? 0,
      last: json['last'] ?? true,
    );
  }
}

class MyProduct {
  final int id;
  final String productCode;
  final String khmerName;
  final String englishName;
  final String description;
  final bool isActive;
  final String imageUrl;
  final double price;
  final int category;
  final int user;
  final String? createdAt;
  final String? updatedAt;

  MyProduct({
    required this.id,
    required this.productCode,
    required this.khmerName,
    required this.englishName,
    required this.description,
    required this.isActive,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });
  factory MyProduct.fromJson(Map<String, dynamic> map) {
    return MyProduct(
      id: map['id'] ?? 0,
      productCode: map['productCode'] ?? map['product_code'] ?? '',
      khmerName: map['khmerName'] ?? map['khmer_name'] ?? '',
      englishName: map['englishName'] ?? map['english_name'] ?? '',
      description: map['description'] ?? '',

      // Checks every permutation of the active flag serialization
      isActive: map['isActive'] ?? map['is_active'] ?? map['active'] ?? false,

      // Safely reads both variants of your image URL payload field
      imageUrl: map['imageUrl'] ?? map['image_url'] ?? '',

      // Defends against BigDecimals parsed as strings, ints, or doubles
      price: map['price'] != null
          ? (double.tryParse(map['price'].toString()) ?? 0.0)
          : 0.0,

      category: map['category'] ?? 0,
      user: map['user'] ?? 0,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
