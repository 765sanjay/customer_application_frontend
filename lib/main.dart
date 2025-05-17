import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/utils/colors.dart';
import 'package:sklyit/pages/loading_page.dart';
import 'package:sklyit/pages/main_page.dart';
import 'package:sklyit/providers/loading_state_provider.dart';
import 'providers/home_page_provider.dart';
import 'providers/bookings_page_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePageProvider()),
        ChangeNotifierProvider(create: (context) => LoadingStateProvider()),
        ChangeNotifierProvider(create: (context) => BookingPageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sklyit',
      theme: ThemeData(
        primaryColor: color1,
        colorScheme: const ColorScheme(
          primary: color1,
          onPrimary: Colors.white,
          secondary: color2,
          onSecondary: Colors.white,
          tertiary: color3,
          onTertiary: Colors.white,
          surface: Colors.white,
          onSurface: color3,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: Consumer<LoadingStateProvider>(
        builder: (context, loadingState, _) {
          return loadingState.isLoading ? LoadingPage() : MainPage();
        },
      ),
    );
  }
}
