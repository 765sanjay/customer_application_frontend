import 'package:flutter/material.dart';

class HighlightsSection extends StatelessWidget {
  final List<Map<String, String>> highlights;

  HighlightsSection({required this.highlights});

  @override
  Widget build(BuildContext context) {
    if (highlights.isEmpty) {
      return SizedBox(); // Return empty if no highlights
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Highlights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: highlights.length,
            itemBuilder: (context, index) {
              final highlight = highlights[index];
              return Container(
                width: 100,
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Image.network(highlight['imageUrl']!,
                        height: 80, fit: BoxFit.cover),
                    SizedBox(height: 4),
                    Text(highlight['title']!,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
