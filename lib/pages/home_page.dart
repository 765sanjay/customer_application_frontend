import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/pages/explore.dart';
import 'package:sklyit/pages/home.dart';
import 'package:sklyit/pages/saved.dart';
import 'package:sklyit/providers/home_page_provider.dart';
import 'package:sklyit/screens/chat_screen/chat_dashboard.dart';
import 'package:sklyit/pages/profile.dart';
import 'package:sklyit/pages/recents.dart';
import 'package:sklyit/utils/user_utils.dart';
import 'package:sklyit/repository/screens/bottomnav/bottomnavscreen.dart';
import 'package:sklyit/repository/providers/cart_provider.dart';
import 'package:sklyit/repository/providers/address_provider.dart';
import 'package:sklyit/repository/providers/profile_provider.dart';
import 'package:sklyit/repository/providers/toggle_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 2; // Index of Home in pages list
  int navBarIndex = 3; // Index of home icon in navigation bar (4th icon)

  @override
  void initState() {
    super.initState();
    // Ensure home icon is active by default
    currentPageIndex = 2;
    navBarIndex = 3;
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    List<Widget> pages = [];

    void search() => setState(() {
          currentPageIndex = 0;
          navBarIndex = 0;
          currentBody = pages.elementAt(currentPageIndex);
        });

    pages = [
      ExplorePage(),
      HistoryPage(),
      Home(
        search: search,
      ),
      SavedBusinessesPage(),
      ProfilePage(),
    ];

    currentBody = pages.elementAt(currentPageIndex);
    
    final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
    );
    final icon = Image.asset(
      "assets/images/logo.png",
      fit: BoxFit.fitWidth,
    );

    return WillPopScope(
      onWillPop: () async {
        // When back button is pressed, ensure home icon is active
        setState(() {
          currentPageIndex = 2;
          navBarIndex = 3;
          currentBody = pages.elementAt(currentPageIndex);
        });
        return true;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HomePageProvider().reload();
          },
          child: const Icon(Icons.refresh),
        ),
        appBar: AppBar(
          leading: icon,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => print('Notifications'),
            ),
            IconButton(
              onPressed: () => {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => ChatDashboard(uid: UserUtils.user!["userId"],)
                    )
                  )
              }, 
              icon: const Icon(Icons.message_outlined),
            )
          ]
        ),
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (int index) {
            if (index == 2) { // Flash icon index
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => CartProvider()),
                      ChangeNotifierProvider(create: (_) => AddressProvider()),
                      ChangeNotifierProvider(create: (_) => ProfileProvider()),
                      ChangeNotifierProvider(create: (_) => ToggleProvider()),
                    ],
                    child: BottomNavScreen(initialIndex: 0),
                  ),
                ),
              ).then((_) {
                // When returning from BottomNavScreen, ensure home icon is active
                setState(() {
                  currentPageIndex = 2; // Index of Home in pages list
                  navBarIndex = 3; // Index of home icon in navigation bar (4th icon)
                  currentBody = pages.elementAt(currentPageIndex);
                });
              });
            } else {
              setState(() {
                // For indices after flash icon (3,4,5), subtract 1 to get correct page index
                currentPageIndex = index > 2 ? index - 1 : index;
                navBarIndex = index;
                currentBody = pages.elementAt(currentPageIndex);
              });
            }
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          buttonBackgroundColor: Theme.of(context).colorScheme.primary,
          index: navBarIndex,
          items: const [
            CurvedNavigationBarItem(
                child: Icon(Icons.search_outlined),
                label: ''),
            CurvedNavigationBarItem(
                child: Icon(Icons.history_outlined),
                label: ''),
            CurvedNavigationBarItem(
                child: Icon(Icons.flash_on_rounded),
                label: ''),
            CurvedNavigationBarItem(
              child: Icon(Icons.home_outlined),
              label: '',
            ),
            CurvedNavigationBarItem(
                child: Icon(Icons.star_border),
                label: ''),
            CurvedNavigationBarItem(
              child: Icon(Icons.person), 
              label: ''
            ),
          ],
        ),
        body: currentBody,
      ),
    );
  }
}
