import 'package:flutter/material.dart';
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
      // initialRoute: '/login',  // Change this based on testing
        routes: {
          '/': (context) => const SellerDashboard(),
          '/seller-main': (context) => const SellerMain(),
          '/upload': (context) => const UploadProductPage(),
          '/bookings': (context) => const BookingListPage(),
          '/products': (context) => const ProductDetailPage(), // Or your actual product list screen
          '/home': (context) => const SellerDashboard(), // Assuming home = dashboard
        },
    );
  }
}
