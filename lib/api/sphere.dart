
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sklyit/utils/user_utils.dart';

class SklyitSphereApi {

  static Future<dynamic> getTopAllTime(int limit) async {
    final response = await http.get(
      Uri.parse('${UserUtils.baseUrl}/search/sklyit-sphere/posts/top/all-time?limit=$limit'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
    return _processResponse(response);
  }

   static Future<dynamic> getTopNewest(int limit) async {
    final response = await http.get(
      Uri.parse('${UserUtils.baseUrl}/search/sklyit-sphere/posts/top/newest?limit=$limit'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
    return _processResponse(response);
  }


  static dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

