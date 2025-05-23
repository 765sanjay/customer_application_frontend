import 'package:flutter/material.dart';
import '../widgets/BusinessCard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Services',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SalonServicePage(),
    );
  }
}

class SalonServicePage extends StatefulWidget {
  const SalonServicePage({super.key});

  @override
  State<SalonServicePage> createState() => _SalonServicePageState();
}

class _SalonServicePageState extends State<SalonServicePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> bannerImages = [
    "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1887&q=80",
    "https://images.unsplash.com/photo-1619983081563-430f63602748?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    "https://images.unsplash.com/photo-1571902943202-507ec2618e8c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
  ];

  final List<Map<String, dynamic>> salonShops = [
    {
      "category": "PREMIUM",
      "tags": ["Trending", "Verified"],
      "shopName": "Luxe Hair Studio",
      "rating": 4.8,
      "ratingCount": 245,
      "address": "Anna Nagar",
      "description": "Professional hair treatments & keratin specialists",
      "showPrice": true,
      "imageUrl":
          "https://images.unsplash.com/photo-1595476108010-b4d1f102b1b1?ixlib=rb-4.0.3&auto=format&fit=crop&w=686&q=80",
    },
    {
      "category": "VG",
      "tags": ["Popular"],
      "shopName": "Glamour Looks",
      "rating": 4.5,
      "ratingCount": 189,
      "address": "T. Nagar",
      "description": "Bridal makeup & spa services",
      "showPrice": true,
      "imageUrl":
          "https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&auto=format&fit=crop&w=880&q=80",
    },
    {
      "category": "NEW",
      "tags": ["Verified"],
      "shopName": "Urban Cuts",
      "rating": 4.3,
      "ratingCount": 112,
      "address": "Velachery",
      "description": "Men's grooming & beard styling",
      "showPrice": false,
      "imageUrl":
          "https://images.unsplash.com/photo-1585747860715-2ba9076f3a7a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80",
    },
    {
      "category": "TOP",
      "tags": ["Premium"],
      "shopName": "Royal Beauty",
      "rating": 4.9,
      "ratingCount": 302,
      "address": "Adyar",
      "description": "Luxury makeovers",
      "showPrice": true,
      "imageUrl":
          "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1887&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Salon Services"),
        backgroundColor: const Color(0xFF009085),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slideshow Banner
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
                            "Top Salons in Chennai",
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
                  // Dot Indicators
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

            // Salon Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: salonShops
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


