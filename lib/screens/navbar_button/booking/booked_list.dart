import 'package:flutter/material.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  final List<Map<String, dynamic>> trips = const [
    {
      'title': 'Hiking at Mount Santubong',
      'location': 'Taman Negara Santubong',
      'price': 'from RM150/person',
      'duration': '2 day 1 night',
      'image': 'assets/images/santubong.jpeg',
      'rating': 4.8,
      'reviews': 100
    },
    {
      'title': 'Kampung Budaya Sarawak',
      'location': 'Pantai Damai Santubong, Kampung Budaya Sarawak',
      'price': 'from RM100/person',
      'duration': 'Day Trip',
      'image': 'assets/images/kgbudaya.jpeg',
      'rating': 4.5,
      'reviews': 360
    },
    {
      'title': 'Bako National Park',
      'location': 'Bako National Park',
      'price': 'from RM75/person',
      'duration': 'Day Trip',
      'image': 'assets/images/bako.jpeg',
      'rating': 4.4,
      'reviews': 119
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookings")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(trip['image'] as String, width: 100, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(trip['location'] as String),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text('${trip['rating']} (${trip['reviews']} reviews)'),
                      ],
                    ),
                    Text(trip['price'] as String, style: const TextStyle(color: Colors.teal)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(trip['duration'] as String, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
