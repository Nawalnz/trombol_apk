import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart'; // Import your onboarding page

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
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
                  Text(
                    "Melissa Doe",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Mars, Solar System",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),

          // Bookings Section
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Bookings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSimpleListTile("My Bookings"),
          _buildSimpleListTile("Wishlist"),

          const SizedBox(height: 24),
          const Divider(),

          // Account Settings
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Account Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsTile(Icons.person, "Edit Profile"),
          _buildSettingsTile(Icons.language, "Change Language"),
          _buildSettingsTile(Icons.dark_mode, "Color Mode"),

          const SizedBox(height: 24),
          const Divider(),

          // Legalities
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Legalities", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsTile(Icons.description, "Terms and Conditions", isExternal: true),
          _buildSettingsTile(Icons.privacy_tip, "Privacy Policy", isExternal: true),

          const SizedBox(height: 32),

          // Logout Button
          ElevatedButton(
            onPressed: () {
              // Navigate to onboarding and clear previous pages
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Onboarding1()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF085374),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Simple Tile without icons
  Widget _buildSimpleListTile(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Implement navigation later
      },
    );
  }

  // Tile with icon
  Widget _buildSettingsTile(IconData icon, String title, {bool isExternal = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.normal)),
      trailing: Icon(
        isExternal ? Icons.open_in_new : Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () {
        // TODO: Implement settings action later
      },
    );
  }
}
