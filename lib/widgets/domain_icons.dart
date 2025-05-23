import 'package:flutter/material.dart';
import '../pages/SalonServicePage.dart'; // Adjust the import as per your project structure
import '../pages/GymServicePage.dart';

class DomainIcons extends StatefulWidget {
  @override
  _DomainIconsState createState() => _DomainIconsState();
}

class _DomainIconsState extends State<DomainIcons> {
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

  void navigateTo(String label) {
    if (label == "Salon") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SalonServicePage()),
      );
    } else if (label == "Gym") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GymServicePage()),
      );
    } else {
      final path = '/domain/${label.toLowerCase().replaceAll(' ', '-')}';
      print("Navigate to: $path");
      // Use your navigator here to push routes.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
