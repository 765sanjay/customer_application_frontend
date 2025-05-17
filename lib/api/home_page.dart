import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';

class HomePageApi {
  /// Returns a list of trending businesses
  ///
  /// [limit] is the number of businesses to return
  static Future<List<dynamic>> getTrending({int? limit = 10}) async {
    final response = await http.get(
      Uri.parse('${UserUtils.baseUrl}/search/business/trending/$limit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserUtils.jwt}',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get trending businesses');
    }
  }

  /// Returns a list of top businesses
  ///
  /// [limit] is the number of businesses to return
  static Future<List<dynamic>> getTopBusinesses({int? limit = 10}) async {
    final response = await http.get(
      Uri.parse('${UserUtils.baseUrl}/search/top-businesses/$limit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserUtils.jwt}',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get top businesses');
    }
  }

  /// Returns a list of businesses filtered by tag
  ///
  /// [tag] is the tag to search for
  static Future<List<dynamic>> getByTag(String tag) async {
    final response = await http.get(
      Uri.parse('${UserUtils.baseUrl}/search/business/tag/$tag'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserUtils.jwt}',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search businesses by tag');
    }
  }

  /// Returns a list of services ordered by most bookings
  ///
  /// [limit] is the number of services to return
  static Future<List<dynamic>> getServicesOrderedByMostBookings(int limit) async {
    final response = await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/sklyit-sphere/business/services/top?limit=$limit'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get services ordered by most bookings');
    }
  }

  /// Returns a list of services ordered by most bookings by professional
  ///
  /// [limit] is the number of services to return
  static Future<List<dynamic>> getServicesOrderedByMostBookingsByProfessional(
      int limit) async {
    final response = await http.get(
      Uri.parse(
          '${UserUtils.baseUrl}/sklyit-sphere/professional/services/top?limit=$limit'),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to get services ordered by most bookings by professional');
    }
  }

  /// Returns a list of professionals filtered by tag
  ///
  /// [tag] is the tag to search for
  static Future<List<dynamic>> searchProfessionalByTag(String tag) async {
    final url = '${UserUtils.baseUrl}/search/professional/tag/$tag';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search professional by tag');
    }
  }

  /// Returns a list of trending professionals
  ///
  /// [limit] is the number of professionals to return
  static Future<List<dynamic>> getTrendingProfessionals(int limit) async {
    final url = '${UserUtils.baseUrl}/search/professional/trending/$limit';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get trending professionals');
    }
  }

  /// Returns a list of top professionals
  ///
  /// [limit] is the number of professionals to return
  static Future<List<dynamic>> getTopProfessionals(int limit) async {
    final url = '${UserUtils.baseUrl}/search/top-professionals/$limit';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${UserUtils.jwt}'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get top professionals');
    }
  }
}
  
  

