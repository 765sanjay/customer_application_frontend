import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_page_provider.dart';

class ServiceBanners extends StatefulWidget {
  ServiceBanners({super.key,});
  @override
  _ServiceBannersState createState() => _ServiceBannersState();

}

class _ServiceBannersState extends State<ServiceBanners> {
  int currentSlide = 0;
  Timer? timer;
  

  void handleHeadingClick(String categoryName) {
    final url = '/category/' +
        categoryName.toLowerCase().replaceAll(RegExp(r'\s+'), '-').replaceAll('&', 'and');
    print('Navigating to: $url');
    // Add navigation logic here
  }

  void handleServiceClick(String serviceName) {
    final processedName =
        serviceName.toLowerCase().replaceAll(RegExp(r'\s+'), '-').replaceAll('&', 'and');
    final url = '/service/' + processedName;
    print('Navigating to: $url');
    // Add navigation logic here
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<HomePageProvider>(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            // Replace your AspectRatio widget with this Container
          Container(
            height: 180, // Fixed height for the banner
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Background Image with dark overlay
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4),
                      BlendMode.darken,
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1518770660439-4636190af475',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(color: Colors.blue.shade500);
                      },
                    ),
                  ),
                ),

                // Foreground Content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'FLAT150OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12), // Reduced from 20
                      Text(
                        'Special Launch Offer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22, // Reduced from 24
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6), // Reduced from 8
                      Text(
                        'Get 50% off on first booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Reduced from 16
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Personal Care Section
          buildServiceSection('Personal Care', provider.personal_care),

          // Home Services Section
          buildServiceSection('Home Services', provider.home_services),

          // Appliance Repair Section
          buildServiceSection('Appliance Repair', provider.appliance_services),

          // Trending Services Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trending Services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: provider.highlights.map((service) {
                      return GestureDetector(
                        onTap: () => handleServiceClick(service['shopname'] as String),
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    (service['shopimage'] ?? "https://sklyit.xyz/loogo.png") as String,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(service['shopname'] as String,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 16, color: Color(0xFFF6C445)),
                                      const SizedBox(width: 4),
                                      Text('${service['totalordercount']} requests',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 16, color: Color(0xFFF6C445)),
                                      const SizedBox(width: 4),
                                      Text('${service['rating'] ?? 4.2}',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Top Businesses Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Businesses in Your Area',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: provider.topServices.map((business) {
                      return Container(
                        width: 250,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                (business['shopimage'] ?? "https://sklyit.xyz/loogo.png") as String,
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(business['shopname'] as String,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Color(0xFFF6C445)),
                                const SizedBox(width: 4),
                                Text('${business['rating'] ?? 4.2}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_pin, size: 16, color: Color(0xFF009085)),
                                const SizedBox(width: 4),
                                Text('${business['address']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Top Professionals Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Professionals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: provider.topServices.map((professional) {
                      return Container(
                        width: 250,
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                (professional['shopimage'] ?? "https://sklyit.xyz/loogo.png") as String, //professional['shopimage'] as String,
                                fit: BoxFit.cover,
                                height: 120,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(professional['shopname'] as String,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                            const SizedBox(height: 4),
                            Text(professional['BusinessMainTags'].join(' ') as String,
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Color(0xFFF6C445)),
                                const SizedBox(width: 4),
                                Text('${professional['rating'] ?? 4.2}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildServiceSection(String title, List services) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => handleHeadingClick(title),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2F4858))),
                const Icon(Icons.chevron_right, color: Color(0xFF2F4858)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3 / 4,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () => handleServiceClick(service['service_name']),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Image.network(
                        service['service_image_url'] ?? 'https://sklyit.xyz/loogo.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          service['service_name'] ?? service['ServiceName'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 
