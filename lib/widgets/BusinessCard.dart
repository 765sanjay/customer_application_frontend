import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String category;
  final List<String> tags;
  final String businessName;
  final double rating;
  final int ratingCount;
  final String location;
  final String description;
  final bool showPrice;
  final String imageUrl;

  const BusinessCard({
    super.key,
    required this.category,
    required this.tags,
    required this.businessName,
    required this.rating,
    required this.ratingCount,
    required this.location,
    required this.description,
    required this.showPrice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 140,
        child: Row(
          children: [
            // Image
            Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          businessName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "#$category",
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "$rating ($ratingCount)",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showPrice)
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "View Prices",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
