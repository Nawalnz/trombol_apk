import 'package:flutter/material.dart';

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
              _infoCard('12', 'Products'),
              _infoCard('24', 'Bookings'),
            ],
          ),

          const SizedBox(height: 12),

          // Earnings
          _infoCard('RM2,315', 'Addund', isFullWidth: true),

          const SizedBox(height: 12),

          // Pending Approval
          _infoCard('3', 'Pending Approval', isFullWidth: true),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionCard(Icons.add, 'Add Product', context),
              _buildActionCard(Icons.list_alt, 'Manage Booking', context),
              _buildActionCard(Icons.view_list, 'View Product', context),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _infoCard(String value, String label, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : 150,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
    );
  }

  Widget _buildActionCard(IconData icon, String label, BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          if (label == 'Add Product') {
            Navigator.pushNamed(context, '/upload');
          } else if (label == 'Manage Booking') {
            Navigator.pushNamed(context, '/bookings');
          } else if (label == 'View Product') {
            Navigator.pushNamed(context, '/products');
          }
        },
        child: SizedBox(
          width: 90,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: Colors.teal),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

}
