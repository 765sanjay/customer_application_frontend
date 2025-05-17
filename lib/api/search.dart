import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SearchApi {
  static Future<String> search(String? query, String? location, int? limit) async {
    var response = await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/search?location=$location&limit=$limit&queryString=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserUtils.jwt}',
      },
    );
    print(response);
    return response.body;
  }

  static Future<String> searchProfessionals({
    String? queryString,
    String? location,
    String? tag,
    int? page,
    int? limit,
  }) async {
    final params = {
      if (queryString != null) 'queryString': queryString,
      if (location != null) 'location': location,
      if (tag != null) 'tag': tag,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };
    final response = await http.get(
      Uri.https(
        UserUtils.baseUrl,
        '/search//professionals',
        params,
      ),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to search professionals');
    }
  }

  static Future<dynamic> getServicesByBusinessId(String businessId) async {
    return await http.get(
      Uri.parse(
          '{UserUtils.baseUrl}/sklyit-sphere/business/services/id/$businessId'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
  }

  static Future<dynamic> getProductsByBusinessId(String businessId) async {
    return await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/sklyit-sphere/business/products/id/$businessId'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
  }

  static Future<dynamic> getPostsByBusinessId(String businessId) async {
    return await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/sklyit-sphere/business/posts/id/$businessId'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
  }

  static Future<dynamic> getServicesByProfessionalId(String professionalId) async {
    return await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/sklyit-sphere/professional/services/id/$professionalId'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );
  }

    /// Returns a professional by id
  ///
  /// [id] is the id of the professional to retrieve
  static Future<dynamic> getProfessionalById(String id) async {
    final url = '${UserUtils.baseUrl}/search/professional/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get professional by id');
    }
  }

  static Future<dynamic> getBusinessById(String id) async {
    final url = '${UserUtils.baseUrl}/search/business/$id';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get business by id');
    }
  }
}
