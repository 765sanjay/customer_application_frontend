import 'package:flutter/material.dart';
import 'package:sklyit/repository/screens/orders/order_history.dart';
// import 'package:skly_flash/repository/screens/login/loginscreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFF009085);
  final Color secondaryColor = const Color(0xFF2F4858);

  Future<void> _handleLogout(BuildContext context) async {
    // First, pop any open dialogs or overlays
    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Show logout success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          duration: Duration(seconds: 1),
        ),
      );

      // Use a post-frame callback to ensure clean navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Get the root navigator
        NavigatorState rootNavigator = Navigator.of(
          context,
          rootNavigator: true,
        );

        // Clear all routes and push login screen
        // rootNavigator.pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const LoginScreen(),
        //     settings: const RouteSettings(name: '/login'),
        //   ),
        //       (route) => false,
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _handleLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: primaryColor,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF009085)),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'john.doe@example.com',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildProfileOption(Icons.person, 'Personal Information'),
            _buildProfileOption(Icons.shopping_bag, 'My Orders'),
            _buildProfileOption(Icons.favorite, 'Wishlist'),
            _buildProfileOption(Icons.location_on, 'Delivery Addresses'),
            _buildProfileOption(Icons.payment, 'Payment Methods'),
            _buildProfileOption(Icons.notifications, 'Notifications'),
            _buildProfileOption(Icons.settings, 'Settings'),
            _buildProfileOption(Icons.help, 'Help & Support'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: secondaryColor,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        if (title == 'My Orders') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OrderHistory(),
            ),
          );
        }
        // Implement other navigation options as needed
      },
    );
  }
}