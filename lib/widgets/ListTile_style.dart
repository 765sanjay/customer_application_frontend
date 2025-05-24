import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: MyWidget.buildStyledListTile(), // ✅ Call as static method
        ),
      ),
    );
  }

  static List<Widget> buildStyledListTile() { // 🔹 Make it static
    return [
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const ListTile(
          leading: Icon(Icons.track_changes, color: Colors.blue, size: 30),
          title: Text(
            "Referral Rewards",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "You have earned \$20 from referrals.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          tileColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: const ListTile(
          leading: Icon(Icons.monetization_on, color: Colors.green, size: 30),
          title: Text(
            "Wallet Balance",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Your current balance is \$50.",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          tileColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    ];
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
