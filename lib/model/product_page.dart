// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductPage {
  final List<Product> content;
  final int totalElements;
  final int totalPages;
  final int number;
  final bool last;
  ProductPage({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.number,
    required this.last,
  });
  factory ProductPage.fromJson(Map<String, dynamic> json) {
    return ProductPage(
      content: (json['content'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      number: json['number'] ?? 0,
      last: json['last'] ?? true,
    );
  }
}

class Product {
  final int id;
  final String productCode;
  final String khmerName;
  final String englishName;
  final String description;
  final bool isActive;
  final String? imageUrl;
  final double? price;
  final int category;
  final int user;
  final String? createdAt;
  final String? updatedAt;

  Product({
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

  factory Product.fromJson(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      productCode: map['productCode'] ?? '',
      khmerName: map['khmerName'] ?? '',
      englishName: map['englishName'] ?? '',
      description: map['description'] ?? '',

      // FIX HERE
      isActive: map['active'] ?? false,

      // NULL SAFE
      imageUrl: map['imageUrl'],

      // HANDLE int/double/null
      price: map['price'] != null ? (map['price'] as num).toDouble() : 0,

      category: map['category'] ?? 0,
      user: map['user'] ?? 0,

      // NULL SAFE
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
