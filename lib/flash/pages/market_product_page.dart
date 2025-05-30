import 'package:flutter/material.dart';
import '../repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/cart_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarketProductPage extends StatefulWidget {
  final Map<String, dynamic> shop;

  const MarketProductPage({
    Key? key,
    required this.shop,
  }) : super(key: key);

  @override
  State<MarketProductPage> createState() => _MarketProductPageState();
}

class _MarketProductPageState extends State<MarketProductPage> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> productCategories = [];
  bool isSearching = false;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndProducts();
  }

  Future<void> _loadCategoriesAndProducts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/flash/business/${widget.shop['id']}/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Group products by category
        final Map<String, List<Map<String, dynamic>>> categoryMap = {};
        
        for (var product in data) {
          final category = product['category'] as String;
          if (!categoryMap.containsKey(category)) {
            categoryMap[category] = [];
          }
          categoryMap[category]!.add(Map<String, dynamic>.from(product));
        }

        // Convert to the required format
        final List<Map<String, dynamic>> categories = categoryMap.entries.map((entry) {
          return {
            'name': entry.key,
            'icon': _getCategoryIcon(entry.key),
            'products': entry.value,
          };
        }).toList();

        setState(() {
          productCategories = categories;
          if (productCategories.isNotEmpty) {
            selectedCategory = productCategories[0]['name'];
            _updateFilteredProducts();
          }
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load products';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading products: $e';
        isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits & vegetables':
        return Icons.food_bank_outlined;
      case 'dairy & bakery':
        return Icons.bakery_dining;
      case 'beverages':
        return Icons.local_drink_outlined;
      case 'snacks':
        return Icons.cookie_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  void _updateFilteredProducts() {
    if (selectedCategory == null) return;

    final category = productCategories.firstWhere(
      (cat) => cat['name'] == selectedCategory,
      orElse: () => {'products': []},
    );

    setState(() {
      filteredProducts = List<Map<String, dynamic>>.from(category['products'] as List);
    });
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      _updateFilteredProducts();
      return;
    }

    setState(() {
      filteredProducts = productCategories
          .expand((category) => (category['products'] as List<dynamic>))
          .where((product) =>
              (product['name'] as String).toLowerCase().contains(query.toLowerCase()))
          .map((product) => product as Map<String, dynamic>)
          .toList();
    });
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final productId = '${product['name']}_${product['brand']}';
        final cartItem = cartProvider.items[productId];
        final isInCart = cartItem != null;
        final quantity = isInCart ? cartItem.quantity : 0;

        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Badges
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey[400]),
                            ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: ColorPalette.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Brand and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product['brand'],
                              style: TextStyle(
                                color: ColorPalette.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  '${product['rating']}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Product Name
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: ColorPalette.secondaryColor,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      // Price and Original Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              product['price'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: ColorPalette.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              product['originalPrice'],
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Add to Cart or Quantity Counter
                      if (!isInCart)
                        SizedBox(
                          height: 28,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final price = double.parse(product['price']
                                  .replaceAll(RegExp(r'[^0-9.]'), ''));
                              cartProvider.addItem(
                                productId,
                                product['name'],
                                product['brand'],
                                price,
                                product['image'],
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Added to cart!'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      cartProvider.removeItem(productId);
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.remove, size: 16),
                                  color: ColorPalette.primaryColor,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    if (quantity > 1) {
                                      cartProvider.decreaseQuantity(productId);
                                    } else {
                                      cartProvider.removeItem(productId);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.add, size: 16),
                                  color: ColorPalette.primaryColor,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => cartProvider.increaseQuantity(productId),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _filterProducts,
              )
            : Text(widget.shop['name'] as String),
        backgroundColor: ColorPalette.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isSearching ? Icons.arrow_back : Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
                _searchController.clear();
                _updateFilteredProducts();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          if (isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _updateFilteredProducts();
                });
              },
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
                        'Error Loading Products',
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
                        onPressed: _loadCategoriesAndProducts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Shop Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.shop['image'] as String? ?? 'https://via.placeholder.com/80',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.store, size: 40, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalette.primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            (widget.shop['rating'] ?? 0.0).toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main Content
                    Expanded(
                      child: Row(
                        children: [
                          // Categories List
                          Container(
                            width: 90,
                            color: Colors.grey[50],
                            child: ListView.builder(
                              itemCount: productCategories.length,
                              itemBuilder: (context, index) {
                                final category = productCategories[index];
                                final isSelected = category['name'] == selectedCategory;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category['name'] as String;
                                      _updateFilteredProducts();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Colors.white : Colors.transparent,
                                      border: Border(
                                        left: BorderSide(
                                          color: isSelected
                                              ? ColorPalette.primaryColor
                                              : Colors.transparent,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          category['icon'] as IconData,
                                          color: isSelected
                                              ? ColorPalette.primaryColor
                                              : ColorPalette.grey,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          category['name'] as String,
                                          style: TextStyle(
                                            color: isSelected
                                                ? ColorPalette.primaryColor
                                                : ColorPalette.grey,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Products Grid
                          Expanded(
                            child: filteredProducts.isEmpty
                                ? const Center(child: Text('No products found'))
                                : GridView.builder(
                                    padding: const EdgeInsets.all(16),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.58,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      return _buildProductCard(filteredProducts[index]);
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}