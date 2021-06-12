// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  ApiResponse({
    required this.data,
    required this.error,
  });

  Data? data;
  Error? error;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        data: Data.fromJson(json["data"]),
        error: Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error?.toJson(),
      };
}

class Data {
  Data({
    required this.version,
  });

  String version;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
      };
}

class Error {
  Error();

  factory Error.fromJson(Map<String, dynamic> json) => Error();

  Map<String, dynamic> toJson() => {};
}
