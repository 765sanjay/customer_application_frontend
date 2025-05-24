import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sklyit/domain/constants/appcolors.dart';
// import 'package:sklyit/repository/screens/login/loginscreen.dart';
import 'package:sklyit/repository/widgets/uihelper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _imageError = false;

  @override
  void initState() {
    super.initState();
    print('SplashScreen initialized');

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Timer(Duration(seconds: 3), () {
    //     print('Navigating to LoginScreen');
    //     if (mounted) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => LoginScreen()),
    //       );
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbackgroud,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageError
                ? Icon(Icons.error, size: 100, color: Colors.red)
                : Image.asset(
              "assets/preload.jpeg", // Make sure this path is correct
              errorBuilder: (context, error, stackTrace) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      _imageError = true;
                    });
                  }
                });
                return Icon(Icons.error, size: 100, color: Colors.red);
              },
            ),
          ],
        ),
      ),
    );
  }
}