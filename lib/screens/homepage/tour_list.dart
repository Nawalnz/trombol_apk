import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/tour_detail.dart';

class TourListPage extends StatelessWidget {
  final String searchKeyword;

  const TourListPage({super.key, required this.searchKeyword});

  static const List<Map<String, dynamic>> trips = [
    {
      'title': 'Hiking at Mount Santubong',
      'location': 'Taman Negara Santubong',
      'price': 'from RM150/person',
      'duration': '2 day 1 night',
      'image': 'assets/images/santubong.jpeg',
      'rating': 4.8,
      'reviews': 100,
    },
    {
      'title': 'Kampung Budaya Sarawak',
      'location': 'Pantai Damai Santubong, Kampung Budaya Sarawak',
      'price': 'from RM100/person',
      'duration': 'Day Trip',
      'image': 'assets/images/kgbudaya.jpeg',
      'rating': 4.5,
      'reviews': 360,
    },
    {
      'title': 'Bako National Park',
      'location': 'Bako National Park',
      'price': 'from RM75/person',
      'duration': 'Day Trip',
      'image': 'assets/images/bako.jpeg',
      'rating': 4.4,
      'reviews': 119,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return InkWell(
            onTap: () {
              // pass the real map into tourData
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TourDetailPage(tourData: trip),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        trip['image'] as String,
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip['title'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trip['location'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.orange),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${trip['rating']} (${trip['reviews']} reviews)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trip['price'] as String,
                            style: const TextStyle(color: Colors.teal),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              trip['duration'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}