import 'package:dio/dio.dart';

class APIOptions {
  String token;

  APIOptions(this.token);

  Options get options {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}