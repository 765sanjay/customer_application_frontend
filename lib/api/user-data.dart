import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';

Future<http.Response> saveBooking(String bookingId) async {
  return await http.patch(
    Uri.parse('${UserUtils.baseUrl}/bookings'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
    body: jsonEncode(<String, String>{
      'bookingId': bookingId,
    }),
  );
}

Future<http.Response> getUserDetails() async {
  return await http.get(
    Uri.parse('${UserUtils.baseUrl}/user-data/data'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
  );
}

Future<http.Response> getUserPreferences() async {
  return await http.get(
    Uri.parse('${UserUtils.baseUrl}/user-data/preferences'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
  );
}

Future<http.Response> updateUserPreferences(Map<String, dynamic> preferences) async {
  return await http.patch(
    Uri.parse('${UserUtils.baseUrl}/user-data/preferences'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
    body: jsonEncode(preferences),
  );
}

Future<http.Response> followBusiness(String businessId) async {
  return await http.patch(
    Uri.parse('${UserUtils.baseUrl}/user-data/followed-business/$businessId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
  );
}

Future<http.Response> unfollowBusiness(String businessId) async {
  return await http.delete(
    Uri.parse('${UserUtils.baseUrl}/user-data/followed-business/$businessId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${UserUtils.jwt}',
    },
  );
}

Future<void> uploadAvatar(String? imagePath) async {
    if (imagePath == null) {
      // No image picked, return early
      return;
    }

    // Prepare the multipart request
    final uri = Uri.parse('${UserUtils.baseUrl}/users/updateUser/${UserUtils.user?["userId"]}'); 
    var request = http.MultipartRequest('PUT', uri);

    // Add the file to the request
    var file = await http.MultipartFile.fromPath('image', imagePath!);  // 'image' is the form field name for the file
    request.files.add(file);

    // Send the request
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Handle success
        print('File uploaded successfully');
      } else {
        // Handle failure
        print('Failed to upload file');
      }
    } catch (e) {
      // Handle error
      print('Error uploading file: $e');
    }
  }