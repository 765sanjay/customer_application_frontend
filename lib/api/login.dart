import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';

Future<http.Response> login(String phoneNumber, String password) async {
  return await http.post(
      Uri.parse('${UserUtils.baseUrl}/bs/auth_customer/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userid': phoneNumber,
        'password': password,
      }),
    );
}