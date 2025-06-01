import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/login/login_user.dart';

import '../homepage/explore.dart';
import '../onboarding/onboarding1.dart';
import '../seller/seller_main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('AuthGate: Waiting for auth state...');
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;

        if (user == null) {
          print("AuthGate: No user detected ➜ showing LoginUser()");
          return const LoginUser();
        }

        print("AuthGate: Authenticated as ${user.uid}");

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              print("AuthGate: Waiting for Firestore user data...");
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (snap.hasError) {
              print("AuthGate: Firestore error: ${snap.error}");
              return const Scaffold(body: Center(child: Text('Error loading user data')));
            }

            if (!snap.hasData || !snap.data!.exists) {
              print("AuthGate: User doc not found");
              return const Scaffold(body: Center(child: Text('User data not found.')));
            }

            final data = snap.data!.data() as Map<String, dynamic>?;
            print("AuthGate: user data = $data");

            if (data == null || !data.containsKey('isAdmin')) {
              return const Scaffold(body: Center(child: Text('Invalid user profile.')));
            }

            final isAdmin = data['isAdmin'] == true;
            print("AuthGate: isAdmin = $isAdmin ➜ Routing to ${isAdmin ? 'SellerMain' : 'ExploreToday'}");

            return isAdmin ? const SellerMain() : const ExploreToday();
          },
        );
      },
    );

  }
}
