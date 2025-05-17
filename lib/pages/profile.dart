import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Assuming UserUtils and LoginPage are defined elsewhere in your project
import 'package:sklyit/utils/user_utils.dart';
import 'package:sklyit/pages/login.dart';
import 'package:sklyit/api/user-data.dart';
import '../widgets/ListTile_style.dart';
import '../widgets/footer.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String avatarUrl;

  String userName = UserUtils.user?['name'] ?? 'Unknown User';
  String email = UserUtils.user?['gmail'] ?? 'No Email';
  String phoneNumber = UserUtils.user?['mobileno'] ?? 'No phone';

  double walletBalance = 100.0; // Example balance
  String referralCode = "SKLY123"; // Example referral code

  // Preferences
  bool locationBasedRecommendations = UserUtils.preferences?['locationBasedRecommendations'] as bool? ?? true;
  ThemeMode selectedTheme = ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.${UserUtils.preferences?['theme']}',
    orElse: () => ThemeMode.system,
  );
  bool emailNotifications = UserUtils.preferences?['emailNotifications'] as bool? ?? true;
  bool pushNotifications = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    avatarUrl = 'assets/images/logo.png';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        userName = UserUtils.user?['name'] ?? 'Unknown User';
        email = UserUtils.user?['gmail'] ?? 'No Email';
        phoneNumber = UserUtils.user?['mobileno'] ?? 'No Phone';
      });
    });// Placeholder image initially
  }

  // Pick avatar function (placeholder for now)

  // Function to pick image from gallery
  Future<void> _pickAvatar() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        print(pickedFile.path);
        UserUtils.avatarPath = pickedFile.path;
        uploadAvatar(pickedFile.path);
      });
    }
  }

  // Logout function
  Future<void> _logout() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmation ?? false) {
      // Clear login status
      await UserUtils.clearLoginStatus();
      if (mounted) {
        // Navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        // Placeholder action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully!')),
        );
      }
    }
  }

  // Save Preferences
  void _savePreferences() {
    // Implement saving preferences logic (e.g., API call)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences updated!')),
    );

    updateUserPreferences({
      'notifications': pushNotifications,
      'locationBasedRecommendations': locationBasedRecommendations,
      'theme': selectedTheme.name,
      'emailNotifications': emailNotifications,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Editable Avatar
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: (UserUtils.user?["imgurl"] != null) ? NetworkImage(UserUtils.user?["imgurl"]) : AssetImage(avatarUrl),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Profile Details (Non-editable Name and Email)
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Name"),
              subtitle: Text(userName),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Phone"),
              subtitle: Text(phoneNumber),
            ),

            Divider(height: 30, thickness: 2),

            // Preferences Section
            _SectionHeader(title: 'Preferences'),

            SwitchListTile(
              title: Text('Location-Based Recommendations'),
              value: locationBasedRecommendations,
              onChanged: (bool value) {
                setState(() {
                  locationBasedRecommendations = value;
                });
                _savePreferences();
              },
            ),
            ListTile(
              title: Text('App Theme'),
              trailing: DropdownButton<ThemeMode>(
                value: selectedTheme,
                items: [
                  DropdownMenuItem(
                    child: Text('Light'),
                    value: ThemeMode.light,
                  ),
                  DropdownMenuItem(
                    child: Text('Dark'),
                    value: ThemeMode.dark,
                  ),
                  DropdownMenuItem(
                    child: Text('System Default'),
                    value: ThemeMode.system,
                  ),
                ],
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    setState(() {
                      selectedTheme = value;
                    });
                    _savePreferences();
                  }
                },
              ),
            ),


            Divider(height: 30, thickness: 2),

            // Notification Settings Section
            _SectionHeader(title: 'Notification Settings'),
            SwitchListTile(
              title: Text('Email Notifications'),
              value: emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  emailNotifications = value;
                });
                // Optionally save notification settings here
              },
            ),
            SwitchListTile(
              title: Text('Push Notifications'),
              value: pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  pushNotifications = value;
                });
                // Optionally save notification settings here
              },
            ),

            Divider(height: 30, thickness: 2),

            // Wallet Management Section
            _SectionHeader(title: 'Wallet Management'),
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text("Wallet Balance"),
              subtitle: Text("\$${walletBalance.toStringAsFixed(2)}"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement Add Funds logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Add Funds clicked')),
                    );
                  },
                  child: Text("Add Funds"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement Withdraw logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Withdraw clicked')),
                    );
                  },
                  child: Text("Withdraw"),
                ),
              ],
            ),

            Divider(height: 30, thickness: 2),

            // Refer and Earn Section
            _SectionHeader(title: 'Refer & Earn'),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("Referral Code"),
              subtitle: Text(referralCode),
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Implement share referral code functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Referral code shared!')),
                  );
                },
              ),
            ),
            // Placeholder for tracking referral rewards
            ListTile(
              leading: Icon(Icons.track_changes),
              title: Text("Referral Rewards"),
              subtitle: Text("You have earned \$20 from referrals."),
              onTap: () {
                // Navigate to referral rewards page
              },
            ),

            Divider(height: 30, thickness: 2),

            // Offers and Updates Section
            _SectionHeader(title: 'Offers & Coupons'),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("Exclusive Offer"),
              subtitle: Text("20% off on AC Servicing"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Implement redeem offer functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Offer redeemed!')),
                  );
                },
                child: Text("Redeem"),
              ),
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text("New Coupon"),
              subtitle: Text("Buy 1 Get 1 Free on Haircuts"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Implement redeem coupon functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Coupon redeemed!')),
                  );
                },
                child: Text("Redeem"),
              ),
            ),

            Divider(height: 30, thickness: 2),

            // Logout Button
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}