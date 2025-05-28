import 'package:flutter/material.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/screens/home/homescreen.dart';
import 'package:sklyit/flash/repository/screens/orders/order_details.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  // Sample order data
  final List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD123456',
      'date': '2024-03-15',
      'status': 'Delivered',
      'items': [
        {'name': 'Fresh Fruits', 'quantity': 2, 'price': 299},
        {'name': 'Vegetables Pack', 'quantity': 1, 'price': 199},
      ],
      'totalAmount': 797,
      'deliveryAddress': '123 Main Street, City',
      'paymentMethod': 'Credit Card',
      'deliveryTime': '15-20 min',
      'deliveryPartner': 'John Doe',
      'deliveryPartnerPhone': '+91 98765 43210',
      'orderPlacedAt': '2024-03-15 14:30',
      'deliveredAt': '2024-03-15 14:45',
      'subtotal': 797,
      'deliveryFee': 40,
      'discount': 0,
      'tax': 40,
    },
    {
      'orderId': 'ORD123455',
      'date': '2024-03-14',
      'status': 'Processing',
      'items': [
        {'name': 'Organic Milk', 'quantity': 1, 'price': 89},
        {'name': 'Whole Wheat Bread', 'quantity': 2, 'price': 45},
      ],
      'totalAmount': 179,
      'deliveryAddress': '123 Main Street, City',
      'paymentMethod': 'UPI',
      'deliveryTime': '20-25 min',
      'deliveryPartner': 'Jane Smith',
      'deliveryPartnerPhone': '+91 98765 43211',
      'orderPlacedAt': '2024-03-14 10:15',
      'deliveredAt': null,
      'subtotal': 179,
      'deliveryFee': 30,
      'discount': 0,
      'tax': 18,
    },
  ];

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
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(context, order);
        },
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
              'Date: ${order['date']}',
              style: TextStyle(
                color: ColorPalette.secondaryColor.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),

            Divider(color: Colors.grey[200]),
            SizedBox(height: 8),

            // Order items
            ...order['items'].map<Widget>((item) => Padding(
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
                onPressed: () => _navigateToOrderDetails(context, order),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetails(order: order),
      ),
    );
  }
}