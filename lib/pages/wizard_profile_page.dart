import 'package:flutter/material.dart';

class WizardProfilePage extends StatelessWidget {
  final String name;
  final String image;
  final double rating;

  WizardProfilePage({
    required this.name,
    required this.image,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 50,
            ),
            SizedBox(height: 16),
            Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Service Area: New York City", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text("Rating: ${rating.toStringAsFixed(1)} ⭐"),
            SizedBox(height: 8),
            Text("Customer Satisfaction: 95%"),
            Divider(),
            // Services List
            ListTile(
              title: Text("Service 1: Lawn Care"),
              subtitle: Text("\$50/hour"),
            ),
            ListTile(
              title: Text("Service 2: Pest Control"),
              subtitle: Text("\$100/session"),
            ),
            Divider(),
            // Reviews Section
            ListTile(
              title: Text("Review by Alice"),
              subtitle: Text("Excellent work!"),
            ),
            ListTile(
              title: Text("Review by Bob"),
              subtitle: Text("Highly professional."),
            ),
            Divider(),
            ElevatedButton(
              onPressed: () {
                // Initiate booking process
              },
              child: Text("Book Service"),
            ),
          ],
        ),
      ),
    );
  }
}
