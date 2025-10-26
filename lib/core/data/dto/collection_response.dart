class CollectionResponse {
  final String message;
  final int statusCode;

  CollectionResponse({
    required this.message,
    required this.statusCode
  });

  factory CollectionResponse.fromJson(Map<String, dynamic> json) {
    return CollectionResponse(
      message: json['message'] as String,
      statusCode: json['statusCode'] as int,
    );
  }
}
