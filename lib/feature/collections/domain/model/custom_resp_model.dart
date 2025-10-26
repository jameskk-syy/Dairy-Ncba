import 'package:equatable/equatable.dart';

class CustomResponse extends Equatable {
  final String? message;
  final int? statusCode;

  const CustomResponse({this.message, this.statusCode});

  factory CustomResponse.fromJson(Map<String, dynamic> map) {
    return CustomResponse(
        message: map['message'], statusCode: map['statusCode']);
  }

  @override
  List<Object?> get props => [message, statusCode];
}
