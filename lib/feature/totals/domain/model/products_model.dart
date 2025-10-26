// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

class ProductsModelResponse extends Equatable {
  final String? message;
  final int? statusCode;
  final List<ProductsModel>? productsList;
  const ProductsModelResponse(
      {this.message, this.statusCode, this.productsList});

  factory ProductsModelResponse.fromJson(Map<String, dynamic> map) {
    final List<dynamic> products = map['productData'] ?? [];
    late List<ProductsModel> productsList = [];
    final Logger logger = Logger();
    try {
       productsList = products
          .map((product) =>
              ProductsModel.fromMap(product as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e(e.toString());
    }

    return ProductsModelResponse(
        message: map['message'],
        statusCode: map['statusCode'],
        productsList: productsList);
  }

  @override
  List<Object?> get props => [message, statusCode, productsList];
}

class ProductsModel extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final double? salePrice;
  final int? stock;
  final String? type;
  final int? categoryId;
  final String? mcc;
  final String? category;
  const ProductsModel({
    this.id,
    this.name,
    this.description,
    this.salePrice,
    this.stock,
    this.type,
    this.categoryId,
    this.mcc,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'salePrice': salePrice,
      'stock': stock,
      'type': type,
      'categoryId': categoryId,
      'mcc': mcc,
      'category': category,
    };
  }

  factory ProductsModel.fromMap(Map<String, dynamic> map) {
    return ProductsModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      salePrice: map['salePrice'] != null ? map['salePrice'] as double : null,
      stock: map['stock'] != null ? map['stock'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      categoryId: map['categoryId'] != null ? map['categoryId'] as int : null,
      mcc: map['mcc'] != null ? map['mcc'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsModel.fromJson(String source) =>
      ProductsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      salePrice,
      stock,
      type,
      categoryId,
      mcc,
      category,
    ];
  }
}
