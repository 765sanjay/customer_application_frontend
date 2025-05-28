import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/flash/repository/providers/cart_provider.dart';
import 'package:sklyit/flash/repository/screens/profile/profilescreen.dart';
import 'package:sklyit/flash/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:sklyit/flash/repository/providers/address_provider.dart';
import 'package:sklyit/flash/repository/providers/profile_provider.dart';
import 'package:sklyit/flash/repository/providers/toggle_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ToggleProvider()),
      ],
      child: MaterialApp(
        title: 'Blinkit Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BottomNavScreen(initialIndex: 0),
        routes: {
          '/personalInfo': (context) => const PersonalInfoPage(),
          '/orderHistory': (context) => const OrderHistoryPage(),
          '/favorites': (context) => const FavoritesPage(),
          '/notifications': (context) => const NotificationsPage(),
        },
      ),
    );
  }
}