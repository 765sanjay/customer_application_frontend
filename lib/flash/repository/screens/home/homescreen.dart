import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/widgets/uihelper.dart';
import 'package:flutter/material.dart';
import 'package:sklyit/flash/repository/app_header.dart';
import 'package:sklyit/flash/repository/screens/category/categoryscreen.dart';
import 'package:sklyit/flash/repository/screens/category/productpage.dart';
import 'package:sklyit/flash/repository/screens/profile/profilepage.dart';
import 'package:sklyit/flash/repository/screens/bottomnav/bottomnavscreen.dart';

import '../../providers/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  int _selectedIndex = 0; // Set to 0 since this is the home tab

  // Color palette
  final Color primaryColor = Color(0xFF009085);
  final Color secondaryColor = Color(0xFF2F4858);
  final Color accentColor = Color(0xFFF6C445);
  final Color darkAccent = Color(0xFF006B7C);
  final Color lightAccent = Color(0xFFFDD90D);

  var data = [
    {"img": "image 50.png", "text": "Lights, Diyas \n & Candles"},
    {"img": "image 51.png", "text": "Diwali \n Gifts"},
    {"img": "image 52.png", "text": "Appliances  \n & Gadgets"},
    {"img": "image 53.png", "text": "Home \n & Living"}
  ];

  var category = [
    {"img": "image 54.png", "text": "Golden Glass\n Wooden Lid Candle (Oudh)", "price": "₹79", "time": "8 MINS"},
    {"img": "image 57.png", "text": "Royal Gulab Jamun\n By Bikano", "price": "₹129", "time": "10 MINS"},
    {"img": "image 63.png", "text": "Premium Dry Fruits\n Pack", "price": "₹349", "time": "15 MINS"},
  ];

  var grocerykitchen = [
    {"img": "image 41.png", "text": "Vegetables & \nFruits", "color": Color(0xFFF6C445)},
    {"img": "image 42.png", "text": "Atta, Dal & \nRice", "color": Color(0xFF009085)},
    {"img": "image 43.png", "text": "Oil, Ghee & \nMasala", "color": Color(0xFF2F4858)},
    {"img": "image 44.png", "text": "Dairy, Bread & \nMilk", "color": Color(0xFF006B7C)},
    {"img": "image 45.png", "text": "Biscuits & \nBakery", "color": Color(0xFFFDD90D)}
  ];

  get defaultLatitude => null;

  get defaultLongitude => null;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(searchController: searchController, onSearchStateChanged: (bool ) {  },),


            // Image Section
            GestureDetector(
              onTap: () {
                _navigateToProducts(context, "Icecreams and More");
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset(
                  "assets/images/icecream.jpeg", // Replace with your image path
                  width: screenWidth,
                  height: screenHeight * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),


            // Categories Section
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: UiHelper.CustomText(
                      text: "Shop by Category",
                      color: secondaryColor,
                      fontweight: FontWeight.bold,
                      fontsize: 18,
                      fontfamily: "bold",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavScreen(
                            initialIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: UiHelper.CustomText(
                      text: "See all",
                      color: primaryColor,
                      fontweight: FontWeight.bold,
                      fontsize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.20,
              margin: EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: grocerykitchen.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToProducts(context, (grocerykitchen[index]["text"] as String).replaceAll("\n", " "));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: screenHeight * 0.12,
                            width: screenWidth * 0.24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.transparent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 60,
                                width: 60,
                                child: UiHelper.CustomImage(
                                  img: grocerykitchen[index]["img"].toString(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: screenWidth * 0.24,
                            height: screenHeight * 0.045,
                            child: Center(
                              child: UiHelper.CustomText(
                                text: grocerykitchen[index]["text"].toString(),
                                color: secondaryColor,
                                fontweight: FontWeight.w600,
                                fontsize: 11,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),



            // Featured Products Section
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: UiHelper.CustomText(
                      text: "Featured Products",
                      color: secondaryColor,
                      fontweight: FontWeight.bold,
                      fontsize: 18,
                      fontfamily: "bold",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavScreen(
                            initialIndex: 3,
                          ),
                        ),
                      );
                    },
                    child: UiHelper.CustomText(
                      text: "See all",
                      color: primaryColor,
                      fontweight: FontWeight.bold,
                      fontsize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight * 0.35, // Slightly increased height
              margin: EdgeInsets.only(bottom: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15),
                itemCount: category.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: screenWidth * 0.4, // Increased width for better spacing
                    margin: EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          child: Container(
                            height: screenHeight * 0.15,
                            color: Colors.grey[100],
                            child: Center(
                              child: SizedBox(
                                height: 70,
                                child: UiHelper.CustomImage(
                                  img: category[index]["img"].toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: UiHelper.CustomText(
                                    text: category[index]["text"].toString(),
                                    color: secondaryColor,
                                    fontweight: FontWeight.w600,
                                    fontsize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 14, color: primaryColor),
                                    SizedBox(width: 4),
                                    UiHelper.CustomText(
                                      text: category[index]["time"].toString(),
                                      color: primaryColor,
                                      fontweight: FontWeight.w500,
                                      fontsize: 11,
                                    ),
                                  ],
                                ),
                                UiHelper.CustomText(
                                  text: category[index]["price"].toString(),
                                  color: primaryColor,
                                  fontweight: FontWeight.bold,
                                  fontsize: 14,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: UiHelper.CustomText(
                                      text: "Add to Cart",
                                      color: secondaryColor,
                                      fontweight: FontWeight.bold,
                                      fontsize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),



            // Special Offers Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                height: screenHeight * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [accentColor, lightAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UiHelper.CustomText(
                            text: "Special Offer",
                            color: secondaryColor,
                            fontweight: FontWeight.bold,
                            fontsize: 18,
                          ),
                          UiHelper.CustomText(
                            text: "20% OFF on first order",
                            color: secondaryColor,
                            fontweight: FontWeight.w500,
                            fontsize: 14,
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: UiHelper.CustomText(
                              text: "GRAB NOW",
                              color: Colors.white,
                              fontweight: FontWeight.bold,
                              fontsize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 0,
                      child: Image.asset(
                        "assets/images/grocery_bag.png",
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressDropdown(BuildContext context, ProfileProvider profileProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: profileProvider.savedAddresses.length,
          itemBuilder: (context, index) {
            final address = profileProvider.savedAddresses[index];
            return ListTile(
              title: Text(address),
              onTap: () {
                profileProvider.updateSelectedAddress(address);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _navigateToProducts(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          category: category,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
          accentColor: accentColor,
          darkAccent: darkAccent,
          lightAccent: lightAccent, subcategories: [], businessId: '', latitude: defaultLatitude, longitude: defaultLongitude,
        ),
      ),
    );
  }
}