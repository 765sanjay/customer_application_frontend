import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sklyit/api/user-data.dart';
import 'package:sklyit/pages/customer_perspective.dart';
import 'package:sklyit/utils/user_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/search.dart';

class SavedBusinessesPage extends StatefulWidget {
  @override
  _SavedBusinessesPageState createState() => _SavedBusinessesPageState();
}

class _SavedBusinessesPageState extends State<SavedBusinessesPage> {
  List<Map<String, dynamic>> followedBusinesses = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      followedBusinesses = UserUtils.user?["followedBusinesses"] ?? [];
    });
  }

  void _unfollowBusiness(business) {
    setState(() {
      unfollowBusiness(business["BusinessId"]);
      followedBusinesses.remove(business);
    });
  }

  void _launchUrl(String url) async {
    if (await launchUrl(Uri.parse(url))) {
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openDigitalShop(Map<String, dynamic> b) async {
    dynamic posts = await SearchApi.getPostsByBusinessId(b["BusinessId"]);
    dynamic services = await SearchApi.getServicesByBusinessId(b["BusinessId"]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerPerspective(
            shopName: b["Clientname"],
            shopDescription: b["shopdesc"],
            shopAddress: b["address"],
            bannerImagePath: b["shopurl"],
            services: services,
            posts: posts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Businesses'),
      ),
      body: followedBusinesses.isEmpty
          ? Center(
              child: Text(
                'No followed businesses yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: followedBusinesses.length,
              itemBuilder: (context, index) {
                final business = followedBusinesses[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(business["shopurl"]),
                    ),
                    title: Text(
                      business["Clientname"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(business["shopdesc"]),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'unfollow') {
                          _unfollowBusiness(business);
                        } else if (value == 'shop') {
                          _openDigitalShop(business);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'shop',
                          child: Text('Open Shop'),
                        ),
                        PopupMenuItem(
                          value: 'unfollow',
                          child: Text('Unfollow'),
                        ),
                      ],
                      icon: Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
