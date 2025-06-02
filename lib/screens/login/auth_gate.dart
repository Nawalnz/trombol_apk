import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/login/login_user.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/screens/seller/seller_main.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginUser(); // not logged in
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            if (!snap.hasData || !snap.data!.exists) {
              return const Scaffold(body: Center(child: Text('⚠️ User not found in Firestore')));
            }

            final data = snap.data!.data() as Map<String, dynamic>;
            final isAdmin = data['isAdmin'] == true;

            debugPrint('✅ Routing ${user.email} as ${isAdmin ? 'ADMIN' : 'USER'}');

            // ✅ Just return the screen; DO NOT navigate manually.
            return isAdmin ? const SellerMain() : const ExploreToday();
          },
        );
      },
    );
  }
}
