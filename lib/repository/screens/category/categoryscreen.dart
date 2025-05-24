import 'package:flutter/material.dart';
import "../category/productpage.dart";

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  String searchQuery = '';
  bool isSearching = false;

  // Color palette
  final Color primaryColor = Color(0xFF009085);       // Teal
  final Color secondaryColor = Color(0xFF2F4858);     // Dark blue
  final Color accentColor = Color(0xFFF6C445);        // Yellow
  final Color darkAccent = Color(0xFF006B7C);         // Dark teal
  final Color lightAccent = Color(0xFFFDD90D);        // Light yellow

  // Categories for the top navigation bar
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.all_inclusive, 'label': 'All'},
    {'icon': Icons.kitchen, 'label': 'Grocery & Kitchen'},
    {'icon': Icons.local_dining, 'label': 'Snacks & Drinks'},
    {'icon': Icons.spa, 'label': 'Beauty & Personal Care'},
    {'icon': Icons.devices, 'label': 'Electronics & Accessories'},
  ];

  // Sub-categories data
  final Map<String, List<Map<String, String>>> categoryData = {
    'Grocery & Kitchen': [
      {"name": "Fruits & Vegetables", "img": "assets/images/image 41.png"},
      {"name": "Dairy, Bread & Eggs", "img": "assets/images/dairy_category.jpeg"},
      {"name": "Atta, Rice, Oil & Dals", "img": "assets/images/image 43.png"},
      {"name": "Meat, Fish & Eggs", "img": "assets/images/meat_fish.jpeg"},
      {"name": "Masala & Dry Fruits", "img": "assets/images/masalas.jpeg"},
    ],
    'Snacks & Drinks': [
      {"name": "Tea, Coffee & More", "img": "assets/images/tea_coffee.jpeg"},
      {"name": "Packaged Food", "img": "assets/images/packed_food.jpeg"},
      {"name": "Ice Creams & More", "img": "assets/images/image 24.png"},
      {"name": "Frozen Food", "img": "assets/images/frozen_foods.jpeg"},
      {"name": "Sweet Cravings", "img": "assets/images/image 32.png"},
      {"name": "Cold Drinks & Juices", "img": "assets/images/fruit_juices.jpeg"},
      {"name": "Munchies", "img": "assets/images/image 31.png"},
      {"name": "Biscuits & Cookies", "img": "assets/images/biscuits.jpeg"},
    ],
    'Beauty & Personal Care': [
      {"name": "Skincare", "img": "assets/images/skincare.jpeg"},
      {"name": "Haircare", "img": "assets/images/haircare.jpeg"},
      {"name": "Makeup", "img": "assets/images/makeup.jpeg"},
      {"name": "Personal Care", "img": "assets/images/persnal_care.jpeg"},
      {"name": "Perfumes", "img": "assets/images/perfumes.jpeg"},
    ],
    'Electronics & Accessories': [
      {"name": "Headphones", "img": "assets/images/Wired_Earphones.jpg"},
      {"name": "Lights & electricals", "img": "assets/images/Lights.jpg"},
      {"name": "Battery", "img": "assets/images/batteries.png"},
    ],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            child: isSearching
                ? Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search categories...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[600]),
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                              searchController.clear();
                              searchQuery = '';
                            });
                          },
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  )
                : Row(
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.search, color: secondaryColor),
                        onPressed: () {
                          setState(() {
                            isSearching = true;
                          });
                        },
                      ),
                    ],
                  ),
          ),

          // Category Navigation Bar
          _buildCategoryNavBar(),

          // Main Content
          Expanded(
            child: searchQuery.isEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCategorySection("Grocery & Kitchen"),
                        _buildCategorySection("Snacks & Drinks"),
                        _buildCategorySection("Beauty & Personal Care"),
                        _buildCategorySection("Electronics & Accessories"),
                      ],
                    ),
                  )
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedCategory == categories[index]['label'];
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
            builder: (context, double value, child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index]['label'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        Colors.white,
                        primaryColor.withOpacity(0.1),
                        value,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.lerp(
                          Colors.transparent,
                          primaryColor,
                          value,
                        )!,
                        width: 1.5,
                      ),
                    ),
                    child: Transform.scale(
                      scale: 1 + (value * 0.1),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            Colors.grey[50],
                            primaryColor,
                            value,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2 * value),
                              blurRadius: 8 * value,
                              spreadRadius: 2 * value,
                            ),
                          ],
                        ),
                        child: Icon(
                          categories[index]['icon'],
                          color: Color.lerp(
                            Colors.grey[600],
                            Colors.white,
                            value,
                          ),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(String title) {
    if (!categoryData.containsKey(title)) return SizedBox();

    if (selectedCategory != 'All' && selectedCategory != title) {
      return SizedBox();
    }

    final filteredItems = categoryData[title]!.where((item) {
      return item['name']!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredItems.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.85,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return GestureDetector(
              onTap: () {
                _navigateToProducts(item['name']!);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: item['img'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item['img']!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Icon(Icons.category, color: primaryColor, size: 40),
                  ),
                  SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      item['name']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    List<Map<String, String>> allItems = [];

    // Collect all items that match the search query
    categoryData.forEach((category, items) {
      if (selectedCategory == 'All' || selectedCategory == category) {
        allItems.addAll(items.where((item) =>
            item['name']!.toLowerCase().contains(searchQuery.toLowerCase())));
      }
    });

    if (allItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        return GestureDetector(
          onTap: () => _navigateToProducts(item['name']!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item['img']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                child: Text(
                  item['name']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 11,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToProducts(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          category: category,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          accentColor: accentColor,
          darkAccent: darkAccent,
          lightAccent: lightAccent, subcategories: [],
        ),
      ),
    );
  }
}