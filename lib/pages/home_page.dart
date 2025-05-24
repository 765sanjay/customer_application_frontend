import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:sklyit/pages/explore.dart';
import 'package:sklyit/pages/home.dart';
import 'package:sklyit/pages/saved.dart';
import 'package:sklyit/providers/home_page_provider.dart';
import 'package:sklyit/screens/chat_screen/chat_dashboard.dart';
import 'package:sklyit/pages/profile.dart';
import 'package:sklyit/pages/recents.dart';
import 'package:sklyit/utils/user_utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    List<Widget> pages = [];

    void search() => setState(() {
          currentPageIndex = 0;
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

    return Scaffold(
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
          setState(() {
            currentPageIndex = index;
            currentBody = pages.elementAt(currentPageIndex);
          });
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        buttonBackgroundColor: Theme.of(context).colorScheme.primary,
        index: currentPageIndex,
        items: const [
          CurvedNavigationBarItem(
              child: Icon(Icons.search_outlined),
              label: ''),
          CurvedNavigationBarItem(
              child: Icon(Icons.history_outlined),
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
    );
  }
}
