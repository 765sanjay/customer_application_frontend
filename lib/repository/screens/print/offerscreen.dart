import 'package:flutter/material.dart';
import 'package:sklyit/repository/widgets/uihelper.dart';

class OffersScreen extends StatelessWidget {
  final List<Offer> offers = [
    Offer(
      title: "Fresh Vegetables",
      discount: "30% OFF",
      description: "On all leafy vegetables",
      validUntil: "Today only",
      image: "vegetables.png",
      bgColor: Color(0XFF009085),
    ),
    Offer(
      title: "Dairy Products",
      discount: "Buy 1 Get 1",
      description: "On selected milk brands",
      validUntil: "Limited time",
      image: "milk.png",
      bgColor: Color(0XFF2F4858),
    ),
    Offer(
      title: "Snacks & Chips",
      discount: "40% OFF",
      description: "On all packaged snacks",
      validUntil: "Today only",
      image: "chips.png",
      bgColor: Color(0XFF006B7C),
    ),
    Offer(
      title: "Beverages",
      discount: "25% OFF",
      description: "Cold drinks & juices",
      validUntil: "Weekend special",
      image: "drinks.png",
      bgColor: Color(0XFFF6C445),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFFDD90D).withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Color(0XFF009085),
        title: UiHelper.CustomText(
          text: "Today's Offers",
          color: Colors.white,
          fontweight: FontWeight.bold,
          fontsize: 20,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search offers...",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0XFF2F4858),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [Color(0XFFF6C445), Color(0XFFFDD90D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 20,
                      top: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UiHelper.CustomText(
                            text: "SPECIAL WEEKEND",
                            color: Colors.black,
                            fontweight: FontWeight.bold,
                            fontsize: 14,
                          ),
                          UiHelper.CustomText(
                            text: "FLAT 50% OFF",
                            color: Colors.black,
                            fontweight: FontWeight.bold,
                            fontsize: 24,
                          ),
                          UiHelper.CustomText(
                            text: "On first order above ₹200",
                            color: Colors.black,
                            fontweight: FontWeight.normal,
                            fontsize: 14,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: UiHelper.CustomText(
                          text: "Use code: WEEKEND50",
                          color: Colors.white,
                          fontweight: FontWeight.bold,
                          fontsize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustomText(
                    text: "Categories",
                    color: Colors.black,
                    fontweight: FontWeight.bold,
                    fontsize: 18,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: UiHelper.CustomText(
                      text: "See all",
                      color: Color(0XFF009085),
                      fontweight: FontWeight.bold,
                      fontsize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryItem(Icons.shopping_basket, "Grocery"),
                  _buildCategoryItem(Icons.local_drink, "Beverages"),
                  _buildCategoryItem(Icons.emoji_food_beverage, "Snacks"),
                  _buildCategoryItem(Icons.kitchen, "Kitchen"),
                  _buildCategoryItem(Icons.clean_hands, "Personal Care"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustomText(
                    text: "Today's Best Deals",
                    color: Colors.black,
                    fontweight: FontWeight.bold,
                    fontsize: 18,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: UiHelper.CustomText(
                      text: "See all",
                      color: Color(0XFF009085),
                      fontweight: FontWeight.bold,
                      fontsize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                return _buildOfferCard(offers[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Color(0XFF2F4858), size: 30),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildOfferCard(Offer offer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: offer.bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UiHelper.CustomText(
                    text: offer.discount,
                    color: Colors.white,
                    fontweight: FontWeight.bold,
                    fontsize: 24,
                  ),
                  UiHelper.CustomText(
                    text: offer.title,
                    color: Colors.white,
                    fontweight: FontWeight.bold,
                    fontsize: 18,
                  ),
                  SizedBox(height: 5),
                  UiHelper.CustomText(
                    text: offer.description,
                    color: Colors.white,
                    fontweight: FontWeight.normal,
                    fontsize: 14,
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: UiHelper.CustomText(
                      text: offer.validUntil,
                      color: Colors.white,
                      fontweight: FontWeight.bold,
                      fontsize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Container(
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/images/${offer.image}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Offer {
  final String title;
  final String discount;
  final String description;
  final String validUntil;
  final String image;
  final Color bgColor;

  Offer({
    required this.title,
    required this.discount,
    required this.description,
    required this.validUntil,
    required this.image,
    required this.bgColor,
  });
}