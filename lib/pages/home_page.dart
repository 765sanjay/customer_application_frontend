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
import 'package:sklyit/flash/main.dart' as flash;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 2;
  late Widget currentBody;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    pages = [
      ExplorePage(),
      HistoryPage(),
      Home(
        search: () => setState(() {
          currentPageIndex = 0;
          currentBody = pages.elementAt(currentPageIndex);
        }),
      ),
      SavedBusinessesPage(),
      const Center(child: Text('Flash')),
      ProfilePage(),
    ];
    currentBody = pages.elementAt(currentPageIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      setState(() {
        currentPageIndex = args;
        currentBody = pages.elementAt(currentPageIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => flash.MyApp(),
              ),
            ).then((_) {
              // Restore the previous index and theme when returning from flash app
              if (mounted) {
                setState(() {
                  currentPageIndex = 2; // Home index
                  currentBody = pages.elementAt(currentPageIndex);
                });
              }
            });
          } else {
            setState(() {
              currentPageIndex = index;
              currentBody = pages.elementAt(currentPageIndex);
            });
          }
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
            child: Icon(Icons.flash_on_rounded),
            label: '',
          ),
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
