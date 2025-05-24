import 'package:flutter/material.dart';
import 'package:sklyit/api/sphere.dart';
import 'package:sklyit/pages/customer_perspective.dart';

import '../api/search.dart';

class ExplorePage extends StatefulWidget {
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> results = [
    {
      "id": "business1",
      "type": "business",
      "name": "Tech Solutions Inc.",
      "image": "assets/images/business.png",
      "description": "Innovative IT solutions for your business.",
    },
    {
      "id": "wizard1",
      "type": "wizard",
      "name": "John Doe",
      "image": "assets/images/wizard.png",
      "rating": 4.8,
    },
    {
      "id": "business2",
      "type": "business",
      "name": "Green Gardens Landscaping",
      "image": "assets/images/landscaping.png",
      "description": "Top-rated landscaping services.",
    },
    {
      "id": "wizard2",
      "type": "wizard",
      "name": "Jane Smith",
      "image": "assets/images/wizard_female.png",
      "rating": 4.5,
    },
  ];

  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts(); // Call the separate async method
  }

  void _loadPosts() async {
    posts = await SklyitSphereApi.getTopNewest(15);
    setState(() {}); // Refresh the UI after fetching the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _sectionTitle('Posts'),
          ...posts.map((post) => _postCard(
            title: post['name'],
            description: post['description'],
            businessId: post['business_id'],
            onCardTap: (businessId) {
              _navigateToBusinessProfile(context, businessId);
            },
            onLike: () {},
            onComment: () {},
            onShare: () {},
          )),
          const SizedBox(height: 20),
          _sectionTitle('Blogs'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _postCard({
    required String title,
    required String description,
    required String businessId,
    required Function(String businessId) onCardTap,
    required VoidCallback onLike,
    required VoidCallback onComment,
    required VoidCallback onShare,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => onCardTap(businessId),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(onPressed: onLike, icon: Icon(Icons.thumb_up)),
                  IconButton(onPressed: onComment, icon: Icon(Icons.comment)),
                  IconButton(onPressed: onShare, icon: Icon(Icons.share)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _blogCard({
    required String title,
    required String description,
    required String businessId,
    required Function(String businessId) onCardTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => onCardTap(businessId),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(description),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => onCardTap(businessId),
                child: Text('Read More'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _promotionCard({
    required String title,
    required String description,
    required String businessId,
    required Function(String businessId) onClaimOffer,
  }) {
    return Card(
      elevation: 4,
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onClaimOffer(businessId),
              child: Text('Claim Offer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pollCard({
    required String question,
    required List<String> options,
    required Function(String) onVote,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...options.map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: null,
                  toggleable: true,
                  onChanged: (value) {
                    if (value != null) onVote(value);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _navigateToBusinessProfile(BuildContext context, String businessId) async {
    dynamic res = await SearchApi.getBusinessById(businessId);
    dynamic services = await SearchApi.getServicesByBusinessId(businessId);
    dynamic posts = await SearchApi.getPostsByBusinessId(businessId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerPerspective(shopName: res["Clientname"], shopDescription: res["shopdesc"], shopAddress: res["address"].toString(), bannerImagePath: res["shopimage"], services: services, posts: posts),
      ),
    );
  }
}

