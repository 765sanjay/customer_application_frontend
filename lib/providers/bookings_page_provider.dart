import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sklyit/utils/user_utils.dart';
import 'package:sklyit/api/bookings.dart';

class BookingPageProvider with ChangeNotifier {
  List<dynamic> _bookings = [];
  List<dynamic> _pastBookings = [];
  List<dynamic> _upcomingBookings = [];

  List<dynamic> get bookings => _bookings;
  List<dynamic> get pastBookings => _pastBookings;
  List<dynamic> get upcomingBookings => _upcomingBookings;

  Future<void> fetchBookings() async {
    try {
      _bookings = await BusinessBookingApi.getBookingsByCustomerId("${UserUtils.user!['userId']}");
      _bookings.addAll(await ProfessionalBookingApi.getBookingsByCustomerId());
      _getPastBookings();
      _getUpcomingBookings();
    } catch (e) {
      throw Exception('Failed to load bookings: $e');
    }
  }

  void _getPastBookings() async {
    _pastBookings = _bookings.where((booking) => booking['Status'] == 'Completed' || booking["booking_status"] == "Completed").toList();
    notifyListeners();
  }

  void _getUpcomingBookings() async {
    _upcomingBookings = _bookings.where((booking) => booking['Status'] != 'Completed' || booking["booking_status"] != "Completed").toList();
    notifyListeners();
  }
}