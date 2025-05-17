import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/bookings.dart';
import '../providers/bookings_page_provider.dart';
import '../utils/user_utils.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> _starredBookings = [];

  @override
  void initState() {
    super.initState();
    // Fetch bookings when the page is initialized
    final bookingProvider = Provider.of<BookingPageProvider>(context, listen: false);
    bookingProvider.fetchBookings();
  }

  void _star(dynamic booking) {
    setState(() {
      if (!_starredBookings.contains(booking)) {
        _starredBookings.add(booking);
      }
    });
  }

  void _unstar(dynamic booking) {
    setState(() {
      _starredBookings.remove(booking);
    });
  }

  void _rebook(dynamic booking) {
    if(booking["BookingId"])
    {BusinessBookingApi.createBooking('${booking['businessClient']['BusinessId']}', {
      "ServiceId": '${booking['service']['Sid']}',
    "userId": UserUtils.user!['userId'],
    "Status": "Pending",
    "BookedMode": "Online",
    "BookedTime": DateTime.now().toIso8601String(),
    "ServiceTime": "17:00",
    "ServiceDate": "2025-02-01"
    });}
    else{
      ProfessionalBookingApi.createBooking({
        'userId': booking["userId"],
      'service_id': booking['service_id'],
      'profession_id': booking['profession_id'],
      'booking_timestamp': DateTime.now().toIso8601String(),
      'service_date_time': '2025-02-01 17:00:00',
      'status': 'Pending',
      'payment_status': 'Not Paid',
      'payment_method': booking['payment_method'],
      'cancellation_reason': '',
      'payment': booking['payment'],
      });
    }
  }

  void _cancel(dynamic booking) {
    if(booking["BookingId"]){
      BusinessBookingApi.updateBooking(booking["BookingId"], {
        "Status": "Cancelled",
      });}
    else{
      ProfessionalBookingApi.changeStatus(booking["BookingId"], "Cancelled");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingPageProvider>(context);
    final pastBookings = bookingProvider.pastBookings;
    final upcomingBookings = bookingProvider.upcomingBookings;

    return Scaffold(
      body: ListView(
        children: [
          // Upcoming Bookings Section
          _buildSectionTitle('Upcoming Bookings'),
          ...upcomingBookings.map((booking) => BookingCard(
                booking: booking,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(booking, _rebook, _cancel)),
                  );
                },
                star: _star,
                unstar: _unstar,
                isStarred: _starredBookings.contains(booking),
              )),
          Divider(thickness: 2),

          // Starred Bookings Section
          _buildSectionTitle('Starred Bookings'),
          if (_starredBookings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('No starred bookings.'),
            )
          else
            ..._starredBookings.map((booking) => BookingCard(
                  booking: booking,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingDetailsPage(booking, _rebook, _cancel)),
                    );
                  },
                  star: _star,
                  unstar: _unstar,
                  isStarred: true,
                )),
          Divider(thickness: 2),

          // Past Bookings Section
          _buildSectionTitle('Past Bookings'),
          ...pastBookings.map((booking) => BookingCard(
                booking: booking,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingDetailsPage(booking, _rebook, _cancel)),
                  );
                },
                star: _star,
                unstar: _unstar,
                isStarred: _starredBookings.contains(booking),
              )),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final dynamic booking;
  final Function onPressed;
  final Function star;
  final Function unstar;
  final bool isStarred;

  BookingCard({
    required this.booking,
    required this.onPressed,
    required this.star,
    required this.unstar,
    required this.isStarred,
  });

  bool isUpcoming() => DateTime.parse(booking['ServiceDate']).isAfter(DateTime.now());

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = min(_width / 2.5, 150);
    double padding = (_width > 600) ? 30.0 : 15.0;

    final Color cardColor1 = Theme.of(context).colorScheme.primary;
    final Color cardColor2 = Theme.of(context).colorScheme.secondary;
    final Color textColor = Theme.of(context).colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: _height,
            width: _width - 20,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        cardColor1.withOpacity(1),
                        cardColor2.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 8.0, 0.0, 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              booking['service']['ServiceName'],
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isUpcoming())
                            IconButton(
                              onPressed: () => isStarred ? unstar(booking) : star(booking),
                              icon: Icon(
                                isStarred ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        booking['ServiceDate'],
                        style: TextStyle(
                          fontSize: 18,
                          color: textColor.withOpacity(0.90),
                          fontFamily: "Times New Roman",
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        booking['businessClient']['Clientname'],
                        style: TextStyle(
                          fontSize: 20,
                          color: textColor,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final dynamic booking;
  final Function onRebook;
  final Function onCancel;

  BookingDetailsPage(this.booking, this.onRebook, this.onCancel);

  @override
  Widget build(BuildContext context) {
    final Color cardColor1 = Theme.of(context).colorScheme.primary;
    final Color cardColor2 = Theme.of(context).colorScheme.secondary;
    final Color textColor = Theme.of(context).colorScheme.tertiary;
    final double _width = MediaQuery.of(context).size.width;
    final double padding = (_width > 600) ? 20.0 : 12.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      cardColor1.withOpacity(1),
                      cardColor2.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['businessClient']['Clientname'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Address: 123 Main St',
                      style: TextStyle(color: textColor.withOpacity(0.9)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Contact: 555-555-5555',
                      style: TextStyle(color: textColor.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Services Opted'),
              ServicesOpted(
                services: [booking['service']['ServiceName']],
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Booking Summary'),
              BookingSummary(
                date: DateTime.parse(booking['ServiceDate']),
                time: booking['ServiceTime'],
                serviceDetails: booking['service']['ServiceName'],
                costBreakdown: booking['service']['ServiceCost'],
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Actions'),
              ActionOptions(
                booking: booking,
                onRebook: onRebook,
                onCancel: onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ServicesOpted extends StatelessWidget {
  final List<String> services;

  ServicesOpted({required this.services});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: services.map((service) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                '- $service',
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BookingSummary extends StatelessWidget {
  final DateTime date;
  final String time;
  final String serviceDetails;
  final String costBreakdown;

  BookingSummary({
    required this.date,
    required this.time,
    required this.serviceDetails,
    required this.costBreakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${date.toLocal()}'),
            Text('Time: $time'),
            Text('Service Details: $serviceDetails'),
            Text('Cost Breakdown: $costBreakdown'),
          ],
        ),
      ),
    );
  }
}

class ActionOptions extends StatelessWidget {
  final dynamic booking;
  final Function onRebook;
  final Function onCancel;

  ActionOptions({required this.booking, required this.onRebook, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    bool isUpcoming = DateTime.parse(booking['ServiceDate']).isAfter(DateTime.now());
    bool isPast = !isUpcoming;

    return Column(
      children: [
        if (isPast)
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context, 'Re-book this service?', () => onRebook(booking));
            },
            child: Text('Re-book'),
          ),
        if (isUpcoming)
          ElevatedButton(
            onPressed: () {
              _showConfirmationDialog(context, 'Cancel this booking?', () => onCancel(booking));
            },
            child: Text('Cancel Booking'),
          ),
        if (!isUpcoming)
          ElevatedButton(
            onPressed: () {
              // Implement feedback logic here
            },
            child: Text('Feedback'),
          ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String action, Function actionCallback) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(action),
          content: Text('Are you sure you want to $action'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog without action
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                actionCallback();
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Close Booking Details page
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}