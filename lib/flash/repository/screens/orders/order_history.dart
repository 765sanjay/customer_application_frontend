import 'package:flutter/material.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/screens/home/homescreen.dart';
import 'package:sklyit/flash/repository/screens/orders/order_details.dart';
import 'package:sklyit/flash/repository/screens/bottomnav/bottomnavscreen.dart';

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
      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      setState(() {
        orders = [
          {
            'orderId': 'ORD001',
            'status': 'Delivered',
            'orderPlacedAt': '2024-03-15',
            'items': [
              {'name': 'Fresh Fruits', 'quantity': 2, 'price': 299},
              {'name': 'Vegetables Pack', 'quantity': 1, 'price': 199},
            ],
            'totalAmount': 797,
            'deliveryAddress': '123 Main Street, City',
            'deliveryTime': '2:00 PM - 3:00 PM',
            'deliveryPartner': 'John Doe',
            'deliveryPartnerPhone': '+91 9876543210',
            'paymentMethod': 'Credit Card',
            'subtotal': 697,
            'deliveryFee': 50,
            'discount': 0,
            'tax': 50,
          },
          {
            'orderId': 'ORD002',
            'status': 'Processing',
            'orderPlacedAt': '2024-03-14',
            'items': [
              {'name': 'Fresh Bread', 'quantity': 1, 'price': 99},
              {'name': 'Milk 1L', 'quantity': 2, 'price': 60},
            ],
            'totalAmount': 219,
            'deliveryAddress': '456 Park Avenue, City',
            'deliveryTime': '3:00 PM - 4:00 PM',
            'deliveryPartner': 'Jane Smith',
            'deliveryPartnerPhone': '+91 9876543211',
            'paymentMethod': 'UPI',
            'subtotal': 219,
            'deliveryFee': 40,
            'discount': 20,
            'tax': 20,
          },
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading orders: $e';
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchOrderDetails(String orderId) async {
    // Mock data for demonstration
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    try {
      return orders.firstWhere(
        (order) => order['orderId'] == orderId,
      );
    } catch (e) {
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
                  _navigateToOrderDetails(context, order);
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
      MaterialPageRoute(
        builder: (context) => BottomNavScreen(initialIndex: 0),
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context, Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetails(order: order),
      ),
    );
  }
}