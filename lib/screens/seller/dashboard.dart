import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/seller/booking_list.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Welcome Banner
          Stack(
            children: [
              Image.asset('assets/images/beach.jpg'),
              const Positioned(
                bottom: 20,
                left: 20,
                child: Text(
                  'Welcome back,\nMelissa!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),


          const SizedBox(height: 16),

          // Top Stats: Products & Bookings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoCard(context, '12', 'Products'),
              _infoCard(context, '4', 'Bookings'),
            ],
          ),

          const SizedBox(height: 12),

          // Pending Approval
          // _infoCard(context, '3', 'Pending Approval', isFullWidth: true),
          //
          // const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, String value, String label, {bool isFullWidth = false}) {
    return InkWell(
      onTap: () {
        if (kDebugMode) {
          print('Tapped on $label');
        }
        switch (label) {
          case 'Products':
            Navigator.pushNamed(context, '/products');
            break;
          case 'Bookings':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingListPage()),
            );
            break;
        // case 'Pending Approval':
        //   Navigator.pushNamed(context, '/pending-approval');
        //   break;
        }
      },
      child: Container(
        width: isFullWidth ? double.infinity : 150,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),

    );
  }
}
