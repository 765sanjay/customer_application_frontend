import 'package:flutter/material.dart';
import '../repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/cart_provider.dart';

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
  bool isSearching = false;

  // Sample product categories for the shop
  final List<Map<String, dynamic>> productCategories = [
    {
      'name': 'Fruits & Vegetables',
      'icon': Icons.food_bank_outlined,
      'products': [
        {
          'name': 'Fresh Fruits',
          'brand': 'Farm Fresh',
          'price': '₹299/kg',
          'originalPrice': '₹350/kg',
          'discount': '15% OFF',
          'rating': 4.5,
          'reviews': 128,
          'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500',
          'delivery': 'Today by 8 PM'
        },
        {
          'name': 'Vegetables Pack',
          'brand': 'Organic Farms',
          'price': '₹199/kg',
          'originalPrice': '₹250/kg',
          'discount': '20% OFF',
          'rating': 4.2,
          'reviews': 95,
          'image': 'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=500',
          'delivery': 'Today by 8 PM'
        },
      ]
    },
    {
      'name': 'Dairy & Bakery',
      'icon': Icons.bakery_dining,
      'products': [
        {
          'name': 'Fresh Bread',
          'brand': 'Bakery Fresh',
          'price': '₹99/pack',
          'originalPrice': '₹120/pack',
          'discount': '18% OFF',
          'rating': 4.7,
          'reviews': 342,
          'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500',
          'delivery': 'Today by 8 PM'
        },
        {
          'name': 'Milk 1L',
          'brand': 'Amul',
          'price': '₹60/liter',
          'originalPrice': '₹65/liter',
          'discount': '8% OFF',
          'rating': 4.6,
          'reviews': 215,
          'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=500',
          'delivery': 'Today by 8 PM'
        },
      ]
    },
    {
      'name': 'Beverages',
      'icon': Icons.local_drink_outlined,
      'products': [
        {
          'name': 'Soft Drinks',
          'brand': 'Coca Cola',
          'price': '₹60/pack',
          'originalPrice': '₹75/pack',
          'discount': '20% OFF',
          'rating': 4.3,
          'reviews': 156,
          'image': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500',
          'delivery': 'Today by 8 PM'
        },
        {
          'name': 'Energy Drinks',
          'brand': 'Red Bull',
          'price': '₹120/pack',
          'originalPrice': '₹150/pack',
          'discount': '20% OFF',
          'rating': 4.4,
          'reviews': 189,
          'image': 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500',
          'delivery': 'Today by 8 PM'
        },
      ]
    },
    {
      'name': 'Snacks',
      'icon': Icons.cookie_outlined,
      'products': [
        {
          'name': 'Potato Chips',
          'brand': 'Lay\'s',
          'price': '₹20/pack',
          'originalPrice': '₹25/pack',
          'discount': '20% OFF',
          'rating': 4.5,
          'reviews': 423,
          'image': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500',
          'delivery': 'Today by 8 PM'
        },
        {
          'name': 'Chocolate Bar',
          'brand': 'Cadbury',
          'price': '₹50/pack',
          'originalPrice': '₹60/pack',
          'discount': '17% OFF',
          'rating': 4.6,
          'reviews': 287,
          'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=500',
          'delivery': 'Today by 8 PM'
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = productCategories[0]['name'];
    _updateFilteredProducts();
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
      body: Column(
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