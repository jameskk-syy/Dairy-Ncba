
import '../../domain/model/add_milk_acc_response_model.dart';

class AddMilkAccumulationResponseDto extends AddMilkAccumulationResponse {
  const AddMilkAccumulationResponseDto({
    required super.message,
    required super.statusCode,
  });

  factory AddMilkAccumulationResponseDto.fromJson(Map<String, dynamic> json) {
    return AddMilkAccumulationResponseDto(
      message: json['message'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }


}