import 'package:flutter/material.dart';
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

  final List<Widget> _pages = const [
    SellerDashboard(),
    UploadProductPage(),
    BookingListPage(),
    ProductDetailPage(), // change this later to a product list screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Set this dynamically if needed
        selectedItemColor: Colors.teal,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/seller-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/upload');
              break;
            case 2:
              Navigator.pushNamed(context, '/bookings');
              break;
            case 3:
              Navigator.pushNamed(context, '/products');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Upload Products'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Manage Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'View Products'),
        ],
      ),

    );
  }
}
