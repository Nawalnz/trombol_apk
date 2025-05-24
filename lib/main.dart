import 'package:flutter/material.dart';

// firebase dependencies
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// screens
import 'package:trombol_apk/screens/login/reset_pwd.dart';
import 'package:trombol_apk/screens/login/admin_login.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _handleInitialDynamicLink();
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      _onDeepLink(linkData.link);
    }).onError((e) {
      // handle errors
    });
  }

  Future<void> _handleInitialDynamicLink() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) _onDeepLink(data.link);
  }

  void _onDeepLink(Uri deepLink) {
    final code = deepLink.queryParameters['oobCode'];
    if (code != null && _navKey.currentState != null) {
      _navKey.currentState!.push(
        MaterialPageRoute(
          builder: (_) => ResetPassword(oobCode: code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      title: 'Trombol Paradise Beach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/':       (c) => const Onboarding1(),
        '/next':   (c) => const HomePage(),
        '/explore':(c) => const ExploreToday(),
        '/seller-main': (c) => const SellerMain(),
        '/upload': (c) => const UploadProductPage(),
        '/bookings':(c) => const BookingListPage(),
        '/products':(c) => const ProductDetailPage(),
        '/home':   (c) => const SellerDashboard(),
      },
    );
  }
}
