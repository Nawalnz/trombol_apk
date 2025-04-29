import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/screens/onboarding/onboarding2.dart';

import 'package:trombol_apk/screens/seller/booking_list.dart';
import 'package:trombol_apk/screens/seller/product_detail.dart';
import 'package:trombol_apk/screens/seller/seller_main.dart';
import 'package:trombol_apk/screens/seller/upload_product.dart';
import 'screens/seller/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trombol Paradise Beach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),

      // 👇 This will launch the onboarding page first
      initialRoute: '/',

      routes: {
        '/': (context) => const Onboarding1(),               // First screen (onboarding)
        '/next': (context) => const HomePage(),               // 2nd screen (onboarding)
        '/explore': (context) => const ExploreToday(),               // First screen (onboarding)
        '/seller-main': (context) => const SellerMain(),     // Seller's main page
        '/upload': (context) => const UploadProductPage(),   // Upload product page
        '/bookings': (context) => const BookingListPage(),   // View bookings
        '/products': (context) => const ProductDetailPage(), // Product detail
        '/home': (context) => const SellerDashboard(),       // Seller dashboard
      },
    );
  }
}
