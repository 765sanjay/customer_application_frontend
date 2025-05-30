import 'package:flutter/material.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/screens/home/homescreen.dart';
import 'package:sklyit/flash/repository/screens/orders/order_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/flash/order'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          orders = data.map((order) => Map<String, dynamic>.from(order)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load orders';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading orders: $e';
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchOrderDetails(String orderId) async {
    print('Fetching order details for orderId: $orderId'); // Debug print
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/flash/order/$orderId'),
      );

      print('Response status code: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data'); // Debug print
        return Map<String, dynamic>.from(data);
      } else {
        print('Error response: ${response.body}'); // Debug print
        return null;
      }
    } catch (e) {
      print('Error fetching order details: $e'); // Debug print
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.white,
      appBar: AppBar(
        backgroundColor: ColorPalette.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorPalette.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: ColorPalette.secondaryColor,
              size: 20,
            ),
          ),
          onPressed: () => _navigateToHomeScreen(context),
        ),
        title: Text(
          'Order History',
          style: TextStyle(
            color: ColorPalette.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: ColorPalette.secondaryColor),
            onPressed: _loadOrders,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorPalette.primaryColor,
              ),
            )
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Error Loading Orders',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        error!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadOrders,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No Orders Yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your order history will appear here',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadOrders,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return _buildOrderCard(context, order);
                        },
                      ),
                    ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    print('Building order card for order: $order'); // Debug print
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      color: ColorPalette.white,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header with ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['orderId']}',
                  style: TextStyle(
                    color: ColorPalette.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: order['status'] == 'Delivered'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['status'],
                    style: TextStyle(
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Order date
            Text(
              'Date: ${order['orderPlacedAt']}',
              style: TextStyle(
                color: ColorPalette.secondaryColor.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),

            Divider(color: Colors.grey[200]),
            SizedBox(height: 8),

            // Order items
            ...(order['items'] as List).map<Widget>((item) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${item['name']} x${item['quantity']}',
                    style: TextStyle(
                      color: ColorPalette.secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${item['price'] * item['quantity']}',
                    style: TextStyle(
                      color: ColorPalette.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )).toList(),

            SizedBox(height: 8),
            Divider(color: Colors.grey[200]),
            SizedBox(height: 8),

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    color: ColorPalette.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${order['totalAmount']}',
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('View Details button pressed for order: ${order['orderId']}'); // Debug print
                  _fetchOrderDetails(order['orderId']).then((orderDetails) {
                    print('Fetched order details: $orderDetails'); // Debug print
                    if (orderDetails != null) {
                      _navigateToOrderDetails(context, orderDetails);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to load order details'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }).catchError((error) {
                    print('Error in button press handler: $error'); // Debug print
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: ColorPalette.primaryColor),
                  ),
                ),
                child: Text(
                  'View Details',
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void _navigateToOrderDetails(BuildContext context, Map<String, dynamic> order) {
    print('Navigating to order details with data: $order'); // Debug print
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetails(order: order),
      ),
    );
  }
}