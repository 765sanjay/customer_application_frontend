import 'package:flutter/material.dart';
import '../repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/widgets/custom_app_bar.dart';
import 'market_product_page.dart';

class MarketCategoryPage extends StatefulWidget {
  const MarketCategoryPage({Key? key}) : super(key: key);

  @override
  State<MarketCategoryPage> createState() => _MarketCategoryPageState();
}

class _MarketCategoryPageState extends State<MarketCategoryPage> {
  final List<Map<String, dynamic>> shopCategories = [
    {
      'name': 'Grocery & Supermarkets',
      'icon': Icons.shopping_basket,
      'subcategories': ['Fresh Produce', 'Dairy & Bakery', 'Household Items'],
      'shops': [
        {
          'name': 'Big Bazaar',
          'image': 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=500',
          'rating': 4.5,
          'deliveryTime': '15-20 min',
          'minOrder': '₹200',
          'deliveryFee': '₹40',
          'isOpen': true,
          'subcategory': 'Hypermarket',
          'products': [
            {'name': 'Fresh Fruits', 'price': 299, 'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500'},
            {'name': 'Vegetables Pack', 'price': 199, 'image': 'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=500'},
          ]
        },
        {
          'name': 'Reliance Fresh',
          'image': 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=500',
          'rating': 4.3,
          'deliveryTime': '20-25 min',
          'minOrder': '₹150',
          'deliveryFee': '₹30',
          'isOpen': true,
          'subcategory': 'General Store',
          'products': [
            {'name': 'Organic Fruits', 'price': 399, 'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=500'},
            {'name': 'Fresh Vegetables', 'price': 249, 'image': 'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Clothing & Apparel',
      'icon': Icons.checkroom,
      'subcategories': ['Men\'s Fashion', 'Women\'s Fashion', 'Kids\' Fashion'],
      'shops': [
        {
          'name': 'Fashion Hub',
          'image': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=500',
          'rating': 4.6,
          'deliveryTime': '30-40 min',
          'minOrder': '₹500',
          'deliveryFee': '₹50',
          'isOpen': true,
          'subcategory': 'Fashion',
          'products': [
            {'name': 'Summer Collection', 'price': 999, 'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=500'},
            {'name': 'Winter Wear', 'price': 1499, 'image': 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=500'},
          ]
        },
        {
          'name': 'Shoe Paradise',
          'image': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
          'rating': 4.4,
          'deliveryTime': '25-35 min',
          'minOrder': '₹800',
          'deliveryFee': '₹40',
          'isOpen': true,
          'subcategory': 'Footwear',
          'products': [
            {'name': 'Sports Shoes', 'price': 1299, 'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500'},
            {'name': 'Formal Shoes', 'price': 899, 'image': 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices,
      'subcategories': ['Smartphones', 'Laptops & Computers', 'Home Appliances'],
      'shops': [
        {
          'name': 'Tech World',
          'image': 'https://images.unsplash.com/photo-1550009158-9ebf69173e03?w=500',
          'rating': 4.7,
          'deliveryTime': '45-60 min',
          'minOrder': '₹1000',
          'deliveryFee': '₹60',
          'isOpen': true,
          'subcategory': 'Gadgets',
          'products': [
            {'name': 'Wireless Earbuds', 'price': 2499, 'image': 'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=500'},
            {'name': 'Smart Watch', 'price': 3999, 'image': 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500'},
          ]
        },
        {
          'name': 'Mobile Zone',
          'image': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
          'rating': 4.5,
          'deliveryTime': '40-55 min',
          'minOrder': '₹1500',
          'deliveryFee': '₹50',
          'isOpen': true,
          'subcategory': 'Mobile Phones',
          'products': [
            {'name': 'Latest Smartphone', 'price': 15999, 'image': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500'},
            {'name': 'Phone Accessories', 'price': 499, 'image': 'https://images.unsplash.com/photo-1601780269205-85b6cb0618e1?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Furniture & Home',
      'icon': Icons.chair,
      'subcategories': ['Living Room', 'Bedroom', 'Kitchen & Dining'],
      'shops': [
        {
          'name': 'Home Comfort',
          'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500',
          'rating': 4.6,
          'deliveryTime': '2-3 days',
          'minOrder': '₹2000',
          'deliveryFee': '₹200',
          'isOpen': true,
          'subcategory': 'Sofas',
          'products': [
            {'name': '3-Seater Sofa', 'price': 24999, 'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=500'},
            {'name': 'Coffee Table', 'price': 4999, 'image': 'https://images.unsplash.com/photo-1532372320572-cda25653a26f?w=500'},
          ]
        },
        {
          'name': 'Decor Delight',
          'image': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=500',
          'rating': 4.4,
          'deliveryTime': '1-2 days',
          'minOrder': '₹1000',
          'deliveryFee': '₹100',
          'isOpen': true,
          'subcategory': 'Home Decor',
          'products': [
            {'name': 'Curtain Set', 'price': 1999, 'image': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=500'},
            {'name': 'Wall Art', 'price': 1499, 'image': 'https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Pharmacy',
      'icon': Icons.local_pharmacy,
      'subcategories': ['Prescription Drugs', 'Over-the-Counter', 'Health Supplements'],
      'shops': [
        {
          'name': 'Health Plus',
          'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500',
          'rating': 4.8,
          'deliveryTime': '20-30 min',
          'minOrder': '₹100',
          'deliveryFee': '₹30',
          'isOpen': true,
          'subcategory': 'Medicines',
          'products': [
            {'name': 'Prescription Medicines', 'price': 299, 'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500'},
            {'name': 'First Aid Kit', 'price': 499, 'image': 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=500'},
          ]
        },
        {
          'name': 'Wellness Store',
          'image': 'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=500',
          'rating': 4.5,
          'deliveryTime': '25-35 min',
          'minOrder': '₹200',
          'deliveryFee': '₹40',
          'isOpen': true,
          'subcategory': 'Health Products',
          'products': [
            {'name': 'Vitamins', 'price': 399, 'image': 'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=500'},
            {'name': 'Protein Supplements', 'price': 1299, 'image': 'https://images.unsplash.com/photo-1579722821273-0f6c7d44363f?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Books & Stationery',
      'icon': Icons.menu_book,
      'subcategories': ['Fiction Books', 'Academic Books', 'Office Supplies'],
      'shops': [
        {
          'name': 'Book Haven',
          'image': 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=500',
          'rating': 4.7,
          'deliveryTime': '1-2 days',
          'minOrder': '₹300',
          'deliveryFee': '₹50',
          'isOpen': true,
          'subcategory': 'Books',
          'products': [
            {'name': 'Best Sellers', 'price': 499, 'image': 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=500'},
            {'name': 'Academic Books', 'price': 699, 'image': 'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=500'},
          ]
        },
        {
          'name': 'Stationery World',
          'image': 'https://images.unsplash.com/photo-1583485088034-697b5bc36b60?w=500',
          'rating': 4.4,
          'deliveryTime': '1-2 days',
          'minOrder': '₹200',
          'deliveryFee': '₹40',
          'isOpen': true,
          'subcategory': 'Stationery',
          'products': [
            {'name': 'Premium Notebooks', 'price': 299, 'image': 'https://images.unsplash.com/photo-1583485088034-697b5bc36b60?w=500'},
            {'name': 'Art Supplies Set', 'price': 599, 'image': 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Toys & Games',
      'icon': Icons.toys,
      'subcategories': ['Educational Toys', 'Outdoor Toys', 'Board Games'],
      'shops': [
        {
          'name': 'Toy Land',
          'image': 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=500',
          'rating': 4.6,
          'deliveryTime': '1-2 days',
          'minOrder': '₹500',
          'deliveryFee': '₹60',
          'isOpen': true,
          'subcategory': 'Children Toys',
          'products': [
            {'name': 'Building Blocks', 'price': 799, 'image': 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=500'},
            {'name': 'Plush Toys', 'price': 499, 'image': 'https://images.unsplash.com/photo-1562040506-a9b32cb51b94?w=500'},
          ]
        },
        {
          'name': 'Brain Games',
          'image': 'https://images.unsplash.com/photo-1611996575749-79a3a250f948?w=500',
          'rating': 4.5,
          'deliveryTime': '1-2 days',
          'minOrder': '₹400',
          'deliveryFee': '₹50',
          'isOpen': true,
          'subcategory': 'Educational Games',
          'products': [
            {'name': 'Puzzle Set', 'price': 599, 'image': 'https://images.unsplash.com/photo-1611996575749-79a3a250f948?w=500'},
            {'name': 'Science Kit', 'price': 899, 'image': 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Hardware',
      'icon': Icons.handyman,
      'subcategories': ['Power Tools', 'Hand Tools', 'Building Materials'],
      'shops': [
        {
          'name': 'Tool Master',
          'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500',
          'rating': 4.5,
          'deliveryTime': '1-2 days',
          'minOrder': '₹1000',
          'deliveryFee': '₹80',
          'isOpen': true,
          'subcategory': 'Tools',
          'products': [
            {'name': 'Tool Kit', 'price': 2499, 'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500'},
            {'name': 'Power Drill', 'price': 3999, 'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500'},
          ]
        },
        {
          'name': 'Build Smart',
          'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500',
          'rating': 4.4,
          'deliveryTime': '1-2 days',
          'minOrder': '₹800',
          'deliveryFee': '₹70',
          'isOpen': true,
          'subcategory': 'Construction',
          'products': [
            {'name': 'Safety Equipment', 'price': 1499, 'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500'},
            {'name': 'Building Materials', 'price': 2999, 'image': 'https://images.unsplash.com/photo-1581147036325-79a81a9c6a84?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Jewelry',
      'icon': Icons.diamond,
      'subcategories': ['Gold Jewelry', 'Diamond Jewelry', 'Fashion Jewelry'],
      'shops': [
        {
          'name': 'Gold Palace',
          'image': 'https://images.unsplash.com/photo-1515405295579-ba7b45403062?w=500',
          'rating': 4.8,
          'deliveryTime': '1-2 days',
          'minOrder': '₹5000',
          'deliveryFee': '₹100',
          'isOpen': true,
          'subcategory': 'Gold',
          'products': [
            {'name': 'Gold Necklace', 'price': 49999, 'image': 'https://images.unsplash.com/photo-1515405295579-ba7b45403062?w=500'},
            {'name': 'Gold Earrings', 'price': 19999, 'image': 'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=500'},
          ]
        },
        {
          'name': 'Diamond World',
          'image': 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=500',
          'rating': 4.7,
          'deliveryTime': '1-2 days',
          'minOrder': '₹10000',
          'deliveryFee': '₹150',
          'isOpen': true,
          'subcategory': 'Diamonds',
          'products': [
            {'name': 'Diamond Ring', 'price': 99999, 'image': 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=500'},
            {'name': 'Diamond Pendant', 'price': 49999, 'image': 'https://images.unsplash.com/photo-1602751584552-8ba73aad10e1?w=500'},
          ]
        },
      ]
    },
    {
      'name': 'Beauty & Cosmetics',
      'icon': Icons.face,
      'subcategories': ['Makeup', 'Skincare', 'Hair Care'],
      'shops': [
        {
          'name': 'Beauty Bliss',
          'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500',
          'rating': 4.6,
          'deliveryTime': '1-2 days',
          'minOrder': '₹500',
          'deliveryFee': '₹50',
          'isOpen': true,
          'subcategory': 'Makeup',
          'products': [
            {'name': 'Makeup Kit', 'price': 1999, 'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=500'},
            {'name': 'Lipstick Set', 'price': 799, 'image': 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=500'},
          ]
        },
        {
          'name': 'Skin Care',
          'image': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=500',
          'rating': 4.5,
          'deliveryTime': '1-2 days',
          'minOrder': '₹400',
          'deliveryFee': '₹40',
          'isOpen': true,
          'subcategory': 'Skincare',
          'products': [
            {'name': 'Face Cream', 'price': 599, 'image': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=500'},
            {'name': 'Serum Set', 'price': 899, 'image': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=500'},
          ]
        },
      ]
    },
  ];

  String? selectedCategory;
  String? selectedSubcategory;
  Map<String, dynamic>? selectedShop;
  String selectedLocation = 'Current Location'; // Default location
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  // Sample locations for demonstration
  final List<Map<String, dynamic>> locations = [
    {
      'name': 'Current Location',
      'address': 'Using device location',
      'isCurrent': true,
    },
    {
      'name': 'Home',
      'address': '123 Main Street, City',
      'isCurrent': false,
    },
    {
      'name': 'Office',
      'address': '456 Business Park, City',
      'isCurrent': false,
    },
    {
      'name': 'Gym',
      'address': '789 Fitness Center, City',
      'isCurrent': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _showLocationSelectionDialog() {
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
                const Text(
                  'Select Delivery Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for area, street name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // Location list
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations[index];
                      return ListTile(
                        leading: Icon(
                          location['isCurrent'] ? Icons.my_location : Icons.location_on,
                          color: ColorPalette.primaryColor,
                        ),
                        title: Text(
                          location['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(location['address']),
                        onTap: () {
                          setState(() {
                            selectedLocation = location['name'];
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Add new location button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement add new location functionality
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add_location),
                    label: const Text('Add New Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  // Get all shops from all categories
  List<Map<String, dynamic>> getAllShops() {
    List<Map<String, dynamic>> allShops = [];
    for (var category in shopCategories) {
      allShops.addAll(category['shops']);
    }
    return allShops;
  }

  // Get filtered shops based on selected category, subcategory, and search query
  List<Map<String, dynamic>> getFilteredShops() {
    List<Map<String, dynamic>> shops;
    
    if (selectedCategory == null) {
      shops = getAllShops();
    } else {
      final category = shopCategories.firstWhere((cat) => cat['name'] == selectedCategory);
      shops = category['shops'] as List<Map<String, dynamic>>;

      if (selectedSubcategory != null) {
        shops = shops.where((shop) {
          final shopSubcategory = shop['subcategory'] ?? category['subcategories'][0];
          return shopSubcategory == selectedSubcategory;
        }).toList();
      }
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      shops = shops.where((shop) {
        final shopName = shop['name'].toString().toLowerCase();
        final shopProducts = (shop['products'] as List).map((p) => p['name'].toString().toLowerCase()).toList();
        
        return shopName.contains(_searchQuery) || 
               shopProducts.any((product) => product.contains(_searchQuery));
      }).toList();
    }

    return shops;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Market Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette.secondaryColor,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.search, color: ColorPalette.secondaryColor),
                      onPressed: () {
                        setState(() {
                          _isSearching = !_isSearching;
                        });
                      },
                    ),
                  ],
                ),
                if (_isSearching) ...[
                  SizedBox(height: 8),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search shops and categories...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Location and Delivery Time
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showLocationSelectionDialog,
                  child: const Icon(Icons.location_on, color: ColorPalette.primaryColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _showLocationSelectionDialog,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Deliver to',
                          style: TextStyle(
                            color: ColorPalette.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          selectedLocation,
                          style: const TextStyle(
                            color: ColorPalette.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category Selection
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shopCategories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = null;
                        selectedSubcategory = null;
                        selectedShop = null;
                      });
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedCategory == null
                            ? ColorPalette.primaryColor
                            : ColorPalette.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorPalette.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.store,
                            color: selectedCategory == null
                                ? ColorPalette.white
                                : ColorPalette.primaryColor,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'All Shops',
                            style: TextStyle(
                              color: selectedCategory == null
                                  ? ColorPalette.white
                                  : ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final category = shopCategories[index - 1];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category['name'];
                      selectedSubcategory = null;
                      selectedShop = null;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedCategory == category['name']
                          ? ColorPalette.primaryColor
                          : ColorPalette.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorPalette.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'],
                          color: selectedCategory == category['name']
                              ? ColorPalette.white
                              : ColorPalette.primaryColor,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            color: selectedCategory == category['name']
                                ? ColorPalette.white
                                : ColorPalette.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Subcategory Selection
          if (selectedCategory != null)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shopCategories
                    .firstWhere((cat) => cat['name'] == selectedCategory)['subcategories']
                    .length,
                itemBuilder: (context, index) {
                  final subcategory = shopCategories
                      .firstWhere((cat) => cat['name'] == selectedCategory)['subcategories'][index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubcategory = subcategory;
                        selectedShop = null;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selectedSubcategory == subcategory
                            ? ColorPalette.secondaryColor
                            : ColorPalette.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorPalette.secondaryColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          subcategory,
                          style: TextStyle(
                            color: selectedSubcategory == subcategory
                                ? ColorPalette.white
                                : ColorPalette.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Shops List
          Expanded(
            child: getFilteredShops().isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: ColorPalette.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No shops found',
                          style: TextStyle(
                            fontSize: 18,
                            color: ColorPalette.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try different search terms or categories',
                          style: TextStyle(
                            color: ColorPalette.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: getFilteredShops().length,
                    itemBuilder: (context, index) {
                      final shop = getFilteredShops()[index];
                      return GestureDetector(
                        onTap: () {
                          // Get the shop's category
                          final shopCategory = selectedCategory ?? 'Grocery & Supermarkets';
                          
                          // Create a new shop map with the category type
                          final shopWithType = Map<String, dynamic>.from(shop);
                          shopWithType['type'] = shopCategory;
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MarketProductPage(
                                shop: shopWithType,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Shop Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  shop['image'],
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          shop['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                                shop['rating'].toString(),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 