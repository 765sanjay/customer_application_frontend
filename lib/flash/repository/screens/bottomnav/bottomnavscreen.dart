import 'package:flutter/material.dart';
import 'package:sklyit/flash/repository/screens/cart/cartscreen.dart';
import 'package:sklyit/flash/repository/screens/category/categoryscreen.dart';
import 'package:sklyit/flash/pages/market_category_page.dart';
import 'package:sklyit/flash/repository/screens/home/homescreen.dart';
import 'package:sklyit/flash/repository/screens/markat/markat_home.dart';
import 'package:sklyit/flash/repository/screens/print/offerscreen.dart';
import 'package:sklyit/flash/repository/screens/profile/profilescreen.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/toggle_provider.dart';
import 'package:sklyit/flash/repository/color_palete/color_palete.dart';
import 'package:sklyit/pages/home_page.dart';
import 'package:sklyit/flash/repository/screens/orders/order_details.dart';
import 'package:sklyit/flash/repository/screens/orders/order_history.dart';


class BottomNavScreen extends StatefulWidget {
  final int initialIndex;

  const BottomNavScreen({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with SingleTickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _elevationAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToggleProvider>(
      builder: (context, toggleProvider, child) {
        final List<Widget> pages = [
          toggleProvider.isSklyFlashSelected ? HomeScreen() : MarkatHome(),
          toggleProvider.isSklyFlashSelected ? CategoryScreen(businessId: '',) : MarketCategoryPage(),
          CartScreen(),
          OrderHistory(),
        ];

        return Scaffold(
          backgroundColor: ColorPalette.white,
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: ColorPalette.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              _buildBackButton(),
              Expanded(child: _buildNavItem(0, Icons.home_rounded, "Home", ColorPalette.primaryColor)),
              Expanded(child: _buildNavItem(1, Icons.category_rounded, "Categories", ColorPalette.darkAccent)),
              Expanded(child: _buildNavItem(2, Icons.shopping_cart_rounded, "Cart", ColorPalette.accentColor)),
              Expanded(child: _buildNavItem(3, Icons.list_alt_rounded, "Orders", ColorPalette.secondaryColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: 64,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.grey,
                    size: 15,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 7,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (currentIndex != index) {
          setState(() {
            currentIndex = index;
            _animationController.forward(from: 0);
          });
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, isSelected ? -_elevationAnimation.value : 0),
            child: Transform.scale(
              scale: isSelected ? _scaleAnimation.value : 1.0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                constraints: const BoxConstraints(
                  minHeight: 61,
                  maxHeight: 61,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isSelected ? 24 : 0),
                    bottom: Radius.circular(isSelected ? 24 : 0),
                  ),
                  gradient: isSelected
                      ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      activeColor.withOpacity(0.15),
                      activeColor.withOpacity(0.05),
                    ],
                  )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? activeColor.withOpacity(0.2) : Colors.transparent,
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? activeColor : ColorPalette.grey,
                        size: 17,
                      ),
                    ),
                    const SizedBox(height: 1),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected ? activeColor : ColorPalette.grey,
                        fontSize: isSelected ? 9 : 8,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        shadows: isSelected
                            ? [
                          Shadow(
                            color: activeColor.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                            : null,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}