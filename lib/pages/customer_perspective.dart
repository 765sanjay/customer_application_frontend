import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/shop_info_card.dart';
import '../widgets/search_bar.dart' as search_bar;
import '../widgets/highlights_section.dart';
import '../widgets/posts_section.dart';
import '../widgets/services_section.dart';

class CustomerPerspective extends StatelessWidget {
  final String shopName;
  final String shopDescription;
  final String bannerImagePath;
  final String followers;
  final String popularity;
  final String shopAddress;
  final int likesCount;
  final List<Map<String, String>> highlights;
  final List<Map<String, dynamic>> posts;
  final List<Map<String, dynamic>> services;

  CustomerPerspective({
    required this.shopName,
    required this.shopDescription,
    required this.shopAddress,
    required this.bannerImagePath,
    required this.services,
    required this.posts,
    this.followers = '2.5k',
    this.popularity = '90%',
    this.likesCount = 350,
    this.highlights = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer View'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // AppBar floats over banner
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Section: Full Width without Shadow
                Image.file(
                  File(bannerImagePath),
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.network(
                    'https://via.placeholder.com/150',
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        shopDescription,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                // Info Section Overlapping the Banner
                Positioned(
                  bottom: -260,
                  left: 16,
                  right: 16,
                  child: ShopInfoCard(
                    followers: followers,
                    popularity: popularity,
                    likesCount: likesCount,
                    shopAddress: shopAddress,
                  ),
                ),
              ],
            ),
            SizedBox(height: 270), // Spacing for the overlapping card
            search_bar.SearchBar(),
            HighlightsSection(highlights: highlights),
            PostsSection(posts: posts, isCustomerView: true),
            SizedBox(height: 20),
            // Services Section
            ServicesSection(services: services, isBusiness: false),
          ],
        ),
      ),
    );
  }
}
