import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sklyit/providers/home_page_provider.dart';
import '../providers/loading_state_provider.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for the scaling effect
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    context.read<HomePageProvider>().reload();
    Future.delayed(Duration(seconds: 2), () {
      // Mark loading as complete
      context.read<LoadingStateProvider>().setLoadingComplete();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(AssetImage('assets/images/preload.jpeg'), context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Image.asset(
            'assets/images/preload.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // This will show if the image fails to load
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    Text('Failed to load image', style: TextStyle(fontSize: 16)),
                    Text('Path: assets/images/preload.jpeg', style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
}