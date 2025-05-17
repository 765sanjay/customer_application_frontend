import 'package:flutter/material.dart';
import 'package:sklyit/utils/user_utils.dart';
import 'package:sklyit/pages/home_page.dart';
import 'package:sklyit/pages/login.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // You can show a loading indicator while checking login status
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const MyHomePage(); // Show home if logged in
        } else {
          return const LoginPage(); // Show login page if not logged in
        }
      },
    );
  }
  Future<bool> checkLoginStatus() async {
    return UserUtils.isLoggedIn();
  }
}