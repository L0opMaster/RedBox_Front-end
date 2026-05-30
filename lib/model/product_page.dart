// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

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
  final String imageUrl;
  final double price;
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
  // factory Product.fromJson(Map<String, dynamic> map) {
  //   return Product(
  //     id: map['id'] ?? 0,
  //     productCode: map['productCode'] ?? '',
  //     khmerName: map['khmerName'] ?? '',
  //     englishName: map['englishName'] ?? '',
  //     description: map['description'] ?? '',

  //     // FIX HERE
  //     isActive: map['active'] ?? false,

  //     imageUrl: map['imageUrl'] ?? '',
  //     price: (map['price'] as num?)?.toDouble() ?? 0,

  //     category: map['category'] ?? 0,
  //     user: map['user'] ?? 0,

  //     // NULL SAFE
  //     createdAt: map['createdAt'],
  //     updatedAt: map['updatedAt'],
  //   );
  // }
}

class ProductRequest {
  final String khmerName;
  final String englishName;
  final String description;
  final String imageUrl;
  final bool isActive;
  final double price;
  final int categoryId;
  ProductRequest({
    required this.khmerName,
    required this.englishName,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.price,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'khmerName': khmerName,
      'englishName': englishName,
      'description': description,
      'imageUrl':
          imageUrl, // Adjust to 'image_url' if validation throws bad request errors
      'isActive': isActive,
      'price': price,
      'categoryId': categoryId,
    };
  }

  factory ProductRequest.fromMap(Map<String, dynamic> map) {
    return ProductRequest(
      khmerName: map['khmerName'] as String,
      englishName: map['englishName'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      isActive: map['isActive'] as bool,
      price: map['price'] as double,
      categoryId: map['categoryId'] as int,
    );
  }
}
