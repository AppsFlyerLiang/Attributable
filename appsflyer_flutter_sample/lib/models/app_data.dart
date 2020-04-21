import 'package:flutter/foundation.dart';
class ConversionResponse {
  final String status;
  final String type;
  final Map<String, dynamic> data;

  ConversionResponse(this.status, this.type, this.data);

  ConversionResponse.fromJson(Map<dynamic, dynamic> json)
      : this.status = json["status"],
        this.type = json["type"],
        this.data = json["data"];
}
