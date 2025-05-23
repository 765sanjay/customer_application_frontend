import 'package:flutter/material.dart';
import '../widgets/BusinessCard.dart';

class GymServicePage extends StatefulWidget {
  const GymServicePage({super.key});

  @override
  State<GymServicePage> createState() => _GymServicePageState();
}

class _GymServicePageState extends State<GymServicePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> bannerImages = [
    "https://images.unsplash.com/photo-1571019613914-85f342c1d35c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
  ];

  final List<Map<String, dynamic>> gymShops = [
    {
      "category": "PREMIUM",
      "tags": ["Top Rated", "Verified"],
      "shopName": "Muscle Factory",
      "rating": 4.9,
      "ratingCount": 321,
      "address": "Anna Nagar",
      "description": "Advanced training & body transformation programs",
      "showPrice": true,
      "imageUrl":
          "https://images.unsplash.com/photo-1583454110551-21f563c1d8db?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    },
    {
      "category": "TOP",
      "tags": ["Popular"],
      "shopName": "FitZone Gym",
      "rating": 4.7,
      "ratingCount": 289,
      "address": "T. Nagar",
      "description": "Cardio, weights & crossfit",
      "showPrice": true,
      "imageUrl":
          "https://images.unsplash.com/photo-1583454110651-21f563c1d8db?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    },
    {
      "category": "NEW",
      "tags": ["Verified"],
      "shopName": "Iron Paradise",
      "rating": 4.5,
      "ratingCount": 165,
      "address": "Velachery",
      "description": "24x7 access & personal training",
      "showPrice": false,
      "imageUrl":
          "https://images.unsplash.com/photo-1579758629938-03607ccdbaba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym Services"),
        backgroundColor: const Color(0xFF009085),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              height: 180,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: bannerImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(bannerImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.6),
                                Colors.transparent
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Top Gyms in Chennai",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Row(
                      children: List.generate(bannerImages.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: gymShops
                    .map(
                      (shop) => BusinessCard(
                        category: shop['category'] as String,
                        tags: (shop['tags'] as List).cast<String>(),
                        businessName: shop['shopName'] as String,
                        rating: shop['rating'] as double,
                        ratingCount: shop['ratingCount'] as int,
                        location: shop['address'] as String,
                        description: shop['description'] as String,
                        showPrice: shop['showPrice'] as bool,
                        imageUrl: shop['imageUrl'] as String,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
