// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

class FeedsRequestModelResponse extends Equatable {
  final String? message;
  final int? statusCode;
  final FeedsRequestModel? feedsRequestsModel;
  const FeedsRequestModelResponse(
      {this.message, this.statusCode, this.feedsRequestsModel});

  factory FeedsRequestModelResponse.fromJson(Map<String, dynamic> map) {
    return FeedsRequestModelResponse(
        message: map['message'],
        statusCode: map['statusCode'],
        feedsRequestsModel:
            map['entity'] ? FeedsRequestModel.fromJson(map['entity']) : null);
  }

  @override
  List<Object?> get props => [message, statusCode, feedsRequestsModel];
}

class AllFeedsRequestModelResponse extends Equatable {
  final String? message;
  final int? statusCode;
  final List<FeedsRequestModel>? feedsRequestsList;
  const AllFeedsRequestModelResponse(
      {this.message, this.statusCode, this.feedsRequestsList});

  factory AllFeedsRequestModelResponse.fromJson(Map<String, dynamic> map) {
    List<dynamic> requests = map['entity'] ?? [];
    List<FeedsRequestModel> allRequests = [];
    final Logger logger = Logger();
    try {
      allRequests = requests
          .map((request) =>
              FeedsRequestModel.fromMap(request as Map<String, dynamic>))
          .toList();
    } catch (e) {
      logger.e("errrror ${e.toString()}");
    }
    return AllFeedsRequestModelResponse(
        message: map['message'],
        statusCode: map['statusCode'],
        feedsRequestsList: allRequests);
  }

  @override
  List<Object?> get props => [message, statusCode, feedsRequestsList];
}

class FeedsRequestModel extends Equatable {
  final int? id;
  final int? farmerNo;
  final String? farmerName;
  final String? requestedOn;
  final int? quantity;
  final String? productName;
  final String? comments;
  final String? status;
  final String? approvalDate;

  const FeedsRequestModel({
    this.id,
    this.farmerNo,
    this.farmerName,
    this.requestedOn,
    this.quantity,
    this.productName,
    this.comments,
    this.status,
    this.approvalDate
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'farmerNo': farmerNo,
      'farmerName': farmerName,
      'requestedOn': requestedOn,
      'quantity': quantity,
      'productName': productName,
      'comments': comments,
      'status': status,
      'approvalDate': approvalDate
    };
  }

  factory FeedsRequestModel.fromMap(Map<String, dynamic> map) {
    return FeedsRequestModel(
      id: map['id'] != null ? map['id'] as int : null,
      farmerNo: map['farmer_no'] != null ? map['farmer_no'] as int : null,
      farmerName: map['username'] != null ? map['username'] as String : null,
      requestedOn:
          map['requestedOn'] != null ? map['requestedOn'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      productName: map['product'] != null ? map['product'] as String : null,
      comments: map['comments'] != null ? map['comments'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      approvalDate: map['approvalDate'] != null ? map['approvalDate'] as String : null
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedsRequestModel.fromJson(String source) =>
      FeedsRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props =>
      [id, farmerNo, requestedOn, quantity, productName, comments, status, approvalDate];
}
