import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/bookplace/tour_detail.dart';

class TourListPage extends StatelessWidget {
  final String searchKeyword;

  const TourListPage({super.key, required this.searchKeyword});

  @override
  Widget build(BuildContext context) {
    // Dummy tours
    final List<Map<String, dynamic>> dummyTours = [
      {
        'title': 'Borneo Happy Farm',
        'location': 'Kuching, Sarawak',
        'price': 'RM30+',
        'duration': '1 day',
        'image': 'assets/images/borneo_happy_farm.png',
      },
      {
        'title': '2 day 1 night Kuching Tour',
        'location': 'Kuching, Sarawak',
        'price': 'RM350',
        'duration': '2 day 1 night',
        'image': 'assets/images/kch_waterfront.png',
      },
      {
        'title': '1-Day Cultural Museum Tour',
        'location': 'Kuching, Sarawak',
        'price': 'RM20+',
        'duration': '1 day',
        'image': 'assets/images/cultural_museum.png',
      },
    ];

    // Filtering matched tours
    final List<Map<String, dynamic>> matchedTours = dummyTours.where((tour) {
      return tour['title'].toLowerCase().contains(searchKeyword.toLowerCase()) ||
          tour['location'].toLowerCase().contains(searchKeyword.toLowerCase());
    }).toList();

    // int totalResults = matchedTours.length; // <-- Future real database data

    return Scaffold(
      appBar: AppBar(
        title: Text('Place name "$searchKeyword"'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: matchedTours.length,
              itemBuilder: (context, index) {
                final tour = matchedTours[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailPage(tourData: tour),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            tour['image'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tour['title'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.star, size: 14, color: Colors.orange),
                                    Icon(Icons.star, size: 14, color: Colors.orange),
                                    Icon(Icons.star, size: 14, color: Colors.orange),
                                    Icon(Icons.star, size: 14, color: Colors.orange),
                                    Icon(Icons.star_border, size: 14, color: Colors.orange),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tour['location'],
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'from ${tour['price']}/person',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    tour['duration'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // TODO: In future, load more data from database
              },
              child: Text('Show +${matchedTours.length + 15} more available'),
              // Future dynamic from database: 'Show +${totalResults} more available',
            ),
          ),
        ],
      ),
    );
  }
}
