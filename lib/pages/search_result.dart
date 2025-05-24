import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sklyit/pages/customer_perspective.dart';
import 'package:sklyit/pages/wizard_profile_page.dart';
import 'package:sklyit/api/search.dart';

class SearchResultsPage extends StatefulWidget {
  String? searchQuery = "";
  String? location = "";


  SearchResultsPage({super.key, this.location, this.searchQuery});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<Map<String, dynamic>> results = [];

  void initState() {
    super.initState();
    SearchApi.search(widget.searchQuery, widget.location, 50).then((value) {
      setState(() {
        results = List<Map<String, dynamic>>.from(jsonDecode(value)["data"]);
      });
    });
    SearchApi.searchProfessionals(queryString: widget.searchQuery, location: widget.location, limit: 50).then((value) {
      setState(() {
        results.addAll(List<Map<String, dynamic>>.from(jsonDecode(value)["data"]));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: (result["shopimage"] != null) ? NetworkImage(result["shopimage"]) : AssetImage("assets/images/logo.png"),
              ),
              title: Text(result["shopname"] ?? result["Clientname"]),
              subtitle: Text(result["BusinessId"] != null
                  ? result["shopdesc"]
                  : "Rating: ${4.2} ⭐"),
              onTap: () async {
                if (result["BusinessId"] != null) {
                  // Navigate to Business Profile Page
                  dynamic posts = await SearchApi.getPostsByBusinessId(result["BusinessId"]);
                  dynamic sevices = await SearchApi.getServicesByBusinessId(result["BusinessId"]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomerPerspective(shopName: result["Clientname"], shopDescription: result["shopdesc"], shopAddress: result["address"], bannerImagePath: result["shopimage"], services: sevices, posts: posts),
                    ),
                  );
                } else {
                  // Navigate to Individual Wizard Profile Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WizardProfilePage(
                        name: result["Clientname"],
                        image: result["shopimage"] ?? "assets/images/logo.png",
                        rating: 4.2,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
