import 'package:flutter/material.dart';
import 'package:trombol_apk/screens/homepage/tour_list.dart';

// You can put this in a separate file later if you want
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy recent search data
    final List<String> recentSearches = [
      'Coconut smoothie',
      'Oden fishball',
      'Grilled fish',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Where do you plan to do?',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // TODO: implement search logic
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourListPage(searchKeyword: value),
                      ),
                    );
                  }
                },

              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Search place nearby'),
              subtitle: Text('Current location - Trombol Paradise Beach'),
            ),
            const SizedBox(height: 16),
            const Text('Recently Search', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(recentSearches[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        // TODO: Remove from list logic (disabled for now)
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}