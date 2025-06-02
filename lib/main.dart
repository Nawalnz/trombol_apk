import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:trombol_apk/screens/bookplace/tour_detail.dart';
import 'package:trombol_apk/screens/entry.dart';
import 'package:trombol_apk/screens/login/auth_gate.dart';
import 'package:trombol_apk/screens/login/login_user.dart';
import 'package:trombol_apk/screens/navbar_button/profile/profile.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:trombol_apk/theme_notifier.dart';

// screens
import 'package:trombol_apk/screens/homepage/explore.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'package:trombol_apk/screens/onboarding/onboarding2.dart';
import 'package:trombol_apk/screens/seller/booking_list.dart';
import 'package:trombol_apk/screens/seller/product_detail.dart';
import 'package:trombol_apk/screens/seller/seller_main.dart';
import 'package:trombol_apk/screens/seller/upload_product.dart';
import 'screens/seller/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp()
      ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier= Provider.of<ThemeNotifier>(context);


    return MaterialApp(
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      title: 'Trombol Paradise Beach',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: themeNotifier.currentTheme, //from ThemeNotifier

      // --- static, no-arg routes ---
      routes: {
        '/next':        (c) => const Onboarding2(),
        '/explore':     (c) => const ExploreToday(),
        '/tour':        (c) => const TourDetailPage(tourData: {}),
        '/seller-main': (c) => const SellerMain(),
        '/bookings':    (c) => const BookingListPage(),
        '/home':  (c) => const SellerDashboard(),
      },

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/upload':
            return MaterialPageRoute(
              builder: (_) => const UploadProductPage(product: {}, docId: '',
                // product: args['product'] as Map<String, dynamic>? ?? {},
                // docId: args['docId']   as String? ?? '',
              ),
            );

          case '/products':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                // product: args['product'] as Map<String, dynamic>,
                docId: args['docId'] as String, name: '',
              ),
            );

          default:
            return null; // let Flutter show “unknown route”
        }
      },
    );
  }
}