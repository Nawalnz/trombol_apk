import 'package:cloud_firestore/cloud_firestore.dart';
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

  double totalEarnings = 0.0;

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    fetchEarnings();
  }

  Future<void> fetchEarnings() async {
    try {
      const userId = "YOUR_SELLER_USER_ID"; // replace or fetch dynamically
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('sellers') // or your actual collection name
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        double fetchedEarnings = (doc['totalEarnings'] ?? 0).toDouble();

        setState(() {
          totalEarnings = fetchedEarnings;
          // refresh pages to reflect new earnings
          pages[0] = SellerDashboard(totalEarnings: totalEarnings);
        });
      }
    } catch (e) {
      print("Error fetching earnings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SellerDashboard(totalEarnings: totalEarnings),
      const UploadProductPage(),
      const BookingListPage(),
      const ProductDetailPage(
        product: {
          'name': 'Sample Product',
          'price': 'RM100.00',
          'category': 'Adventure',
          'description': 'Test product details',
          'image': 'assets/images/atv.png',
        },
        docId: 'docID',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          onPressed: () {
            _logout(context);
          },
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Onboarding1()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
