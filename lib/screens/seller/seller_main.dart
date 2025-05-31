import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/onboarding/onboarding1.dart';
import 'dashboard.dart';
import 'upload_product.dart';
import 'booking_list.dart';
import 'product_detail.dart';

class SellerMain extends StatefulWidget {
  const SellerMain({super.key});

  @override
  State<SellerMain> createState() => _SellerMainState();
}

class _SellerMainState extends State<SellerMain> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Define all your tab pages here:
    final pages = <Widget>[
      const SellerDashboard(),

      // 1) UploadProductPage now requires a `product` map + a `docId`.
      //    For a brand-new product, we pass an empty map + empty ID:
      const UploadProductPage(
        product: <String, dynamic>{},
        docId: '',
      ),

      const BookingListPage(),

      // 2) ProductDetailPage uses the `product:` parameter (not `Product:`)
      const ProductDetailPage(
        // product: <String, dynamic>{
        //   'prod_name': 'Sample Product',
        //   'prod_pricePerPax': 'RM100.00',
        //   'prod_types': 'Adventure',
        //   'prod_desc': 'Test product details',
        //   'image': 'assets/images/atv.png',
        // },
        prod_name: '', docId: '',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: () => _logout(context),
        ),
      ),

      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "Upload"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Product List"),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx, true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Onboarding1()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}