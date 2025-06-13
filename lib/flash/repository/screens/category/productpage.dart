import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/cart_provider.dart';
import 'package:sklyit/flash/repository/screens/cart/cartscreen.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/flash/repository/screens/bottomnav/bottomnavscreen.dart';

class ProductsPage extends StatefulWidget {
  final String category;
  final List<String> subcategories;
  final String initialSubcategory;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final Color darkAccent;
  final Color lightAccent;

  const ProductsPage({
    Key? key,
    required this.category,
    required this.subcategories,
    this.initialSubcategory = '',
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.darkAccent,
    required this.lightAccent,
  }) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late List<Map<String, dynamic>> _allProducts;
  List<Map<String, dynamic>> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  late String _selectedSubcategory;
  late List<String> _displaySubcategories;
  late Map<String, String> _subcategoryImages;

  @override
  void initState() {
    super.initState();
    _allProducts = _getProducts();
    _filteredProducts = _allProducts;
    _searchController.addListener(_onSearchChanged);

    // Use provided subcategories or get defaults
    _displaySubcategories = widget.subcategories.isNotEmpty
        ? widget.subcategories
        : _getDefaultSubcategories(widget.category);

    _selectedSubcategory = widget.initialSubcategory.isNotEmpty
        ? widget.initialSubcategory
        : (_displaySubcategories.isNotEmpty ? _displaySubcategories[0] : widget.category);

    _subcategoryImages = _getSubcategoryImages(widget.category);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final brand = product['brand'].toString().toLowerCase();
        return name.contains(query) || brand.contains(query);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _filteredProducts = _allProducts;
      }
    });
  }

  List<Map<String, dynamic>> _getProducts() {
    switch (widget.category) {
      case 'Fruits & Vegetables':
        return [
          {
            'name': 'Fresh Apples',
            'brand': 'Farm Fresh',
            'price': '₹199/kg',
            'originalPrice': '₹220/kg',
            'discount': '10% OFF',
            'rating': 4.5,
            'reviews': 128,
            'image': 'assets/images/apples.jpg',
            'delivery': 'Today by 8 PM'
          },
          {
            'name': 'Organic Tomatoes',
            'brand': 'Organic Farms',
            'price': '₹49/kg',
            'originalPrice': '₹60/kg',
            'discount': '18% OFF',
            'rating': 4.2,
            'reviews': 95,
            'image': 'assets/images/tomatoes.jpeg',
            'delivery': 'Today by 8 PM'
          },
        ];
      case 'Dairy, Bread & Eggs':
        return [
          {
            'name': 'Fresh Milk',
            'brand': 'Amul',
            'price': '₹60/liter',
            'originalPrice': '₹65/liter',
            'discount': '8% OFF',
            'rating': 4.7,
            'reviews': 342,
            'image': 'assets/images/milk.jpg',
            'delivery': 'Today by 8 PM'
          },
          {
            'name': 'Farm Eggs',
            'brand': 'Eggoz',
            'price': '₹90/dozen',
            'originalPrice': '₹100/dozen',
            'discount': '10% OFF',
            'rating': 4.6,
            'reviews': 215,
            'image': 'assets/images/eggs.jpg',
            'delivery': 'Today by 8 PM'
          },
        ];
      case 'Tea, Coffee & More':
        return [
          {
            'name': 'Premium Tea',
            'brand': 'Taj Mahal',
            'price': '₹250/500g',
            'originalPrice': '₹300/500g',
            'discount': '17% OFF',
            'rating': 4.8,
            'reviews': 512,
            'image': 'assets/images/tea.jpg',
            'delivery': 'Today by 8 PM'
          },
          {
            'name': 'Instant Coffee',
            'brand': 'Nescafe',
            'price': '₹180/100g',
            'originalPrice': '₹200/100g',
            'discount': '10% OFF',
            'rating': 4.6,
            'reviews': 387,
            'image': 'assets/images/coffee.jpg',
            'delivery': 'Today by 8 PM'
          },
        ];
      case 'Headphones':
        return [
          {
            'name': 'Wireless Headphones',
            'brand': 'Boat',
            'price': '₹1,299',
            'originalPrice': '₹1,799',
            'discount': '28% OFF',
            'rating': 4.5,
            'reviews': 1245,
            'image': 'assets/images/headphones.jpg',
            'delivery': 'Tomorrow by 5 PM'
          },
          {
            'name': 'Ear Buds',
            'brand': 'OnePlus',
            'price': '₹2,999',
            'originalPrice': '₹3,999',
            'discount': '25% OFF',
            'rating': 4.7,
            'reviews': 876,
            'image': 'assets/images/earbuds.jpg',
            'delivery': 'Tomorrow by 5 PM'
          },
        ];
      case 'Skincare':
        return [
          {
            'name': 'Face Wash',
            'brand': 'Garnier',
            'price': '₹149',
            'originalPrice': '₹199',
            'discount': '25% OFF',
            'rating': 4.6,
            'reviews': 789,
            'image': 'assets/images/facewash.jpg',
            'delivery': 'Today by 8 PM'
          },
          {
            'name': 'Moisturizer',
            'brand': 'Nivea',
            'price': '₹199',
            'originalPrice': '₹249',
            'discount': '20% OFF',
            'rating': 4.5,
            'reviews': 654,
            'image': 'assets/images/moisturizer.jpg',
            'delivery': 'Today by 8 PM'
          },
        ];
      default:
        return [
          {
            'name': 'Sample Product 1',
            'brand': 'Brand X',
            'price': '₹999',
            'originalPrice': '₹1,199',
            'discount': '17% OFF',
            'rating': 4.3,
            'reviews': 156,
            'image': 'assets/images/sample1.jpg',
            'delivery': '2 Days'
          },
          {
            'name': 'Sample Product 2',
            'brand': 'Brand Y',
            'price': '₹1,499',
            'originalPrice': '₹1,799',
            'discount': '17% OFF',
            'rating': 4.1,
            'reviews': 98,
            'image': 'assets/images/sample2.jpg',
            'delivery': '3 Days'
          },
        ];
    }
  }

  List<String> _getDefaultSubcategories(String category) {
    switch (category) {
      case 'Fruits & Vegetables':
        return [
          'All',
          'Fresh Vegetables',
          'Fresh Fruits',
          'Flowers & Leaves',
          'Mangoes & Melons',
          'Leafy Vegetables',
        ];
      case 'Dairy, Bread & Eggs':
        return [
          'All',
          'Milk',
          'Bread',
          'Eggs',
          'Paneer & Cheese',
          'Butter & Spreads',
        ];
      case 'Atta, Rice, Oil & Dals':
        return [
          'All',
          'Wheat Flour (Atta)',
          'Basmati Rice',
          'Non-Basmati Rice',
          'Pulses & Dals',
          'Cooking Oil',
          'Rice Flour & Other Flours',
          'Organic Grains & Staples',
          'Sooji, Maida & Besan',
        ];
      case 'Meat, Fish & Eggs':
        return [
          'All',
          'Fresh Chicken',
          'Mutton',
          'Fish & Seafood',
          'Eggs',
          'Frozen Meat & Seafood',
          'Ready to Cook Non-Veg',
        ];
      case 'Masala & Dry Fruits':
        return [
          'All',
          'Whole Spices',
          'Ground Spices',
          'Blended Masalas',
          'Seasoning & Herbs',
          'Dry Fruits',
          'Nuts & Seeds',
          'Spice Mixes & Paste',
        ];
      case 'Munchies':
        return [
          'All',
          'Chips & Crisps',
          'Popcorn',
          'Namkeen & Bhujia',
          'Corn Puffs & Rings',
          'Trail Mixes',
          'Roasted Snacks',
          'Snack Bars',
        ];
      case 'Biscuits & Cookies':
        return [
          'All',
          'Glucose Biscuits',
          'Cream Biscuits',
          'Digestive Biscuits',
          'Cookies',
          'Crackers',
          'Wafer Biscuits',
          'Sugar-Free Biscuits',
        ];

      case 'Tea, Coffee & More':
        return [
          'All',
          'Tea',
          'Coffee',
          'Green Tea',
          'Health Drinks',
        ];
      case 'Packaged Food':
        return [
          'All',
          'Ready to Eat',
          'Instant Noodles',
          'Snacks & Namkeen',
          'Frozen Food',
          'Canned Food',
          'Pickles & Chutneys',
          'Breakfast Cereals',
          'Pasta & Vermicelli',
          'Soup Mixes',
          'Baking Essentials',
        ];
      case 'Icecreams & More':
        return [
          'All',
          'Ice Creams',
          'Frozen Desserts',
          'Kulfi',
          'Ice Cream Cones',
          'Ice Cream Bars',
          'Frozen Yogurt',
          'Sorbet',
          'Gelato',
        ];

      case 'Frozen Foods':
        return [
          'All',
          'Frozen Veggies',
          'Frozen Snacks',
          'Frozen Parathas & Rotis',
          'Frozen Meat & Seafood',
          'Frozen Ready Meals',
          'Frozen Fries & Nuggets',
          'Frozen Breads',
        ];

      case 'Sweet Cravings':
        return [
          'All',
          'Chocolates',
          'Candies & Gums',
          'Indian Sweets',
          'Cakes & Pastries',
          'Cookies & Biscuits',
          'Dessert Mixes',
          'Mithai Gift Packs',
        ];

      case 'Cold Drinks & Juices':
        return [
          'All',
          'Fruit Juices',
          'Vegetable Juices',
          'Mixed Juices',
          'Carbonated Drinks',
          'Soda & Sparkling Water',
          'Iced Tea',
          'Energy Drinks',
          'Sports Drinks',
          'Cold-Pressed Juices',
          'Flavored Water',
        ];
      case 'Skincare':
        return [
          'All',
          'Face Wash',
          'Moisturizer',
          'Sunscreen',
          'Serum',
        ];
      case 'Haircare':
        return[
          'All',
          'Shampoo',
          'Conditioner',
          'Hair Oil',
          'Serum',
          'Styling'
        ];
      case 'Makeup':
        return [
          'All',
          'Face',
          'Lips',
          'Nails',
          'Makeup-kit and combo',
        ];

      case 'Personal Care':
        return [
          'All',
          'Bath & Body',
          'Mens Grooming & Hygiene',
          'Oral Care',
          'Feminine Hygiene',
        ];
      case 'Perfumes' :
        return [
          'All',
          'Mens Perfumes',
          'Womens Perfumes',
          'Unisex Perfumes',
          'Kids Perfumes',
          'Party Perfumes'
        ];
      case 'Headphones':
        return [
          'All',
          'Wired Headphones',
          'Wireless Headphones',
          'Bluetooth Earbuds',
          'Gaming Headsets',
          'Over-Ear Headphones',
          'Neckband Earphones',
          'Noise Cancelling Headphones',
        ];
      case 'Lights & Electricals':
        return [
          'All',
          'LED Bulbs',
          'Tube Lights',
          'Smart Lights',
          'Ceiling Lights',
          'Extension Boards',
          'Electrical Wires & Cables',
          'Switches & Holders',
          'Night Lamps & Decorative Lights',
        ];

      default:
        return ['All', 'Sample 1', 'Sample 2'];
    }
  }

  Map<String, String> _getSubcategoryImages(String category) {
    switch (category) {
      case 'Fruits & Vegetables':
        return {
          'All': 'assets/images/categories/fruits_vegetables.png',
          'Fresh Vegetables': 'assets/images/subcategories/fresh_vegetables.png',
          'Fresh Fruits': 'assets/images/subcategories/fresh_fruits.png',
          'Flowers & Leaves': 'assets/images/subcategories/flowers_leaves.png',
          'Mangoes & Melons': 'assets/images/subcategories/mangoes_melons.png',
          'Leafy Vegetables': 'assets/images/subcategories/leafy_vegetables.png',
        };
      case 'Dairy, Bread & Eggs':
        return {
          'All': 'assets/images/categories/dairy.png',
          'Milk': 'assets/images/subcategories/milk.png',
          'Bread': 'assets/images/subcategories/bread.png',
          'Eggs': 'assets/images/subcategories/eggs.png',
          'Paneer & Cheese': 'assets/images/subcategories/paneer_cheese.png',
          'Butter & Spreads': 'assets/images/subcategories/butter_spreads.png',
        };
      case 'Atta, Rice, Oil & Dals':
        return {
          'All': 'assets/images/categories/grains.png',
          'Wheat Flour (Atta)': 'assets/images/subcategories/wheat_flour.png',
          'Basmati Rice': 'assets/images/subcategories/basmati_rice.png',
          'Non-Basmati Rice': 'assets/images/subcategories/rice.png',
          'Pulses & Dals': 'assets/images/subcategories/pulses.png',
          'Cooking Oil': 'assets/images/subcategories/cooking_oil.png',
          'Rice Flour & Other Flours': 'assets/images/subcategories/flour.png',
          'Organic Grains & Staples': 'assets/images/subcategories/organic_grains.png',
          'Sooji, Maida & Besan': 'assets/images/subcategories/sooji.png',
        };
      case 'Meat, Fish & Eggs':
        return {
          'All': 'assets/images/categories/meat.png',
          'Fresh Chicken': 'assets/images/subcategories/chicken.png',
          'Mutton': 'assets/images/subcategories/mutton.png',
          'Fish & Seafood': 'assets/images/subcategories/fish.png',
          'Eggs': 'assets/images/subcategories/eggs.png',
          'Frozen Meat & Seafood': 'assets/images/subcategories/frozen_meat.png',
          'Ready to Cook Non-Veg': 'assets/images/subcategories/ready_nonveg.png',
        };
      case 'Masala & Dry Fruits':
        return {
          'All': 'assets/images/categories/spices.png',
          'Whole Spices': 'assets/images/subcategories/whole_spices.png',
          'Ground Spices': 'assets/images/subcategories/ground_spices.png',
          'Blended Masalas': 'assets/images/subcategories/masala.png',
          'Seasoning & Herbs': 'assets/images/subcategories/herbs.png',
          'Dry Fruits': 'assets/images/subcategories/dry_fruits.png',
          'Nuts & Seeds': 'assets/images/subcategories/nuts.png',
          'Spice Mixes & Paste': 'assets/images/subcategories/spice_paste.png',
        };
      case 'Munchies':
        return {
          'All': 'assets/images/categories/snacks.png',
          'Chips & Crisps': 'assets/images/subcategories/chips.png',
          'Popcorn': 'assets/images/subcategories/popcorn.png',
          'Namkeen & Bhujia': 'assets/images/subcategories/namkeen.png',
          'Corn Puffs & Rings': 'assets/images/subcategories/corn_puffs.png',
          'Trail Mixes': 'assets/images/subcategories/trail_mix.png',
          'Roasted Snacks': 'assets/images/subcategories/roasted_snacks.png',
          'Snack Bars': 'assets/images/subcategories/snack_bars.png',
        };
      case 'Biscuits & Cookies':
        return {
          'All': 'assets/images/categories/biscuits.png',
          'Glucose Biscuits': 'assets/images/subcategories/glucose_biscuits.png',
          'Cream Biscuits': 'assets/images/subcategories/cream_biscuits.png',
          'Digestive Biscuits': 'assets/images/subcategories/digestive.png',
          'Cookies': 'assets/images/subcategories/cookies.png',
          'Crackers': 'assets/images/subcategories/crackers.png',
          'Wafer Biscuits': 'assets/images/subcategories/wafer.png',
          'Sugar-Free Biscuits': 'assets/images/subcategories/sugarfree_biscuits.png',
        };
      case 'Tea, Coffee & More':
        return {
          'All': 'assets/images/categories/tea_coffee.png',
          'Tea': 'assets/images/subcategories/tea.png',
          'Coffee': 'assets/images/subcategories/coffee.png',
          'Green Tea': 'assets/images/subcategories/green_tea.png',
          'Health Drinks': 'assets/images/subcategories/health_drinks.png',
        };
      case 'Packed Food':
        return {
          'All': 'assets/images/categories/packed_food.png',
          'Ready to Eat': 'assets/images/subcategories/ready_to_eat.png',
          'Instant Noodles': 'assets/images/subcategories/noodles.png',
          'Snacks & Namkeen': 'assets/images/subcategories/snacks.png',
          'Frozen Food': 'assets/images/subcategories/frozen_food.png',
          'Canned Food': 'assets/images/subcategories/canned_food.png',
          'Pickles & Chutneys': 'assets/images/subcategories/pickles.png',
          'Breakfast Cereals': 'assets/images/subcategories/cereals.png',
          'Pasta & Vermicelli': 'assets/images/subcategories/pasta.png',
          'Soup Mixes': 'assets/images/subcategories/soup.png',
          'Baking Essentials': 'assets/images/subcategories/baking.png',
        };
      case 'Icecreams & More':
        return {
          'All': 'assets/images/categories/icecream.png',
          'Ice Creams': 'assets/images/subcategories/ice_cream.png',
          'Frozen Desserts': 'assets/images/subcategories/frozen_dessert.png',
          'Kulfi': 'assets/images/subcategories/kulfi.png',
          'Ice Cream Cones': 'assets/images/subcategories/ice_cream_cone.png',
          'Ice Cream Bars': 'assets/images/subcategories/ice_cream_bar.png',
          'Frozen Yogurt': 'assets/images/subcategories/frozen_yogurt.png',
          'Sorbet': 'assets/images/subcategories/sorbet.png',
          'Gelato': 'assets/images/subcategories/gelato.png',
        };
      case 'Frozen Foods':
        return {
          'All': 'assets/images/categories/frozen.png',
          'Frozen Veggies': 'assets/images/subcategories/frozen_veggies.png',
          'Frozen Snacks': 'assets/images/subcategories/frozen_snacks.png',
          'Frozen Parathas & Rotis': 'assets/images/subcategories/frozen_paratha.png',
          'Frozen Meat & Seafood': 'assets/images/subcategories/frozen_meat.png',
          'Frozen Ready Meals': 'assets/images/subcategories/ready_meals.png',
          'Frozen Fries & Nuggets': 'assets/images/subcategories/fries.png',
          'Frozen Breads': 'assets/images/subcategories/frozen_bread.png',
        };
      case 'Sweet Cravings':
        return {
          'All': 'assets/images/categories/sweets.png',
          'Chocolates': 'assets/images/subcategories/chocolates.png',
          'Candies & Gums': 'assets/images/subcategories/candies.png',
          'Indian Sweets': 'assets/images/subcategories/indian_sweets.png',
          'Cakes & Pastries': 'assets/images/subcategories/cake.png',
          'Cookies & Biscuits': 'assets/images/subcategories/cookies.png',
          'Dessert Mixes': 'assets/images/subcategories/dessert_mix.png',
          'Mithai Gift Packs': 'assets/images/subcategories/mithai.png',
        };
      case 'Cold Drinks & Juices':
        return {
          'All': 'assets/images/categories/drinks.png',
          'Fruit Juices': 'assets/images/subcategories/juice.png',
          'Vegetable Juices': 'assets/images/subcategories/vegetable_juice.png',
          'Mixed Juices': 'assets/images/subcategories/mixed_juice.png',
          'Carbonated Drinks': 'assets/images/subcategories/soda.png',
          'Soda & Sparkling Water': 'assets/images/subcategories/sparkling_water.png',
          'Iced Tea': 'assets/images/subcategories/iced_tea.png',
          'Energy Drinks': 'assets/images/subcategories/energy_drink.png',
          'Sports Drinks': 'assets/images/subcategories/sports_drink.png',
          'Cold-Pressed Juices': 'assets/images/subcategories/coldpressed.png',
          'Flavored Water': 'assets/images/subcategories/flavored_water.png',
        };
      case 'Skincare':
        return {
          'All': 'assets/images/categories/skincare.png',
          'Face Wash': 'assets/images/subcategories/face_wash.png',
          'Moisturizer': 'assets/images/subcategories/moisturizer.png',
          'Sunscreen': 'assets/images/subcategories/sunscreen.png',
          'Serum': 'assets/images/subcategories/serum.png',
        };
      case 'Haircare':
        return {
          'All': 'assets/images/categories/haircare.png',
          'Shampoo': 'assets/images/subcategories/shampoo.png',
          'Conditioner': 'assets/images/subcategories/conditioner.png',
          'Hair Oil': 'assets/images/subcategories/hair_oil.png',
          'Serum': 'assets/images/subcategories/hair_serum.png',
          'Styling': 'assets/images/subcategories/hair_styling.png',
        };
      case 'Makeup':
        return {
          'All': 'assets/images/categories/makeup.png',
          'Face': 'assets/images/subcategories/face_makeup.png',
          'Lips': 'assets/images/subcategories/lipstick.png',
          'Nails': 'assets/images/subcategories/nail_polish.png',
          'Makeup-kit and combo': 'assets/images/subcategories/makeup_kit.png',
        };
      case 'Personal Care':
        return {
          'All': 'assets/images/categories/personal_care.png',
          'Bath & Body': 'assets/images/subcategories/bath_body.png',
          'Mens Grooming & Hygiene': 'assets/images/subcategories/mens_grooming.png',
          'Oral Care': 'assets/images/subcategories/oral_care.png',
          'Feminine Hygiene': 'assets/images/subcategories/feminine_hygiene.png',
        };
      case 'Perfumes':
        return {
          'All': 'assets/images/categories/perfume.png',
          'Mens Perfumes': 'assets/images/subcategories/mens_perfume.png',
          'Womens Perfumes': 'assets/images/subcategories/womens_perfume.png',
          'Unisex Perfumes': 'assets/images/subcategories/unisex_perfume.png',
          'Kids Perfumes': 'assets/images/subcategories/kids_perfume.png',
          'Party Perfumes': 'assets/images/subcategories/party_perfume.png',
        };
      case 'Headphones':
        return {
          'All': 'assets/images/categories/headphones.png',
          'Wired Headphones': 'assets/images/subcategories/wired_headphones.png',
          'Wireless Headphones': 'assets/images/subcategories/wireless_headphones.png',
          'Bluetooth Earbuds': 'assets/images/subcategories/earbuds.png',
          'Gaming Headsets': 'assets/images/subcategories/gaming_headset.png',
          'Over-Ear Headphones': 'assets/images/subcategories/over_ear.png',
          'Neckband Earphones': 'assets/images/subcategories/neckband.png',
          'Noise Cancelling Headphones': 'assets/images/subcategories/noise_cancelling.png',
        };
      case 'Lights & Electricals':
        return {
          'All': 'assets/images/categories/lights.png',
          'LED Bulbs': 'assets/images/subcategories/led_bulb.png',
          'Tube Lights': 'assets/images/subcategories/tube_light.png',
          'Smart Lights': 'assets/images/subcategories/smart_light.png',
          'Ceiling Lights': 'assets/images/subcategories/ceiling_light.png',
          'Extension Boards': 'assets/images/subcategories/extension_board.png',
          'Electrical Wires & Cables': 'assets/images/subcategories/wires.png',
          'Switches & Holders': 'assets/images/subcategories/switch.png',
          'Night Lamps & Decorative Lights': 'assets/images/subcategories/night_lamp.png',
        };
      default:
        return {
          'All': 'assets/images/categories/default.png',
          'Sample 1': 'assets/images/subcategories/sample1.png',
          'Sample 2': 'assets/images/subcategories/sample2.png',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: _showSearch
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: widget.secondaryColor),
              hintText: 'Search in ${widget.category}',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: widget.secondaryColor.withOpacity(0.5),
                fontSize: 14,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: TextStyle(color: widget.secondaryColor),
          ),
        )
            : Text(
          widget.category,
          style: TextStyle(
            color: widget.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: widget.secondaryColor),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          // Removed the shopping cart icon from here
          SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Left: Subcategory NavBar - only show if we have subcategories
          if (_displaySubcategories.isNotEmpty)
            Container(
              width: 100, // Slightly narrower for more compact look
              decoration: BoxDecoration(
                color: Colors.grey[200], // Darker grey for industrial feel
                border: Border(
                  right: BorderSide(
                    color: Colors.grey[400]!, // Metallic border
                    width: 1.5,
                  ),
                ),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(), // More modern scroll feel
                itemCount: _displaySubcategories.length,
                itemBuilder: (context, index) {
                  final subcat = _displaySubcategories[index];
                  final isSelected = subcat == _selectedSubcategory;
                  final imagePath = _subcategoryImages[subcat] ?? 'assets/images/generic_placeholder.png';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: isSelected
                          ? Border.all(
                        color: widget.primaryColor,
                        width: 1.5,
                      )
                          : Border.all(
                        color: Colors.grey[400]!.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedSubcategory = subcat;
                          _filterProductsBySubcategory();
                        });
                      },
                      splashColor: widget.primaryColor.withOpacity(0.1),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Industrial-style icon container
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey[300],
                                border: Border.all(
                                  color: Colors.grey[500]!,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    imagePath,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.category, size: 20, color: Colors.grey[700]),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Industrial-style text
                            Text(
                              subcat,
                              style: TextStyle(
                                color: isSelected
                                    ? widget.primaryColor
                                    : Colors.grey[800],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 0.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Right: Product List (Expanded)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Optional industrial-style header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.grid_view, color: Colors.grey[700], size: 20),
                        SizedBox(width: 8),
                        Text(
                          'PRODUCT INVENTORY',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Spacer(),
                        // Text(
                        //   '${_filteredProducts.length} ITEMS',
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // Product Grid
                  Expanded(
                    child: _filteredProducts.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'INVENTORY EMPTY',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No matching products found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                        : Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/industrial_bg.png'), // Optional subtle texture
                          fit: BoxFit.cover,
                          opacity: 0.03,
                        ),
                      ),
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.65, // Adjusted for better fit
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: _buildProductCard(_filteredProducts[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavScreen(initialIndex: 2),
            ),
                (route) => false,
          );
        },
        backgroundColor: ColorPalette.primaryColor,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final productId = '${product['name']}_${product['brand']}';
        final cartItem = cartProvider.items[productId];
        final isInCart = cartItem != null;
        final quantity = isInCart ? cartItem.quantity : 0;

        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Badges
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8)),
                      child: Image.asset(
                        product['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey[400]),
                            ),
                      ),
                    ),
                  ),
                  // Discount Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: widget.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['discount'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Brand and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product['brand'],
                              style: TextStyle(
                                color: widget.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  '${product['rating']}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Product Name
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.secondaryColor,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      // Price and Original Price
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              product['price'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: widget.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              product['originalPrice'],
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Add to Cart or Quantity Counter
                      if (!isInCart)
                        SizedBox(
                          height: 28,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final price = double.parse(product['price']
                                  .replaceAll(RegExp(r'[^0-9.]'), ''));
                              cartProvider.addItem(
                                productId,
                                product['name'],
                                product['brand'],
                                price,
                                product['image'],
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Added to cart!'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      cartProvider.removeItem(productId);
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.remove, size: 16),
                                  color: widget.primaryColor,
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    if (quantity > 1) {
                                      cartProvider.decreaseQuantity(productId);
                                    } else {
                                      cartProvider.removeItem(productId);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$quantity',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  icon: Icon(Icons.add, size: 16),
                                  color: widget.primaryColor,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => cartProvider.increaseQuantity(productId),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _filterProductsBySubcategory() {
    if (_selectedSubcategory == 'All') {
      setState(() {
        _filteredProducts = _allProducts;
      });
      return;
    }
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final brand = product['brand'].toString().toLowerCase();
        final subcat = _selectedSubcategory.toLowerCase();
        // Simple keyword-based filtering for demo; adjust as needed for real data
        if (subcat.contains('fruit')) return name.contains('apple') || name.contains('fruit') || name.contains('mango');
        if (subcat.contains('vegetable')) return name.contains('tomato') || name.contains('vegetable');
        if (subcat.contains('flower')) return name.contains('flower');
        if (subcat.contains('mango')) return name.contains('mango');
        if (subcat.contains('leaf')) return name.contains('leaf');
        if (subcat.contains('milk')) return name.contains('milk');
        if (subcat.contains('bread')) return name.contains('bread');
        if (subcat.contains('egg')) return name.contains('egg');
        if (subcat.contains('paneer')) return name.contains('paneer');
        if (subcat.contains('butter')) return name.contains('butter');
        if (subcat.contains('tea')) return name.contains('tea');
        if (subcat.contains('coffee')) return name.contains('coffee');
        if (subcat.contains('green')) return name.contains('green');
        if (subcat.contains('health')) return name.contains('health');
        if (subcat.contains('wired')) return name.contains('wired');
        if (subcat.contains('wireless')) return name.contains('wireless');
        if (subcat.contains('earbud')) return name.contains('earbud');
        if (subcat.contains('over-ear')) return name.contains('over-ear');
        if (subcat.contains('face wash')) return name.contains('face wash');
        if (subcat.contains('moisturizer')) return name.contains('moisturizer');
        if (subcat.contains('sunscreen')) return name.contains('sunscreen');
        if (subcat.contains('serum')) return name.contains('serum');
        return false;
      }).toList();
    });
  }
}