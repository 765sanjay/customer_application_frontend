import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sklyit/flash/repository/app_header.dart';
import 'package:sklyit/flash/pages/market_product_page.dart';

class MarkatHome extends StatefulWidget {
  @override
  _MarkatHomeState createState() => _MarkatHomeState();
}

class _MarkatHomeState extends State<MarkatHome> {
  TextEditingController searchController = TextEditingController();

  // Color palette (using existing app colors)
  final Color primaryColor = Color(0xFF009085);    // Teal
  final Color secondaryColor = Color(0xFF2F4858);  // Dark blue
  final Color accentColor = Color(0xFFF6C445);     // Gold
  final Color darkAccent = Color(0xFF006B7C);      // Dark teal
  final Color lightAccent = Color(0xFFFDD90D);     // Bright yellow

  // Sample local shops data
  final List<Map<String, dynamic>> localShops = [
    {
      'name': 'Fresh Grocery Store',
      'rating': 4.5,
      'distance': '0.5 km',
      'image': 'assets/images/shop1.png',
      'category': 'Grocery',
      'openTime': '8:00 AM',
      'closeTime': '10:00 PM'
    },
    {
      'name': 'Daily Needs Mart',
      'rating': 4.2,
      'distance': '0.8 km',
      'image': 'assets/images/shop2.png',
      'category': 'General Store',
      'openTime': '7:00 AM',
      'closeTime': '9:00 PM'
    },
    {
      'name': 'Organic Corner',
      'rating': 4.7,
      'distance': '1.2 km',
      'image': 'assets/images/shop3.png',
      'category': 'Organic Store',
      'openTime': '9:00 AM',
      'closeTime': '8:00 PM'
    },
  ];

  // Sample today's offers
  final List<Map<String, dynamic>> todaysOffers = [
    {
      'title': 'Weekend Special',
      'description': 'Get 20% off on all groceries',
      'validUntil': 'Today 11:59 PM',
      'image': 'assets/images/offer1.png',
    },
    {
      'title': 'First Order Bonus',
      'description': 'Free delivery on first order',
      'validUntil': 'Valid for new users',
      'image': 'assets/images/offer2.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Using existing AppHeader
          AppHeader(searchController: searchController, onSearchStateChanged: (bool ) {  },),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Offers Section
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Offers",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 180,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: todaysOffers.length,
                            itemBuilder: (context, index) {
                              final offer = todaysOffers[index];
                              return _buildOfferCard(offer);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Local Shops Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shops Near You',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: localShops.length,
                          itemBuilder: (context, index) {
                            final shop = localShops[index];
                            return _buildShopCard(shop);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> offer) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, darkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              offer['title'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              offer['description'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            Text(
              offer['validUntil'],
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopCard(Map<String, dynamic> shop) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Shop Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(shop['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            // Shop Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: accentColor, size: 16),
                      SizedBox(width: 4),
                      Text(
                        shop['rating'].toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Text(
                        shop['distance'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${shop['category']} • ${shop['openTime']} - ${shop['closeTime']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Visit Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarketProductPage(
                      shop: {
                        'name': shop['name'],
                        'image': shop['image'],
                        'rating': shop['rating'],
                        'deliveryTime': '15-20 min',
                        'minOrder': '₹100',
                        'deliveryFee': '₹30',
                      },
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'VISIT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}