import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Us Section
          _buildSection(
            title: 'About Us',
            links: ['Our Story', 'Team', 'Careers', 'Press'],
          ),
          SizedBox(height: 32),

          // Services Section
          _buildSection(
            title: 'Services',
            links: ['For Business', 'For Customers', 'Pricing', 'Enterprise'],
          ),
          SizedBox(height: 32),

          // Support Section
          _buildSection(
            title: 'Support',
            links: ['Help Center', 'Documentation', 'API Status', 'Contact Us'],
          ),
          SizedBox(height: 32),

          // Connect Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F4858),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildSocialIcon(Icons.facebook),
                  SizedBox(width: 16),
                  _buildSocialIcon(FontAwesomeIcons.twitter),
                  SizedBox(width: 16),
                  _buildSocialIcon(FontAwesomeIcons.instagram),
                  SizedBox(width: 16),
                  _buildSocialIcon(Icons.linked_camera),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Subscribe to our newsletter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2F4858),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF009085),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Handle subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009085),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Subscribe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 32),

          // Footer Bottom Text
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                '© 2024 Your Company. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build a section
  Widget _buildSection({required String title, required List<String> links}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2F4858),
          ),
        ),
        SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: links.map((link) => _buildLink(link)).toList(),
        ),
      ],
    );
  }

  // Helper method to build a link
   Widget _buildLink(String text) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          visualDensity: VisualDensity.compact,
          title: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          onTap: () {
            // Handle link tap
          },
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      ],
    );
  }

  // Helper method to build a social icon
  Widget _buildSocialIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.grey[600],
      onPressed: () {
        // Handle social icon tap
      },
    );
  }
}