import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE0F7FA), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              'https://images.unsplash.com/photo-1496307653780-42ee777d4833',
              height: 320,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),

          // Partnered with Microsoft & Atlassian
          Text(
            'Partnered with Microsoft for Startups & Atlassian for Startups',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF006064),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          // Pre-incubated at CED, Anna University
          Text(
            'Pre-incubated at CED, Anna University',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF006064),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Empowering SMBs
          Text(
            'Empowering Small & Medium Businesses with Geo-Based Marketplaces',
            style: TextStyle(
              fontSize: 28,
              color: Color(0xFF004D40),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // #MITforIndia
          Text(
            '#MITforIndia',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF004D40),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'A vision born at MIT Chennai to empower India\'s SMBs with cutting-edge digital solutions.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Paragraphs
          Text(
            'In an era where everything is going digital, small and medium businesses are struggling to compete with larger corporations. Many offer excellent services but remain invisible due to the lack of tools and digital presence.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'This realization inspired us to create Skly It, a platform that levels the playing field, providing SMBs with enterprise-grade tools and connecting them to customers effortlessly.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Your Path to Digitalization
          Text(
            'Your Path to Digitalization',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF004D40),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          // Features Grid
          Column(
            children: [
              _buildFeature(
                icon: Icons.favorite,
                title: 'Digital Shops',
                description:
                    'Create your own customizable digital storefront to showcase products and services. Manage inventory, pricing, and promotions with ease.',
              ),
              SizedBox(height: 16),
              _buildFeature(
                icon: Icons.star,
                title: 'Geo-Based Marketplaces',
                description:
                    'Connect with local customers through our location-based marketplace. Increase visibility and reach in your target area.',
              ),
              SizedBox(height: 16),
              _buildFeature(
                icon: Icons.trending_up,
                title: 'Booking Management',
                description:
                    'Streamline appointment scheduling and reservations. Automated reminders and calendar integration for efficient booking management.',
              ),
              SizedBox(height: 16),
              _buildFeature(
                icon: Icons.favorite,
                title: 'Billing & Credit',
                description:
                    'Generate professional invoices, track payments, and manage customer credit lines all in one place. Simplify your financial operations.',
              ),
              SizedBox(height: 16),
              _buildFeature(
                icon: Icons.star,
                title: 'CRM & Promotions',
                description:
                    'Build stronger customer relationships with integrated CRM tools. Create and track targeted promotional campaigns effectively.',
              ),
              SizedBox(height: 16),
              _buildFeature(
                icon: Icons.trending_up,
                title: 'Analytics',
                description:
                    'Make data-driven decisions with comprehensive business analytics. Track performance metrics and identify growth opportunities.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a feature row
  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xFF009085),
          size: 32,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF004D40),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}