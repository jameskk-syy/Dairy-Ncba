// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ProductCategoryResponse extends Equatable {
  final int? statusCode;
  final List<ProductCategory>? productCategory;

  const ProductCategoryResponse({this.statusCode, this.productCategory});

  factory ProductCategoryResponse.fromJson(Map<String, dynamic> map) {
    final List<dynamic> productsList = map['categoryData'] ?? [];
    final List<ProductCategory> productCategories = productsList
        .map((product) =>
            ProductCategory.fromMap(product as Map<String, dynamic>))
        .toList();
    return ProductCategoryResponse(
        statusCode: map['statusCode'], productCategory: productCategories);
  }

  @override
  List<Object?> get props => [statusCode, productCategory];
}

class ProductCategory extends Equatable {
  final int? id;
  final String? name;
  final String? description;

  const ProductCategory({this.id, this.description, this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategory.fromJson(String source) =>
      ProductCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, name, description];
}
