import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';


class BusinessBookingApi {
  // Fetch all bookings for a specific business
  static Future<List<dynamic>> getAllBookings(String businessId) async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/bs/bookings/business/$businessId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Fetch a specific booking by ID
  static Future<Map<String, dynamic>> getBookingById(String id) async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/bs/booking/$id'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load booking');
    }
  }

  // Fetch bookings by customer ID
  static Future<List<dynamic>> getBookingsByCustomerId(String customerId) async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/bs/bookings/customer/$customerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bookings for customer');
    }
  }

  // Create a new booking
  static Future<Map<String, dynamic>> createBooking(String businessId, Map<String, dynamic> createBookingDto) async {
    final response = await http.post(
      Uri.parse('${UserUtils.baseUrl}/bs/booking/$businessId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(createBookingDto),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create booking');
    }
  }

  // Update an existing booking
  static Future<Map<String, dynamic>> updateBooking(String id, Map<String, dynamic> updateBookingDto) async {
    final response = await http.put(
      Uri.parse('${UserUtils.baseUrl}/bs/booking/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateBookingDto),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update booking');
    }
  }

  // Delete a booking
  static Future<void> deleteBooking(String id) async {
    final response = await http.delete(Uri.parse('${UserUtils.baseUrl}/bs/booking/$id'));

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception('Failed to delete booking');
    }
  }
}

class ProfessionalBookingApi {
  static Future<Map<String, dynamic>> getBookingDetails(String bookingId, {String? status}) async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/professional/bookings/id/$bookingId?status=$status'),
        headers: {'Authorization': 'Bearer ${UserUtils.jwt}'});
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error fetching bookings by status');
    }
  }
  
  static Future<void> changeStatus(String bookingId, String status) async {
    final response = await http.put(
      Uri.parse('${UserUtils.baseUrl}/professional/bookings/update/status/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserUtils.jwt}'
      },
      body: json.encode({'status': status}),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Error updating booking status');
    }
  }

  static Future<void> changePaymentDetails(String bookingId, String status, String paymentStatus, double payment, String paymentMethod) async {
    final response = await http.put(
      Uri.parse('${UserUtils.baseUrl}/professional/bookings/update/payment/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserUtils.jwt}'
      },
      body: json.encode({
        'status': status,
        'payment_status': paymentStatus,
        'payment': payment,
        'payment_method': paymentMethod
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error updating payment details');
    }
  }
  
  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> createPrBookingDto) async {
    final response = await http.post(
      Uri.parse('${UserUtils.baseUrl}/professional/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserUtils.jwt}'
      },
      body: json.encode(createPrBookingDto),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error creating booking');
    }
  }
  
  static Future<List<dynamic>> getBookingsByCustomerId() async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/professional/bookings/customer'),
        headers: {'Authorization': 'Bearer ${UserUtils.jwt}'});
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error fetching bookings by customer');
    }
  }

  static Future<List<dynamic>> getBookingsByProfessionalId(String professionalId) async {
    final response = await http.get(Uri.parse('${UserUtils.baseUrl}/professional/bookings/professional/$professionalId'),
        headers: {'Authorization': 'Bearer ${UserUtils.jwt}'});
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error fetching bookings by professional');
    }
  }
}

