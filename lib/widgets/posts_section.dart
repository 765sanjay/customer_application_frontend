import 'package:flutter/material.dart';
import 'post_card.dart';

class PostsSection extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final bool isCustomerView;

  PostsSection({required this.posts, this.isCustomerView = false});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No posts available.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Posts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 300,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: posts[index],
                isCustomerView: isCustomerView,
                onEdit: isCustomerView
                    ? null
                    : () {
                        print('Edit post $index');
                      },
                onDelete: isCustomerView
                    ? null
                    : () {
                        print('Delete post $index');
                      },
              );
            },
          ),
        ),
      ],
    );
  }
}
