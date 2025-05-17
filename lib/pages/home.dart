import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/widgets/domain_icons.dart';
import 'package:sklyit/widgets/product_card.dart';
import 'package:sklyit/widgets/search.dart';
import 'package:sklyit/widgets/service_banners.dart';
import '../providers/home_page_provider.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.search});

  final VoidCallback search;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController
      .addListener(() {
        if (_scrollController.offset > 200) {
          Provider.of<HomePageProvider>(context, listen: false).setInitial(false);
        }
      });
    Provider.of<HomePageProvider>(context, listen: false).reload();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context);

    return Scaffold(
      
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (provider.isInitial)
                    Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const Text(
                        "Your Gateway to Local Businesses",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 70),
                  
                  DomainIcons(),
                  ServiceBanners(),
                ],
              ),
            ),
          ),
          Positioned(
            top: provider.isInitial ? (_scrollController.hasClients ? (200 - _scrollController.offset) : 200) : 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.white.withOpacity(0.9),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SectionTitle(context: context, title: 'Highlights'),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 185,
            child: PageView(
              scrollDirection: Axis.horizontal,
              children: provider.highlights.map((e) => ProductCard(business: e)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SectionTitle(context: context, title: 'Top Businesses'),
          SizedBox(
            height: 350,
            child: BusinessCategoryWidget(topServices: provider.topServices),
          ),
        ],
      ),
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
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category['title'];
                    filteredServices = provider.topServices
                        .where((element) => element['BusinessMainTags']!.contains(selectedCategory) || element['BusinessSubTags']!.contains(selectedCategory))
                        .toList();
                  });
                },
                child: SizedBox(
                  width: 120,
                  child: Card(
                    color: (selectedCategory == category['title'])
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).cardTheme.color,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
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
            },
          ),
        ),
        ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$selectedCategory Providers",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 185,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredServices.length,
              itemBuilder: (context, index) {
                final business = filteredServices.toList()[index];
                return ProductCard(business: business);
              },
            ),
          ),
        ],
      ],
    );
  }
}