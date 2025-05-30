import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/uihelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Color primaryColor = const Color(0xFF009085);
  final Color secondaryColor = const Color(0xFF2F4858);
  Map<String, String>? _selectedAddress;
  bool _isLoading = false;
  String? _error;
  String? _orderId;

  List<Map<String, String>> _addresses = [
    {
      'name': 'Home',
      'address': '123 Main St, Apt 4B\nNew York, NY 10001\nUnited States',
      'phone': '+1234567890',
    },
    {
      'name': 'Work',
      'address': '456 Business Ave, Floor 12\nNew York, NY 10005\nUnited States',
      'phone': '+0987654321',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (_addresses.isNotEmpty) {
      _selectedAddress = _addresses.first;
    }
  }

  Future<void> _requestOrder(CartProvider cart) async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Separate flash and flash market items
      final flashItems = cart.items.values.where((item) => item.isFlashProduct).toList();
      final marketItems = cart.items.values.where((item) => !item.isFlashProduct).toList();

      String? flashOrderId;
      String? marketOrderId;

      // Process flash items if any
      if (flashItems.isNotEmpty) {
        final flashResponse = await http.post(
          Uri.parse('http://localhost:3000/flash/request/order'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'items': flashItems.map((item) => {
              'id': item.id,
              'quantity': item.quantity,
              'price': item.price,
            }).toList(),
            'deliveryAddress': _selectedAddress,
            'totalAmount': flashItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
          }),
        );

        if (flashResponse.statusCode != 200) {
          throw Exception('Failed to process flash items');
        }
        flashOrderId = json.decode(flashResponse.body)['orderId'];
      }

      // Process market items if any
      if (marketItems.isNotEmpty) {
        final marketResponse = await http.post(
          Uri.parse('http://localhost:3000/flash/market/request/order'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'items': marketItems.map((item) => {
              'id': item.id,
              'quantity': item.quantity,
              'price': item.price,
            }).toList(),
            'deliveryAddress': _selectedAddress,
            'totalAmount': marketItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity)),
          }),
        );

        if (marketResponse.statusCode != 200) {
          throw Exception('Failed to process market items');
        }
        marketOrderId = json.decode(marketResponse.body)['orderId'];
      }

      setState(() {
        _orderId = flashOrderId ?? marketOrderId;
      });

      // Confirm orders
      await _confirmOrder(flashOrderId, marketOrderId);

    } catch (e) {
      setState(() {
        _error = 'An error occurred while processing your order: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmOrder(String? flashOrderId, String? marketOrderId) async {
    try {
      // Confirm flash order if exists
      if (flashOrderId != null) {
        final flashResponse = await http.post(
          Uri.parse('http://localhost:3000/flash/confirm/order'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'orderId': flashOrderId,
          }),
        );

        if (flashResponse.statusCode != 200) {
          throw Exception('Failed to confirm flash order');
        }
      }

      // Confirm market order if exists
      if (marketOrderId != null) {
        final marketResponse = await http.post(
          Uri.parse('http://localhost:3000/flash/market/confirm/order'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'orderId': marketOrderId,
          }),
        );

        if (marketResponse.statusCode != 200) {
          throw Exception('Failed to confirm market order');
        }
      }

      // Get order details after successful confirmation
      await _getOrderDetails();

    } catch (e) {
      setState(() {
        _error = 'An error occurred while confirming your order: ${e.toString()}';
      });
    }
  }

  Future<void> _getOrderDetails() async {
    if (_orderId == null) return;

    try {
      // Try to get flash order details first
      final flashResponse = await http.get(
        Uri.parse('http://localhost:3000/flash/order/$_orderId'),
      );

      if (flashResponse.statusCode == 200) {
        final orderData = json.decode(flashResponse.body);
        _showOrderSuccessDialog(orderData);
        return;
      }

      // If flash order not found, try market order
      final marketResponse = await http.get(
        Uri.parse('http://localhost:3000/flash/market/order/$_orderId'),
      );

      if (marketResponse.statusCode == 200) {
        final orderData = json.decode(marketResponse.body);
        _showOrderSuccessDialog(orderData);
      } else {
        setState(() {
          _error = 'Failed to get order details. Please check your orders.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred while fetching order details: ${e.toString()}';
      });
    }
  }

  void _showOrderSuccessDialog(Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Order ID: $_orderId',
                  style: TextStyle(
                    color: secondaryColor.withOpacity(0.8),
                  ),
                ),
                if (orderData['estimatedDelivery'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Estimated Delivery: ${orderData['estimatedDelivery']}',
                    style: TextStyle(
                      color: secondaryColor.withOpacity(0.8),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Clear the cart
                    Provider.of<CartProvider>(context, listen: false).clear();
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Delivery Address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // List of saved addresses
                ..._addresses.map((address) => _buildAddressOption(
                  context,
                  address,
                )),
                const SizedBox(height: 16),
                // Add new address button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _showAddAddressDialog(context);
                  },
                  icon: Icon(Icons.add_location_alt),
                  label: Text('Add New Address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final newAddress = {
                            'name': nameController.text,
                            'address': addressController.text,
                            'phone': phoneController.text,
                          };
                          setState(() {
                            _addresses.add(newAddress);
                            _selectedAddress = newAddress;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressOption(BuildContext context, Map<String, String> address) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAddress = address;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _selectedAddress == address ? primaryColor : Colors.grey[300]!,
            width: _selectedAddress == address ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address['name'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address['address'] ?? 'No Address',
                    style: TextStyle(color: secondaryColor.withOpacity(0.8)),
                  ),
                  Text(
                    address['phone'] ?? 'No Phone',
                    style: TextStyle(color: secondaryColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            if (_selectedAddress == address)
              Icon(Icons.check_circle, color: primaryColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cart, child) {
          return Stack(
            children: [
              Column(
                children: [
                  // Delivery Address Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showAddressDialog(context),
                              child: Text(
                                'Change',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Display selected address
                        _buildAddressCard(_selectedAddress ?? _addresses.first),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Order Summary Section
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...cart.items.values.map((item) => _buildOrderItem(item)),
                        const SizedBox(height: 16),
                        _buildTotalSection(cart),
                      ],
                    ),
                  ),
                  // Proceed to Payment Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _requestOrder(cart),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (_error != null)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red[900]),
                          onPressed: () {
                            setState(() {
                              _error = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> address) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address['name'] ?? 'No Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            address['address'] ?? 'No Address',
            style: TextStyle(color: secondaryColor.withOpacity(0.8)),
          ),
          Text(
            address['phone'] ?? 'No Phone',
            style: TextStyle(color: secondaryColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    color: secondaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${(item.price * item.quantity).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal', cart.totalAmount),
          const SizedBox(height: 8),
          _buildTotalRow('Delivery Fee', 40.0),
          const SizedBox(height: 8),
          _buildTotalRow('Tax', cart.totalAmount * 0.05),
          const Divider(height: 24),
          _buildTotalRow(
            'Total',
            cart.totalAmount + 40.0 + (cart.totalAmount * 0.05),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondaryColor.withOpacity(0.8),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isBold ? primaryColor : secondaryColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
} 