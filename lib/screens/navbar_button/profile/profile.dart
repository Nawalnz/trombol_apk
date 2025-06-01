import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import "package:firebase_auth/firebase_auth.dart";
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/theme_notifier.dart'; // Import your onboarding page
import "package:provider/provider.dart";

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    //final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface, // Slightly off-white background
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text("Profile", style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
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
                children: [
                  Text(
                    "Melissa Doe",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mars, Solar System",
                    style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color),
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

          const SizedBox(height: 24),
          const Divider(),

          // Account Settings
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Account Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsTile(Icons.person, "Edit Profile"),
          //_buildSettingsTile(Icons.dark_mode, "Color Mode"),
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child){
              return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text ("Colour Mode"),
                  value: themeNotifier.isDarkMode,
                  onChanged: (value){
                    themeNotifier.toggleTheme(value);
                  },
              );
            },
          ),

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
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Navigate to onboarding and clear all routes
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
