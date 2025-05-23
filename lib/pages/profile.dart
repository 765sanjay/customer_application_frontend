import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Assuming UserUtils and LoginPage are defined elsewhere in your project
import 'package:sklyit/utils/user_utils.dart';
import 'package:sklyit/pages/login.dart';
import 'package:sklyit/api/user-data.dart';
import '../widgets/ListTile_style.dart';
import '../widgets/footer.dart';
import 'package:sklyit/pages/EditProfilePage.dart';

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
  bool locationBasedRecommendations =
      UserUtils.preferences?['locationBasedRecommendations'] as bool? ?? true;
  ThemeMode selectedTheme = ThemeMode.values.firstWhere(
    (e) => e.toString() == 'ThemeMode.${UserUtils.preferences?['theme']}',
    orElse: () => ThemeMode.system,
  );
  bool emailNotifications =
      UserUtils.preferences?['emailNotifications'] as bool? ?? true;
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
    }); // Placeholder image initially
  }

  // Pick avatar function (placeholder for now)

  // Function to pick image from gallery
  Future<void> _pickAvatar() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

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

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userName: userName,
          email: email,
          phoneNumber: phoneNumber,
          onSave: (newName, newEmail, newPhone) {
            setState(() {
              userName = newName;
              email = newEmail;
              phoneNumber = newPhone;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile"),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.exit_to_app),
      //       onPressed: _logout,
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  // Avatar
                  Padding(
                  padding: EdgeInsets.only(right: 30),
                  child : GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: (UserUtils.user?["imgurl"] != null)
                              ? NetworkImage(UserUtils.user?["imgurl"])
                              : AssetImage(avatarUrl) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xfff4c345),
                            child: Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  // Editable Avatar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit Icon
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xfff4c345)),
                    onPressed: _navigateToEditProfile,
                  ),
                  
                ],
              ),
            ),

            SizedBox(height: 20),

// Preferences Section - Updated design
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
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
                    contentPadding: EdgeInsets.zero,
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
                ],
              ),
            ),
            SizedBox(height: 16),

            // Notification Settings Section - Updated design
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Email Notifications'),
                    value: emailNotifications,
                    onChanged: (bool value) {
                      setState(() {
                        emailNotifications = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Push Notifications'),
                    value: pushNotifications,
                    onChanged: (bool value) {
                      setState(() {
                        pushNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Wallet Management Section - Updated design
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text("Wallet Balance"),
                    subtitle: Text("\$${walletBalance.toStringAsFixed(2)}"),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Add Funds clicked')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff4c345),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          "Add Funds",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Withdraw clicked')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfff4c345),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            //Divider(height: 30, thickness: 2),

            // Refer and Earn Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Light background color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.card_giftcard, color: Colors.black87),
                      SizedBox(width: 8),
                      Text(
                        "Refer & Earn",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Get \$100 when your friend completes their first booking",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Referral code shared!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfff4c345),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        "Refer now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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

            //Divider(height: 30, thickness: 2),

            // Offers and Updates Section
            // Offers and Updates Section - Updated design
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offers & Coupons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.local_offer, color: Color(0xfff4c345)),
                    title: Text(
                      "Exclusive Offer",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("20% off on AC Servicing"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Offer redeemed!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfff4c345),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        "Redeem",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        Icon(Icons.card_giftcard, color: Color(0xfff4c345)),
                    title: Text(
                      "New Coupon",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text("Buy 1 Get 1 Free on Haircuts"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Coupon redeemed!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfff4c345),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        "Redeem",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            //Divider(height: 30, thickness: 2),

            // Logout Button
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(
                      color: Colors.black, // Black border color
                      width: 1.0, // Border width
                    ),
                  ),
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
