import 'package:flutter/material.dart';
import 'package:sklyit/pages/search_result.dart';

class Search extends StatefulWidget {
  Search({
    super.key,
    this.search,
    this.filter,
    this.filterLocation,
  });

  VoidCallback? search;
  void Function(String)? filter;
  void Function(String)? filterLocation;
  

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String keyword = "";
  String location = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 50,
        constraints: const BoxConstraints(
          maxWidth: 600, // Limit the width of the search bar
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.tertiary, width: 2.0),
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromARGB(15, 100, 100, 100)),
        child: Row(
          children: [
            Container(
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Icon(
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Location",
                ),
                onChanged: (query) {
                  setState(() {
                    location = query;
                  });
                },
              ),
            ),
            const VerticalDivider(
              width: 10,
              thickness: 2.0,
            ),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(right: 12.0),
                ),
                onChanged: (query) {
                  // Handle text input changes
                  print('Searching for: $query');
                  setState(() {
                    keyword = query;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Trigger search action
                print('Search button clicked');
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => SearchResultsPage(
                      searchQuery: keyword,
                      location: location,
                    )
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
