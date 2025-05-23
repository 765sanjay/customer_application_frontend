import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/widgets/domain_icons.dart';
import 'package:sklyit/widgets/product_card.dart';
import 'package:sklyit/widgets/search.dart';
import 'package:sklyit/widgets/service_banners.dart';
import '../providers/home_page_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.search});
  final VoidCallback search;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _sheetExtent = 0.25; // initial value

  @override
  void initState() {
    super.initState();
    Provider.of<HomePageProvider>(context, listen: false).reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background: only shows DomainIcons with fade based on extent
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 120),
                AnimatedOpacity(
                  opacity: _sheetExtent < 0.3 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: DomainIcons(),
                ),
              ],
            ),
          ),

          /// Draggable sheet overlays the icons
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  setState(() {
                    _sheetExtent = notification.extent;
                  });
                  return true;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: ListView(
                    controller: scrollController,
                    children:[
                      ServiceBanners(),
                      SizedBox(height: 16),
                      // Add more widgets if needed
                    ],
                  ),
                ),
              );
            },
          ),

          /// Search bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.white.withOpacity(0.95),
              child: Column(
                children: [
                  Search(search: widget.search),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerDashboardWidget extends StatelessWidget {
  const CustomerDashboardWidget({
    super.key,
    required this.search,
    required this.highlights,
    required this.topServices,
  });

  final VoidCallback search;
  final List<Map<String, dynamic>> highlights;
  final List<Map<String, dynamic>> topServices;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionTitle(context: context, title: 'Highlights'),
            const Spacer(),
          ],
        ),
        Row(
          children: provider.highlights
              .take(2)
              .map((e) => Expanded(child: ProductCard(business: e)))
              .toList(),
        ),
        const SizedBox(height: 16),
        SectionTitle(context: context, title: 'Top Businesses'),
        BusinessCategoryWidget(topServices: provider.topServices),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.context,
    required this.title,
  });

  final BuildContext context;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}

final List<Map<String, dynamic>> categories = [
  {
    'title': "Personal Care",
    'icon': Icons.person,
  },
  {
    'title': "Fitness & Wellness",
    'icon': Icons.fitness_center,
  },
  {
    'title': "Home Cleaning",
    'icon': Icons.cleaning_services,
  },
  {
    'title': "Electricians",
    'icon': Icons.electrical_services,
  },
  {
    'title': "Plumbing",
    'icon': Icons.plumbing,
  },
  {
    'title': "Appliance Repair",
    'icon': Icons.build,
  },
];

class BusinessCategoryWidget extends StatefulWidget {
  const BusinessCategoryWidget({
    super.key,
    required this.topServices,
  });

  final List<Map<String, dynamic>> topServices;

  @override
  _BusinessCategoryWidgetState createState() => _BusinessCategoryWidgetState();
}

class _BusinessCategoryWidgetState extends State<BusinessCategoryWidget> {
  String selectedCategory = "Personal Care";
  List<Map<String, dynamic>> filteredServices = [];

  @override
  void initState() {
    super.initState();
    filteredServices = widget.topServices;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: categories.map((category) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category['title'];
                  filteredServices = provider.topServices
                      .where((element) =>
                          element['BusinessMainTags']!
                              .contains(selectedCategory) ||
                          element['BusinessSubTags']!
                              .contains(selectedCategory))
                      .toList();
                });
              },
              child: SizedBox(
                width: 120,
                child: Card(
                  color: (selectedCategory == category['title'])
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardTheme.color,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category['icon'], size: 40),
                      const SizedBox(height: 4),
                      Text(
                        category['title'],
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$selectedCategory Providers",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: filteredServices
              .take(2)
              .map((business) =>
                  Expanded(child: ProductCard(business: business)))
              .toList(),
        ),
      ],
    );
  }
}
