import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/cart_provider.dart';
import 'package:sklyit/flash/repository/screens/cart/cartscreen.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsPage extends StatefulWidget {
  final String businessId;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkAccent;
  final Color lightAccent;
  final double latitude;
  final double longitude;
  final String category;
  final List<dynamic> subcategories;

  const ProductsPage({
    Key? key,
    required this.businessId,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkAccent,
    required this.lightAccent,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.subcategories,
  }) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use default coordinates if not provided
      final lat = widget.latitude;
      final lon = widget.longitude;
      
      if (lat == null || lon == null) {
        setState(() {
          _error = 'Location coordinates are required';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/flash/nearby/products?lat=$lat&lon=$lon&businessId=${widget.businessId}&category=${widget.category}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _products = data.map((item) => Map<String, dynamic>.from(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load products';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading products: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: widget.primaryColor,
              ),
            )
          : _error != null
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
                        'Error Loading Products',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _products.isEmpty
                  ? Center(
                      child: Text(
                        'No products found nearby',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return _buildProductCard(product);
                      },
                    ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final productId = product['id'].toString();
        final cartItem = cartProvider.items[productId];
        final isInCart = cartItem != null;
        final quantity = isInCart ? cartItem.quantity : 0;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product['image'] ?? 'https://via.placeholder.com/150',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey[400]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] ?? 'Product Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.secondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['brand'] ?? 'Brand',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${product['price']?.toString() ?? '0'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.primaryColor,
                          ),
                        ),
                        if (!isInCart)
                          IconButton(
                            icon: Icon(Icons.add_shopping_cart, color: widget.accentColor),
                            onPressed: () {
                              cartProvider.addItem(
                                productId,
                                product['name'] ?? 'Product',
                                product['brand'] ?? 'Brand',
                                (product['price'] ?? 0).toDouble(),
                                product['image'] ?? '',
                                isFlashProduct: true,
                              );
                            },
                          )
                        else
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, color: widget.accentColor),
                                onPressed: () {
                                  if (quantity > 1) {
                                    cartProvider.decreaseQuantity(productId);
                                  } else {
                                    cartProvider.removeItem(productId);
                                  }
                                },
                              ),
                              Text(
                                '$quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.secondaryColor,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: widget.accentColor),
                                onPressed: () => cartProvider.increaseQuantity(productId),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}