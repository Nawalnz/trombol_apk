import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/navbar_button/profile/edit_profile.dart';
import 'package:trombol_apk/screens/navbar_button/profile/my_booking.dart';
import 'package:trombol_apk/screens/navbar_button/profile/policies.dart';
import 'package:trombol_apk/screens/navbar_button/profile/terms_condi.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/theme_notifier.dart'; // Import your onboarding page
import "package:provider/provider.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String fullName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              CircleAvatar(
                radius: 32,
                backgroundImage: user?.photoURL !=null
                ? NetworkImage(user!.photoURL!)
                : const AssetImage('assets/images/default_profile.png') as ImageProvider,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName.isNotEmpty ? fullName : "No name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? "No email",
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
          _buildSimpleListTile(context, "My Bookings", const MyBookingsPage()),

          const SizedBox(height: 24),
          const Divider(),

          // Account Settings
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text("Account Settings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          _buildSettingsTile(context, Icons.person, "Edit Profile", const EditProfilePage()),
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
          _buildSettingsTile(context, Icons.description, "Terms and Conditions", const TermsConditionsPage()),
          _buildSettingsTile(context, Icons.privacy_tip, "Privacy Policy", const PrivacyPolicyPage()),

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
  Widget _buildSimpleListTile(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  // Tile with icon
  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.normal)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
      },
    );
  }
}
