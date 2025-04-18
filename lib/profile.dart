import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Melissa Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Mars, Solar System", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const ListTile(
            title: Text("Booking"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            title: Text("Wishlist"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.edit),
            title: Text("Edit profile"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text("Change language"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const ListTile(
            leading: Icon(Icons.brightness_4),
            title: Text("Color mode"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.article),
            title: Text("Terms and Condition"),
            trailing: Icon(Icons.open_in_new),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text("Privacy policy"),
            trailing: Icon(Icons.open_in_new),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
