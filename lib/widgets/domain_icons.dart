import 'dart:async';

import 'package:flutter/material.dart';

class DomainIcons extends StatefulWidget {
  @override
  _DomainIconsState createState() => _DomainIconsState();
}

class _DomainIconsState extends State<DomainIcons> {
  final List<Map<String, String>> stats = [
    {"value": "4000+", "label": "Businesses"},
    {"value": "1000+", "label": "Services"},
    {"value": "2000+", "label": "Professionals"}
  ];

  final List<Map<String, dynamic>> domains = [
    {"icon": Icons.favorite, "label": "Personal Care"},
    {"icon": Icons.face, "label": "Salon"},
    {"icon": Icons.fitness_center, "label": "Gym"},
    {"icon": Icons.flash_on, "label": "Electrical"},
    {"icon": Icons.build, "label": "Plumbing"},
    {"icon": Icons.settings, "label": "Appliance Repair"},
    {"icon": Icons.cleaning_services, "label": "Cleaning"},
    {"icon": Icons.checkroom, "label": "Fashion"},
    {"icon": Icons.brush, "label": "Beauty"}
  ];

  String currentWord = "Find";
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % 3;
        currentWord = ["Find", "Fixx", "Skly"][currentIndex];
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void navigateTo(String label) {
    final path = '/domain/${label.toLowerCase().replaceAll(' ', '-')}';
    print("Navigate to: $path");
    // Use your navigator here to push routes.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0x19009085),
                Color(0x19F6C445),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: stats.map((stat) {
              return Column(
                children: [
                  Text(
                    stat['value']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009085),
                    ),
                  ),
                  Text(
                    stat['label']!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2F4858),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 32),
        // Animated Text Section
        Text(
          "# $currentWord It",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kalam', // Make sure to add the Kalam font in your app.
          ),
        ),
        const SizedBox(height: 32),
        // Domains Section
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 7,
            crossAxisSpacing: 7,
          ),
          itemCount: domains.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(18),
          itemBuilder: (context, index) {
            final domain = domains[index];
            return GestureDetector(
              onTap: () => navigateTo(domain['label']!),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0x19009085),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Icon(
                        domain['icon'],
                        size: 36,
                        color: const Color(0xFF009085),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    domain['label']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2F4858),
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
}